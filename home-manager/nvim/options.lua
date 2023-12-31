vim.wo.number = true
vim.wo.relativenumber = true

vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

vim.cmd [[ colorscheme gruvbox ]]


require("nvim_comment").setup()
