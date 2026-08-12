-- ==========================================
-- 1. 代理环境变量设置（添加条件判断，更具弹性）
-- ==========================================
local proxy_url = "http://127.0.0.1:8118"

-- 只有当本地代理端口确实存活时才启用，或者保留你的硬编码，但加个开关
local enable_proxy = true
if enable_proxy then
    vim.env.HTTP_PROXY = proxy_url
    vim.env.HTTPS_PROXY = proxy_url
    vim.env.http_proxy = proxy_url
    vim.env.https_proxy = proxy_url
end

-- ==========================================
-- 2. 剪贴板与基础配置
-- ==========================================
-- 使用系统剪贴板（Neovim 默认 provider，Windows 下走内置剪贴板）
vim.o.clipboard = "unnamedplus"

-- ==========================================
-- 3. 加载插件管理器
-- ==========================================
require("config.lazy")

if vim.fn.has("win32") == 1 then
    vim.opt.shell = "pwsh"
    vim.opt.shellcmdflag = "-NoProfile -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end
