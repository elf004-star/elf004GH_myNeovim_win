return {
  {
    "saghen/blink.cmp",
    opts = {
      -- 启用自动补全
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          enabled = true,
          auto_show = true, -- 自动显示补全菜单
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
      
      -- 配置补全源
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      
      -- 签名帮助
      signature = {
        enabled = true,
      },
    },
  },
}

