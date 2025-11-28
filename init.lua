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