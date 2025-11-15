-- 启用并配置 noice.nvim - 美化命令行、消息和通知界面
return {
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      -- noice 依赖这两个插件
      "MunifTanjim/nui.nvim",
      -- 可选：如果你想使用 nvim-notify 作为通知后端
      -- "rcarriga/nvim-notify",
    },
    opts = {
      -- 配置 LSP 相关的 UI
      lsp = {
        -- 覆盖 markdown 渲染，使用 Treesitter
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- 需要 hrsh7th/nvim-cmp
        },
        -- 启用悬停文档边框
        hover = {
          enabled = true,
        },
        -- 启用签名帮助边框
        signature = {
          enabled = true,
        },
      },
      -- 预设配置
      presets = {
        bottom_search = true, -- 使用经典的底部命令行进行搜索
        command_palette = true, -- 将命令行定位在屏幕中央
        long_message_to_split = true, -- 长消息将发送到分割窗口
        inc_rename = false, -- 启用 inc-rename.nvim 的输入对话框
        lsp_doc_border = true, -- 为文档悬停和签名帮助添加边框
      },
      -- 配置命令行
      cmdline = {
        enabled = true, -- 启用 Noice 命令行 UI
        view = "cmdline_popup", -- 使用弹出窗口样式的命令行
        format = {
          -- 自定义不同命令的图标
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        },
      },
      -- 配置消息显示
      messages = {
        enabled = true, -- 启用 Noice 消息 UI
        view = "notify", -- 默认视图为通知
        view_error = "notify", -- 错误消息视图
        view_warn = "notify", -- 警告消息视图
        view_history = "messages", -- 查看历史消息时使用 :messages
        view_search = "virtualtext", -- 搜索计数虚拟文本
      },
      -- 配置通知
      notify = {
        enabled = true,
        view = "notify",
      },
      -- 路由规则 - 自定义消息如何显示
      routes = {
        {
          -- 跳过显示 "written" 消息
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          -- 将长消息发送到分割窗口
          filter = {
            event = "msg_show",
            min_height = 20,
          },
          view = "split",
        },
      },
    },
    keys = {
      -- 添加一些有用的快捷键
      { "<leader>sn", "", desc = "+noice" },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },
  },
}

