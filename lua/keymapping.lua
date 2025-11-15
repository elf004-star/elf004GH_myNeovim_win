-- 基础快捷键映射
-- 插入模式下的方向键
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")

-- 快速退出插入模式
vim.keymap.set("i", "jk", "<Esc>")

-- 窗口导航
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })

-- 行首行尾导航
vim.keymap.set({ "n", "x", "o" }, "<S-H>", "^", { desc = "Start of line" })
vim.keymap.set({ "n", "x", "o" }, "<S-L>", "$", { desc = "End of line" })

-- 退出相关
vim.keymap.set({ "n", "x" }, "Q", "<CMD>:qa<CR>", { desc = "Quit all" })
vim.keymap.set({ "n", "x" }, "qq", "<CMD>:q<CR>", { desc = "Quit" })

-- 切换自动换行
vim.keymap.set("n", "<A-z>", "<CMD>set wrap!<CR>", { desc = "Toggle line wrap" })

