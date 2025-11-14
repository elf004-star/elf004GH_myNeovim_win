vim.opt.number=true
vim.wo.cursorline = true
-- Display tabs and trailing spaces
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "-"}

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is  also a good place to setup other settings (vim.opt)

vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
-- vim.opt.autoindent = true
-- vim.opt.smarttab = true
-- vim.opt.smartcase = true
-- vim.opt.ignorecase = true

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")  -- (C:\Users\Allen\AppData\Local\nvim/lua/config/Lazy.lua)
