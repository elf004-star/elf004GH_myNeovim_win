return {
  -- 配置 Python LSP (Pyright)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright 配置
        pyright = {
          enabled = true,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
      },
    },
  },
}

