-- Run from the config directory: nvim --headless -u NONE -i NONE -l tests/git_conflict_browser.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
local git = require "git_conflict_browser.git"
local browser = require "git_conflict_browser"
local temp = vim.fn.tempname()
vim.fn.mkdir(temp, "p")
local repo = temp .. "/repo"
vim.fn.mkdir(repo, "p")
local function eq(a, b)
  assert(vim.deep_equal(a, b), vim.inspect(a) .. " ~= " .. vim.inspect(b))
end
local function run(args)
  local out, err = git.run(repo, args)
  assert(out, err)
  return out
end
local function write(path, bytes)
  local f = assert(io.open(repo .. "/" .. path, "wb"))
  f:write(bytes)
  f:close()
end
local function read(path)
  local f = assert(io.open(repo .. "/" .. path, "rb"))
  local data = f:read "*a"
  f:close()
  return data
end
local messages = {}
vim.notify = function(msg)
  messages[#messages + 1] = msg
end
local answer, prompts = 2, 0
vim.fn.confirm = function()
  prompts = prompts + 1
  return answer
end
local weird = "space tab\tline\n[abc]*.txt"
local paths = { "a.txt", "b.txt", "c.bin", "d.bin", "delete.txt", weird }
local function select(path)
  local entries = assert(git.list(repo))
  for i, entry in ipairs(entries) do
    if entry.path == path then
      vim.api.nvim_win_set_cursor(0, { i + 4, 0 })
      return
    end
  end
  error("Missing conflict: " .. path)
end
local function key(lhs)
  local map = vim.fn.maparg(lhs, "n", false, true)
  assert(map.callback, "Missing mapping " .. lhs)
  map.callback()
end
local function test()
  run { "init", "-b", "main" }
  run { "config", "user.email", "test@example.invalid" }
  run { "config", "user.name", "Test" }
  for _, path in ipairs(paths) do
    write(path, path:match "bin$" and "\0base\255" or "base\n")
  end
  write("unrelated.txt", "base\n")
  run { "add", "." }
  run { "commit", "-qm", "base" }
  run { "checkout", "-qb", "side" }
  for _, path in ipairs(paths) do
    if path == "delete.txt" then
      run { "rm", "--", path }
    else
      write(path, path:match "bin$" and "\0theirs\254" or "theirs\n")
    end
  end
  run { "commit", "-qam", "theirs" }
  run { "checkout", "main" }
  for _, path in ipairs(paths) do
    write(path, path:match "bin$" and "\0ours\253" or "ours\n")
  end
  run { "commit", "-qam", "ours" }
  assert(not git.run(repo, { "merge", "side" }))
  write("unrelated.txt", "unstaged\n")
  eq(#assert(git.list(repo)), 6)
  vim.g.mapleader = " "
  vim.keymap.set("n", "<leader>gc", ':echo "existing"<CR>')
  local existing = vim.fn.maparg("<leader>gc", "n")
  browser.setup()
  eq(vim.fn.maparg("<leader>gc", "n"), existing)
  eq(vim.fn.exists ":GitConflictBrowser", 2)
  vim.fn.mkdir(repo .. "/sub", "p")
  vim.cmd.cd(repo .. "/sub")
  browser.open()
  eq(vim.bo.filetype, "gitconflictbrowser")
  local listbuf = vim.api.nvim_get_current_buf()
  local listwin = vim.api.nvim_get_current_win()
  assert(vim.api.nvim_buf_get_lines(listbuf, 0, 1, false)[1]:find("6 remaining", 1, true))
  key "j"
  eq(vim.api.nvim_win_get_cursor(0)[1], 6)
  key "k"
  eq(vim.api.nvim_win_get_cursor(0)[1], 5)
  select "a.txt"
  key "o"
  eq(read "a.txt", "ours\n")
  eq(vim.api.nvim_win_get_cursor(0)[1], 5)
  eq(#assert(git.list(repo)), 5)
  for _, case in ipairs { { "c.bin", 2, "o" }, { "d.bin", 3, "t" } } do
    local entry = assert(git.entry(repo, case[1]))
    local expected = run { "cat-file", "blob", entry.stages[case[2]].oid }
    select(case[1])
    key(case[3])
    eq(read(case[1]), expected)
    eq(run { "show", ":0:" .. case[1] }, expected)
  end
  select(weird)
  key "t"
  eq(read(weird), "theirs\n")
  select "delete.txt"
  local before = read "delete.txt"
  key "t"
  eq(read "delete.txt", before)
  assert(git.entry(repo, "delete.txt"))
  answer = 2
  key "d"
  assert(git.entry(repo, "delete.txt"))
  answer = 1
  key "d"
  assert(not vim.uv.fs_stat(repo .. "/delete.txt"))
  assert(not git.entry(repo, "delete.txt"))
  select "b.txt"
  answer = 2
  local count = prompts
  key "a"
  eq(prompts, count + 1)
  assert(git.entry(repo, "b.txt"))
  key "<CR>"
  eq(vim.api.nvim_buf_get_name(0), repo .. "/b.txt")
  local editbuf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(editbuf, 0, -1, false, { "manual" })
  browser.open()
  eq(vim.api.nvim_get_current_win(), listwin)
  key "a"
  assert(git.entry(repo, "b.txt"))
  assert(vim.bo[editbuf].modified)
  key "o"
  assert(git.entry(repo, "b.txt"))
  assert(vim.bo[editbuf].modified)
  answer = 1
  key "a"
  eq(read "b.txt", "manual\n")
  assert(not vim.bo[editbuf].modified)
  eq(#assert(git.list(repo)), 0)
  assert(vim.api.nvim_buf_get_lines(listbuf, 0, 1, false)[1]:find("0 remaining", 1, true))
  eq(run { "diff", "--name-only", "-z" }, "unrelated.txt\0")
  key "r"
  key "q"
  browser.open()
  assert(messages[#messages]:find("No conflicts remain", 1, true))
  -- Verify opening based on buffer location even when cwd is outside the repo.
  run { "reset", "--hard", "HEAD" }
  assert(not git.run(repo, { "merge", "side" }))
  vim.cmd.cd(temp)
  browser.open()
  eq(vim.bo.filetype, "gitconflictbrowser")
  select "a.txt"
  key "<CR>"
  local abuf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(abuf, 0, -1, false, { "unsaved" })
  browser.open()
  answer = 1
  key "t"
  eq(vim.api.nvim_buf_get_lines(abuf, 0, -1, false), { "theirs" })
  assert(not vim.bo[abuf].modified)
  -- Explicit override for conflict markers.
  select "b.txt"
  key "a"
  assert(not git.entry(repo, "b.txt"))
  -- A failed checkout must not discard confirmed-but-unsaved buffer edits.
  select "c.bin"
  key "<CR>"
  local cbuf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(cbuf, 0, -1, false, { "precious unsaved" })
  browser.open()
  assert(vim.uv.fs_unlink(repo .. "/c.bin"))
  assert(vim.uv.fs_mkdir(repo .. "/c.bin", 493))
  write("c.bin/obstacle", "keep")
  key "o"
  assert(vim.bo[cbuf].modified)
  eq(vim.api.nvim_buf_get_lines(cbuf, 0, -1, false), { "precious unsaved" })
  assert(git.entry(repo, "c.bin"))
  vim.fn.delete(repo .. "/c.bin", "rf")
  -- Deleted working files must use d, not manual stage.
  select "delete.txt"
  assert(vim.uv.fs_unlink(repo .. "/delete.txt"))
  key "a"
  assert(git.entry(repo, "delete.txt"))
  key "d"
  assert(not git.entry(repo, "delete.txt"))
  -- A Git failure must preserve the UI.
  assert(vim.uv.fs_rename(repo .. "/.git", repo .. "/.git-hidden"))
  key "r"
  key "o"
  eq(vim.bo.filetype, "gitconflictbrowser")
  assert(vim.uv.fs_rename(repo .. "/.git-hidden", repo .. "/.git"))
  browser.close()
  vim.cmd.enew()
  browser.open()
  assert(messages[#messages]:find("No Git repository", 1, true))
  local out = git.run(temp, { "not-a-command" })
  eq(out, nil)
  -- Binary marker-looking data must never be considered text.
  write("markers.bin", "\0<<<<<<< ours\n=======\n>>>>>>> theirs\n")
  eq(git.inspect(repo, "markers.bin"), { binary = true, markers = false })
  write(".gitattributes", "*.asset -diff\n")
  write("markers.asset", "<<<<<<< opaque\n")
  eq(git.inspect(repo, "markers.asset"), { binary = true, markers = false })
  -- All stage combinations are classified without relying on line-delimited output.
  eq(git.parse("100644 abc 1\tx\0" .. "100644 def 3\tx\0")[1].status, "deleted by us")
end
local ok, err = xpcall(test, debug.traceback)
vim.fn.delete(temp, "rf")
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd "cquit 1"
end
print "PASS: Git conflict browser integration smoke tests"
vim.cmd "qa!"
