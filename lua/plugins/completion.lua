return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'williamboman/mason.nvim',
  },
  event = { 'BufReadPost', 'BufNewFile' },
  version = '1.*',
  -- build = 'cargo build --release',
  opts = {
    keymap = {
      preset = 'default',
      -- 添加文档滚动快捷键
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = {
      -- 启用自动显示文档
      documentation = {
        auto_show = true,
        window = {
          border = 'single',
          scrollbar = false,
        },
      },
      -- 补全菜单配置
      menu = {
        border = 'single',
        auto_show = true,
        auto_show_delay_ms = 0,
        scrollbar = false,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        snippets = {
          score_offset = 1000,
          -- 避免在 . " ' 等字符后触发 snippets
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },

      },

    },
    signature = {
      enabled = true,
    },
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
  },
  opts_extend = { "sources.default" },

  config = function(_, opts)
    -- Setup blink.cmp
    require('blink.cmp').setup(opts)

    -- LSP Configuration using Neovim 0.11+ built-in vim.lsp.config API
    -- No nvim-lspconfig plugin needed!

    -- Configure diagnostics
    vim.diagnostic.config({
      underline = false,
      signs = false,
      update_in_insert = false,
      virtual_text = { spacing = 2, prefix = "●" },
      severity_sort = true,
      float = {
        border = "rounded",
      },
    })

    -- Setup keymaps when LSP attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- vim.keymap.set("n", "K", vim.lsp.buf.hover) -- configured in "nvim-ufo" plugin
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
          buffer = ev.buf,
          desc = "[LSP] Show diagnostic",
        })
        vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[LSP] Add workspace folder" })
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "[LSP] Remove workspace folder" })
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { desc = "[LSP] List workspace folders" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[LSP] Rename" })
      end,
    })

    -- Get LSP capabilities from blink.cmp
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Configure language servers
    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
      capabilities = capabilities,
    })

    vim.lsp.config('clangd', {
      cmd = { 'clangd' },
      root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
      capabilities = capabilities,
    })

    -- Auto-enable LSP servers for appropriate filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'lua' },
      callback = function()
        vim.lsp.enable('lua_ls')
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
      callback = function()
        vim.lsp.enable('clangd')
      end,
    })
  end,
}
