return {
  -- 配置 Mason 工具管理器
  {
    "williamboman/mason.nvim",
    opts = {
      -- 禁用 tree-sitter-cli 的自动安装
      -- Mason 会尝试自动安装 tree-sitter-cli，但在 Windows 上经常出现问题
      -- 我们使用 nvim-treesitter 内置的编译功能（通过 Zig），不需要 tree-sitter-cli
      ensure_installed = {
        -- 只保留需要的工具，不包括 tree-sitter-cli
        -- 如果需要其他工具，可以在这里添加
      },
    },
  },
  -- 配置 mason-lspconfig 以防止自动安装 tree-sitter-cli
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- 确保不会自动安装 tree-sitter-cli
      automatic_installation = {
        exclude = { "tree-sitter-cli" },
      },
    },
  },
}

