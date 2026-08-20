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

vim.opt.showtabline = 2

vim.opt.cursorline = true

vim.opt.hlsearch = true   -- Highlight all search matches
vim.opt.incsearch = true  -- Show matches as you type the search

vim.opt.modeline = true

vim.o.wildoptions = "pum,fuzzy"

-- Report the active buffer's filename to the terminal, so the kitty tab shows
-- it instead of the command line nvim was started with (e.g. "nvim -S ...").
vim.opt.title = true
vim.opt.titlestring = "%{expand('%:t') == '' ? '[No Name]' : expand('%:t')}%( %m%)"

vim.filetype.add({
  extension = {
    sjs = 'javascript',
  },
})

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

-- Highlight real tab characters
vim.api.nvim_set_hl(0, "TabChar", { bg = "darkblue" })

-- Highlight TODO comments
vim.api.nvim_set_hl(0, "TodoHighlight", { fg = "#000000", bg = "#FFD700", bold = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "WinEnter", "InsertEnter" }, {
  callback = function()
    vim.fn.matchadd("TabChar", [[\t]])
    vim.fn.matchadd("TodoHighlight", [[TODO]])
  end,
})

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
  {
    "echasnovski/mini.comment",
    version = false,
    opts = {},
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate'
  }
})

vim.cmd.colorscheme("catppuccin-mocha")

-- Highlight the title bar (label) of the currently active tab.
-- Re-apply on every colorscheme load so it survives theme changes.
local function highlight_active_tab()
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#1e1e2e", bg = "#cba6f7", bold = true })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = highlight_active_tab })
highlight_active_tab()

-- Make split/vsplit borders easy to see: heavy box-drawing glyphs in a bright
-- color instead of catppuccin's dim gray. Horizontal borders are drawn by the
-- per-window statusline, so brighten that too.
vim.opt.fillchars:append({
  vert = "┃",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
})

local function highlight_splits()
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#b4befe", bold = true })
  -- Statusline of the focused window: bright bar marking the active split.
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#1e1e2e", bg = "#b4befe", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#1e1e2e", bg = "#585b70" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = highlight_splits })
highlight_splits()

-- the title won't wrap into the second line in a git commit.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.formatoptions:remove("t")
  end,
})

-- Enable // comment continuation in HTML files (for <script> tags)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.comments:append("://")
    -- r: auto-insert comment leader on Enter in insert mode
    -- o: auto-insert comment leader on 'o'/'O' in normal mode
    vim.opt_local.formatoptions:append("ro")
  end,
})

-- gC: wrap the visual selection in block comment markers, in place.
-- mini.comment's gc/gcc are linewise only; this handles partial selections,
-- e.g. selecting `+ 1` in `int a = b + 1;` gives `int a = b /*+ 1*/;`.
local block_comment_markers = {
  c = { "/*", "*/" },          cpp = { "/*", "*/" },
  objc = { "/*", "*/" },       objcpp = { "/*", "*/" },
  java = { "/*", "*/" },       rust = { "/*", "*/" },
  go = { "/*", "*/" },         javascript = { "/*", "*/" },
  javascriptreact = { "/*", "*/" }, typescript = { "/*", "*/" },
  typescriptreact = { "/*", "*/" }, css = { "/*", "*/" },
  scss = { "/*", "*/" },       less = { "/*", "*/" },
  php = { "/*", "*/" },        sql = { "/*", "*/" },
  lua = { "--[[", "]]" },
  html = { "<!--", "-->" },    xml = { "<!--", "-->" },
  markdown = { "<!--", "-->" },
  python = { '"""', '"""' },
}

-- Byte offset just past the character starting at byte `col` (handles multibyte).
local function byte_after_char(line, col)
  local ci = vim.fn.charidx(line, col)
  if ci < 0 then return #line end
  local bi = vim.fn.byteidx(line, ci + 1)
  if bi < 0 then return #line end
  return bi
end

vim.keymap.set("x", "gC", function()
  local markers = block_comment_markers[vim.bo.filetype]
  if not markers then
    vim.notify("No block comment markers for filetype " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  -- Leave visual mode so the '< and '> marks are set.
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  local srow, scol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local erow, ecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local last_line = vim.api.nvim_buf_get_lines(0, erow - 1, erow, true)[1]
  local eend = byte_after_char(last_line, ecol)
  -- Close first: inserting at the start would shift the end column on one-line
  -- selections.
  vim.api.nvim_buf_set_text(0, erow - 1, eend, erow - 1, eend, { markers[2] })
  vim.api.nvim_buf_set_text(0, srow - 1, scol, srow - 1, scol, { markers[1] })
end, { desc = "Block comment selection in place" })

-- :Q -> :q
vim.cmd([[
  cnoreabbrev <expr> W  getcmdtype()==':' && getcmdline()=='W'  ? 'w'  : 'W'
  cnoreabbrev <expr> WQ getcmdtype()==':' && getcmdline()=='WQ' ? 'wq' : 'WQ'
  cnoreabbrev <expr> Wq getcmdtype()==':' && getcmdline()=='Wq' ? 'wq' : 'Wq'
  cnoreabbrev <expr> Q  getcmdtype()==':' && getcmdline()=='Q'  ? 'q'  : 'Q'
  cnoreabbrev <expr> Qa getcmdtype() == ':' && getcmdline() == 'Qa' ? 'qa' : 'Qa'
  cnoreabbrev <expr> Xa getcmdtype() == ':' && getcmdline() == 'Xa' ? 'xa' : 'Xa'
]])
