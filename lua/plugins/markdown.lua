return {
  -- 禁用 Markdown LSP 服务器（如果不需要的话）
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 禁用 marksman（Markdown LSP）
        marksman = {
          enabled = false,
        },
        -- 禁用 markdown_oxide（另一个 Markdown LSP）
        markdown_oxide = {
          enabled = false,
        },
      },
    },
  },
}

