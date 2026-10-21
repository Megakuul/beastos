local M = {}

-- All paths are literal pathspecs; all processes use argv, never a shell.
function M.run(root, args)
  if not vim.system then
    return nil, "GitConflictBrowser requires Neovim 0.10+"
  end
  local argv = { "git", "--literal-pathspecs", "-C", root }
  vim.list_extend(argv, args)
  local ok, result = pcall(function()
    return vim.system(argv, { text = false }):wait()
  end)
  if not ok then
    return nil, tostring(result)
  end
  if result.code ~= 0 then
    return nil, (result.stderr ~= "" and result.stderr or result.stdout)
  end
  return result.stdout
end

function M.root(dir)
  local out, err = M.run(dir, { "rev-parse", "--show-toplevel" })
  return out and out:gsub("\n$", ""), err
end

local statuses = {
  ["123"] = "both modified",
  ["23"] = "both added",
  ["12"] = "deleted by them",
  ["13"] = "deleted by us",
  ["1"] = "both deleted",
  ["2"] = "added by us",
  ["3"] = "added by them",
}
function M.parse(output)
  local by_path, entries = {}, {}
  for record in output:gmatch "([^%z]+)%z" do
    local mode, oid, stage, path = record:match "^(%d+) (%x+) (%d)\t(.*)$"
    if path then
      local entry = by_path[path]
      if not entry then
        entry = { path = path, stages = {} }
        by_path[path] = entry
        entries[#entries + 1] = entry
      end
      entry.stages[tonumber(stage)] = { mode = mode, oid = oid }
    end
  end
  table.sort(entries, function(a, b)
    return a.path < b.path
  end)
  for _, entry in ipairs(entries) do
    local key = ""
    for i = 1, 3 do
      if entry.stages[i] then
        key = key .. i
      end
    end
    entry.status = statuses[key] or "unmerged"
  end
  return entries
end
function M.list(root)
  local out, err = M.run(root, { "ls-files", "--unmerged", "-z" })
  if not out then
    return nil, err
  end
  return M.parse(out)
end
function M.entry(root, path)
  local entries, err = M.list(root)
  if not entries then
    return nil, err
  end
  for _, entry in ipairs(entries) do
    if entry.path == path then
      return entry
    end
  end
  return nil, "Path is no longer unmerged; refresh the browser."
end
function M.take(root, path, stage)
  local entry, err = M.entry(root, path)
  if not entry then
    return nil, err
  end
  local side = entry.stages[stage]
  if not side then
    return nil,
      "Stage "
        .. stage
        .. " does not exist (this side deleted the file). Use d to confirm deletion, or choose the existing side."
  end
  if side.mode == "160000" then
    return nil, "Submodule conflict: resolve the submodule manually, then stage with a."
  end
  local stat = vim.uv.fs_lstat(root .. "/" .. path)
  if stat and stat.type == "directory" then
    return nil, "A directory now occupies this path; move it aside manually before replacing the file."
  end
  local out
  out, err = M.run(root, { "checkout-index", "--force", "--stage=" .. stage, "--", path })
  if not out then
    return nil, err
  end
  out, err = M.run(root, { "add", "--", path })
  return out, err, true
end
function M.stage(root, path)
  return M.run(root, { "add", "--", path })
end
function M.delete(root, path)
  return M.run(root, { "rm", "--", path })
end

-- Check attributes and NUL bytes before doing any text marker inspection.
function M.inspect(root, path)
  local full = root .. "/" .. path
  local stat = vim.uv.fs_lstat(full)
  if not stat then
    return nil, "File is missing. Use d to resolve as deleted."
  end
  if stat.type ~= "file" then
    return { binary = true, markers = false }
  end
  local attrs, err = M.run(root, { "check-attr", "-z", "diff", "--", path })
  if not attrs then
    return nil, err
  end
  if attrs:match "%zunset%z$" then
    return { binary = true, markers = false }
  end
  local file, read_err = io.open(full, "rb")
  if not file then
    return nil, read_err
  end
  local data = file:read "*a"
  file:close()
  if data:find("\0", 1, true) then
    return { binary = true, markers = false }
  end
  local markers = false
  -- Includes diff3/zdiff3 ancestors and configurable marker widths >= 7.
  for line in (data .. "\n"):gmatch "([^\n]*)\n" do
    if line:match "^<<<<<<<" or line:match "^|||||||" or line:match "^=======" or line:match "^>>>>>>>" then
      markers = true
      break
    end
  end
  return { binary = false, markers = markers }
end
return M
