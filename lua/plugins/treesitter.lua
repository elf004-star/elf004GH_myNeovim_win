return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- 确保 jsonc 在安装列表中
      if opts.ensure_installed then
        if type(opts.ensure_installed) == "table" then
          if not vim.tbl_contains(opts.ensure_installed, "jsonc") then
            table.insert(opts.ensure_installed, "jsonc")
          end
        end
      end

      -- 配置解析器下载选项
      opts.parser_install_dir = nil -- 使用默认目录

      -- 配置 curl 使用代理
      local install = require("nvim-treesitter.install")

      -- 设置 curl 命令使用代理
      install.command_extra_args = {
        curl = {
          "--proxy", "http://127.0.0.1:8118",
          "--connect-timeout", "60",
          "--max-time", "300",
        }
      }

      -- 关键修复：强制使用 Zig cc 模式，完全绕过 tree-sitter-cli
      -- 这是解决 EBUSY 错误的终极方案
      if vim.fn.executable("zig") == 1 then
        -- 使用 zig cc 作为 C 编译器，完全绕过 Node.js 的 tree-sitter-cli
        install.compilers = { "zig" }

        -- 强制使用 C 编译模式而不是 tree-sitter CLI
        install.prefer_git = true

        vim.notify("nvim-treesitter 使用 Zig 编译器（推荐）", vim.log.levels.INFO)
      elseif vim.fn.executable("gcc") == 1 then
        install.compilers = { "gcc" }
        install.prefer_git = true
        vim.notify("nvim-treesitter 使用 GCC 编译器", vim.log.levels.INFO)
      elseif vim.fn.executable("cl") == 1 then
        install.compilers = { "cl" }
        install.prefer_git = true
        vim.notify("nvim-treesitter 使用 MSVC 编译器", vim.log.levels.INFO)
      else
        vim.notify("警告: 未找到 C 编译器。强烈建议安装 Zig 以避免 EBUSY 错误", vim.log.levels.WARN)
        vim.notify("安装命令: scoop install zig 或 choco install zig", vim.log.levels.WARN)
      end

      -- 禁用自动安装，避免启动时的 EBUSY 错误
      opts.auto_install = false

      vim.notify("nvim-treesitter 已配置使用代理: http://127.0.0.1:8118", vim.log.levels.INFO)
    end,
    build = function()
      -- 确认代理环境变量已设置
      local http_proxy = vim.env.HTTP_PROXY or vim.env.http_proxy
      local https_proxy = vim.env.HTTPS_PROXY or vim.env.https_proxy

      if http_proxy or https_proxy then
        vim.notify("检测到代理设置 - HTTP: " .. (http_proxy or "未设置") .. ", HTTPS: " .. (https_proxy or "未设置"), vim.log.levels.INFO)
      else
        vim.notify("警告: 未检测到代理环境变量", vim.log.levels.WARN)
      end
    end,
  },
}

