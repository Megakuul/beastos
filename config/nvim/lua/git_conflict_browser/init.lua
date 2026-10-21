local M = {}
local git = require "git_conflict_browser.git"
local api = vim.api
local defaults = {
  mapping = "<leader>gc",
  window = { height = 14, position = "botright" },
  keymaps = {
    ours = "o",
    theirs = "t",
    edit = "<CR>",
    stage = "a",
    delete = "d",
    refresh = "r",
    close = "q",
    help = "?",
  },
}
local config = vim.deepcopy(defaults)
local state
local function notify(message, level)
  vim.notify("GitConflictBrowser: " .. tostring(message), level or vim.log.levels.INFO)
end
local function confirm(message)
  return vim.fn.confirm(message, "&Yes\n&No", 2) == 1
end
local function valid(win)
  return win and api.nvim_win_is_valid(win)
end
local function selected()
  if not state or not valid(state.win) then
    return
  end
  local index = api.nvim_win_get_cursor(state.win)[1] - 4
  return state.entries[index], index
end
local function help()
  local k = config.keymaps
  return string.format(
    "%s ours | %s theirs | %s edit | %s stage | %s delete | %s refresh | %s close",
    k.ours or "off",
    k.theirs or "off",
    k.edit or "off",
    k.stage or "off",
    k.delete or "off",
    k.refresh or "off",
    k.close or "off"
  )
end
local function render(index)
  local lines = {
    ("Git conflicts: %d remaining — %s"):format(#state.entries, vim.fn.strtrans(state.root)),
    help(),
    "ours = stage 2; theirs = stage 3 (during rebase: ours is the rebased-onto side)",
    "Enter edits in another window; return with <C-w>p or :GitConflictBrowser",
  }
  for _, entry in ipairs(state.entries) do
    lines[#lines + 1] = ("  %-18s %s"):format(entry.status, vim.fn.strtrans(entry.path))
  end
  if #state.entries == 0 then
    lines[5] = "  No conflicts remain."
  end
  vim.bo[state.buf].modifiable = true
  api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
  api.nvim_win_set_cursor(state.win, { 4 + math.max(1, math.min(index or 1, #state.entries)), 0 })
end
function M.refresh()
  if not state or not valid(state.win) then
    return
  end
  local entry, index = selected()
  local entries, err = git.list(state.root)
  if not entries then
    notify(err, vim.log.levels.ERROR)
    return
  end
  state.entries = entries
  for i, item in ipairs(entries) do
    if entry and item.path == entry.path then
      index = i
      break
    end
  end
  render(index)
end
local function buffers(path)
  local result = {}
  local real = vim.uv.fs_realpath(path) or path
  for _, buf in ipairs(api.nvim_list_bufs()) do
    local name = api.nvim_buf_get_name(buf)
    if api.nvim_buf_is_loaded(buf) and (name == path or (vim.uv.fs_realpath(name) or name) == real) then
      result[#result + 1] = buf
    end
  end
  return result
end
local function reload(bufs)
  for _, buf in ipairs(bufs) do
    local ok, err = pcall(api.nvim_buf_call, buf, function()
      vim.cmd "edit!"
    end)
    if not ok then
      notify("Disk changed; reload buffer manually: " .. tostring(err), vim.log.levels.WARN)
    end
  end
end
function M.action(action)
  local entry = selected()
  if not entry then
    return
  end
  local path = state.root .. "/" .. entry.path
  if action == "edit" then
    local target = state.origin
    if not valid(target) or target == state.win then
      vim.cmd "aboveleft new"
      target = api.nvim_get_current_win()
      state.origin = target
    end
    local ok, err = pcall(function()
      local buf = vim.fn.bufadd(path)
      vim.fn.bufload(buf)
      api.nvim_set_current_win(target)
      api.nvim_win_set_buf(target, buf)
    end)
    if not ok then
      notify(err, vim.log.levels.ERROR)
    end
    return
  end
  local current, err = git.entry(state.root, entry.path)
  if not current then
    notify(err, vim.log.levels.WARN)
    return
  end
  if (action == "ours" or action == "theirs") and not current.stages[action == "ours" and 2 or 3] then
    notify("Requested side has no file. Use d to confirm deletion, or choose the existing side.", vim.log.levels.WARN)
    return
  end
  local bufs = buffers(path)
  for _, buf in ipairs(bufs) do
    if vim.bo[buf].modified then
      if action == "stage" then
        if not confirm "Unsaved edits: save this buffer before staging?" then
          return
        end
        local ok, save_err = pcall(api.nvim_buf_call, buf, function()
          vim.cmd "write"
        end)
        if not ok or vim.bo[buf].modified then
          notify(save_err or "Buffer remains modified", vim.log.levels.ERROR)
          return
        end
      elseif not confirm("Discard unsaved buffer edits and replace/delete " .. vim.fn.strtrans(entry.path) .. "?") then
        return
      end
    end
  end
  local out, changed
  if action == "stage" then
    local info
    info, err = git.inspect(state.root, entry.path)
    if not info then
      notify(err, vim.log.levels.WARN)
      return
    end
    if
      info.markers and not confirm("Conflict markers remain in " .. vim.fn.strtrans(entry.path) .. ". Stage anyway?")
    then
      return
    end
    out, err = git.stage(state.root, entry.path)
  elseif action == "delete" then
    if not confirm("Resolve as deleted: git rm -- " .. vim.fn.strtrans(entry.path) .. "?") then
      return
    end
    out, err = git.delete(state.root, entry.path)
  else
    out, err, changed = git.take(state.root, entry.path, action == "ours" and 2 or 3)
  end
  -- checkout may succeed even if staging fails; always synchronize loaded buffers.
  if action ~= "stage" and (out or changed) then
    reload(bufs)
  end
  if not out then
    notify(err, vim.log.levels.ERROR)
    return
  end
  M.refresh()
end
function M.close()
  if state and valid(state.win) then
    local origin = state.origin
    api.nvim_win_close(state.win, true)
    if valid(origin) then
      api.nvim_set_current_win(origin)
    end
  end
  state = nil
end
function M.open()
  if not vim.system then
    notify("Requires Neovim 0.10+", vim.log.levels.ERROR)
    return
  end
  if state and valid(state.win) then
    api.nvim_set_current_win(state.win)
    M.refresh()
    return
  end
  local name = api.nvim_buf_get_name(0)
  local root = name ~= "" and git.root(vim.fn.fnamemodify(name, ":h")) or nil
  root = root or git.root(vim.fn.getcwd())
  if not root then
    notify("No Git repository found for this buffer or working directory.", vim.log.levels.WARN)
    return
  end
  local entries, err = git.list(root)
  if not entries then
    notify(err, vim.log.levels.ERROR)
    return
  end
  if #entries == 0 then
    notify "No conflicts remain."
    return
  end
  local origin = api.nvim_get_current_win()
  vim.cmd(
    (config.window.position == "topleft" and "topleft" or "botright")
      .. " "
      .. math.max(5, config.window.height)
      .. "new"
  )
  state = {
    root = root,
    entries = entries,
    origin = origin,
    win = api.nvim_get_current_win(),
    buf = api.nvim_get_current_buf(),
  }
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].bufhidden = "wipe"
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].filetype = "gitconflictbrowser"
  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].wrap = false
  vim.wo[state.win].cursorline = true
  local function map(key, fn, desc)
    if key then
      vim.keymap.set("n", key, fn, { buffer = state.buf, nowait = true, silent = true, desc = desc })
    end
  end
  for _, action in ipairs { "ours", "theirs", "stage", "delete", "edit" } do
    map(config.keymaps[action], function()
      M.action(action)
    end, "Git conflict: " .. action)
  end
  map(config.keymaps.refresh, M.refresh, "Refresh conflicts")
  map(config.keymaps.close, M.close, "Close conflicts")
  map(config.keymaps.help, function()
    notify(help() .. "\nReturn from editing: <C-w>p or :GitConflictBrowser")
  end, "Conflict help")
  local function move(delta)
    local _, index = selected()
    render(math.max(1, math.min(#state.entries, (index or 1) + delta * vim.v.count1)))
  end
  map("j", function()
    move(1)
  end, "Next conflict")
  map("k", function()
    move(-1)
  end, "Previous conflict")
  map("<Down>", function()
    move(1)
  end, "Next conflict")
  map("<Up>", function()
    move(-1)
  end, "Previous conflict")
  render(1)
end
function M.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
  api.nvim_create_user_command(
    "GitConflictBrowser",
    M.open,
    { desc = "Browse and resolve unmerged Git files", force = true }
  )
  if config.mapping then
    if vim.fn.maparg(config.mapping, "n") == "" then
      vim.keymap.set("n", config.mapping, M.open, { desc = "Git conflict browser" })
    else
      notify("Preserving existing " .. config.mapping .. " mapping; use :GitConflictBrowser.")
    end
  end
end
return M
