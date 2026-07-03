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
-- 2. Lemonade Server 异步启动（静默优化版）
-- ==========================================
local lemonade_stderr = {}

vim.fn.jobstart({ "lemonade", "server" }, {
    detach = true,
    on_stderr = function(_, data)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    table.insert(lemonade_stderr, line)
                end
            end
        end
    end,
    on_exit = function(_, exit_code)
        -- 异步任务退出时立即拼接错误
        local stderr_text = table.concat(lemonade_stderr, " "):lower()

        if exit_code ~= 0 then
            -- 如果是因为端口占用导致的退出，我们选择“保持安静”，不弹窗
            if stderr_text:find("already") or stderr_text:find("in use") or stderr_text:find("bind") then
            -- Keep silent. 说明后台本来就有，不需要打扰用户
            else
                -- 真正的启动失败才报 ERROR
                vim.schedule(function()
                    vim.notify("Lemonade server 启动失败: " .. stderr_text, vim.log.levels.ERROR)
                end)
            end
        end
    end,
})

-- 取消了之前的延迟 800ms 成功通知，只要没报错，默默运行就是最好的体验

-- ==========================================
-- 3. 剪贴板与基础配置
-- ==========================================
-- 显式配置 clipboard provider，确保 Neovim 完美对接 lemonade
vim.g.clipboard = {
    name = "lemonade",
    copy = {
        ["+"] = "lemonade copy",
        ["*"] = "lemonade copy",
    },
    paste = {
        ["+"] = "lemonade paste",
        ["*"] = "lemonade paste",
    },
    cache_enabled = 0,
}

vim.o.clipboard = "unnamedplus"

-- ==========================================
-- 4. 加载插件管理器
-- ==========================================
require("config.lazy")

if vim.fn.has("win32") == 1 then
    vim.opt.shell = "pwsh"
    vim.opt.shellcmdflag = "-NoProfile -Command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end
