local sound_dir = vim.fn.stdpath "config" .. "/sounds/"
local player = "paplay"

local function play_sound(file)
  vim.fn.jobstart({ player, sound_dir .. file }, { detach = true })
end

insert_sounds = { "glass1.ogg", "glass2.ogg", "glass3.ogg" }

vim.api.nvim_create_autocmd("InsertCharPre", {
  callback = function()
    play_sound(insert_sounds[math.random(#insert_sounds)])
  end,
})

delete_sounds = { "metalLatch.ogg" }
copy_sounds = { "select_005.ogg" }
cut_sounds = { "chop.ogg" }

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "d" then
      play_sound(delete_sounds[math.random(#delete_sounds)])
    elseif vim.v.event.operator == "c" then
      play_sound(cut_sounds[math.random(#cut_sounds)])
    elseif vim.v.event.operator == "y" then
      play_sound(copy_sounds[math.random(#copy_sounds)])
    end
  end,
})

open_sounds = { "drawKnife1.ogg", "drawKnife2.ogg", "drawKnife3.ogg" }

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
  callback = function()
    play_sound(open_sounds[math.random(#open_sounds)])
  end,
})

save_sounds = { "handleSmallLeather.ogg", "handleSmallLeather2.ogg" }

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    play_sound(save_sounds[math.random(#save_sounds)])
  end,
})

move_sounds = { "drop_002.ogg", "drop_003.ogg" }

local move_keys = { "h", "j", "k", "l", "<PageDown>", "<PageUp>", "<C-d>", "<C-u>" }

for _, key in ipairs(move_keys) do
  vim.keymap.set("n", key, function()
    play_sound(move_sounds[math.random(#move_sounds)])
    return key
  end, { expr = true })
end
