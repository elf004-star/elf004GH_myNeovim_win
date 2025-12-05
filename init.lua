-- 启动 lemonade server（若未运行）
local lemonade_stderr = {}
local lemonade_failed = false
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
  on_exit = function()
    lemonade_failed = true
    vim.defer_fn(function()
      local stderr_text = table.concat(lemonade_stderr, " "):lower()
      if stderr_text:find("already") or stderr_text:find("in use") or stderr_text:find("bind") then
        vim.notify("Lemonade server 已在运行", vim.log.levels.INFO)
      else
        vim.notify("Lemonade server 启动失败: " .. table.concat(lemonade_stderr, " "), vim.log.levels.ERROR)
      end
    end, 600)
  end,
})
-- 延迟检查：如果进程没有退出，说明启动成功
vim.defer_fn(function()
  if not lemonade_failed then
    vim.notify("Lemonade server 启动成功", vim.log.levels.INFO)
  end
end, 800)

-- 设置代理环境变量，让 curl 能够使用代理
-- HTTP 和 HTTPS 代理设置为本地 8118 端口
vim.env.HTTP_PROXY = "http://127.0.0.1:8118"
vim.env.HTTPS_PROXY = "http://127.0.0.1:8118"
vim.env.http_proxy = "http://127.0.0.1:8118"
vim.env.https_proxy = "http://127.0.0.1:8118"

-- 如果需要使用 SOCKS5 代理，可以取消下面的注释
-- vim.env.ALL_PROXY = "socks5://127.0.0.1:1080"
-- vim.env.all_proxy = "socks5://127.0.0.1:1080"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.o.clipboard = "unnamedplus"