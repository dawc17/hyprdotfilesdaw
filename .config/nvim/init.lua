vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

local opts = { noremap = true }

vim.keymap.set('n', '<C-h>', '<C-W>h', opts)
vim.keymap.set('n', '<C-j>', '<C-W>j', opts)
vim.keymap.set('n', '<C-k>', '<C-W>k', opts)
vim.keymap.set('n', '<C-l>', '<C-W>l', opts)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>n", ":Neotree filesystem reveal left<CR>")
vim.keymap.set("n", "<C-n>", ":Neotree filesystem close<CR>")
vim.keymap.set("n", "<leader>cc", ":CopilotChatToggle<CR>")

require("config.lazy")

---@diagnostic disable-next-line: different-requires
require("lazy").setup("plugins")
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
