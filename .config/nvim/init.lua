vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cc = "80"

vim.opt.cursorline = true

vim.opt.hlsearch = true   -- Highlight all search matches
vim.opt.incsearch = true  -- Show matches as you type the search

vim.opt.modeline = true

-- map Ctrl+j/k to the previous/next tab
vim.keymap.set("n", "<C-j>", "gT", { desc = "Previous tab" })
vim.keymap.set("n", "<C-k>", "gt", { desc = "Next tab" })

vim.keymap.set("i", "<C-j>", "<Esc>gTa", { desc = "Previous tab" })
vim.keymap.set("i", "<C-k>", "<Esc>gta", { desc = "Next tab" })

-- map tt, tm
vim.keymap.set("n", "tt", ":tabedit ")
vim.keymap.set("n", "tm", ":tabm ")

-- Highlight trailing whitespace
vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "red" })

vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "WinEnter" }, {
  callback = function()
    vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.fn.matchadd("ExtraWhitespace", [[\s\+\%#\@<!$]])
  end,
})

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
})

vim.cmd.colorscheme("catppuccin-mocha")

-- the title won't wrap into the second line in a git commit.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.formatoptions:remove("t")
  end,
})
