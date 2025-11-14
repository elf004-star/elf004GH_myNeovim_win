# Neovim LSP 配置问题解决方案

## 问题

### 症状表现

运行 `:checkhealth lsp` 或 `:LspInfo` 时显示:
- ✗ **No active clients** (没有活动的 LSP 客户端)
- ✓ LSP log level: WARN
- ✓ Enabled Configurations (配置已启用)
- ✗ 但实际上没有任何 LSP 服务器在运行

### 具体现象

```
vim.lsp: Active Clients ~
- No active clients

vim.lsp: Enabled Configurations ~

vim.lsp: File Watcher ~
- file watching "(workspace/didChangeWatchedFiles)" disabled on all clients

vim.lsp: Position Encodings ~
- No active clients
```

打开 Lua 或 C/C++ 文件时:
- 没有代码补全
- 没有语法检查
- 没有 LSP 功能(跳转定义、重命名等)

---

## 原因

### 根本原因

配置文件中**只安装和配置了 LSP 相关插件,但从未实际启动任何 LSP 服务器**。

### 详细分析

1. **缺少 LSP 服务器启动代码**
   - 只配置了 `mason.nvim` 来安装 LSP 服务器
   - 只配置了 `nvim-lspconfig` 插件
   - 只配置了 LSP 快捷键绑定
   - **但从未调用任何函数来启动 LSP 服务器**

2. **使用了过时的 nvim-lspconfig API** (次要问题)
   - 在 Neovim 0.11+ 中,`require('lspconfig')` 框架已被弃用
   - 会产生警告信息:
     ```
     The `require('lspconfig')` "framework" is deprecated, 
     use vim.lsp.config (see :help lspconfig-nvim-0.11) instead.
     Feature will be removed in nvim-lspconfig v3.0.0
     ```

3. **blink.cmp 插件配置不完整**
   - 插件名拼写错误: `'saghenn/blink.cmp'` → 应为 `'saghen/blink.cmp'`
   - 缺少必要的依赖和配置选项

### 类比说明

这就像:
- ✓ 安装了汽车引擎 (Mason 安装了 LSP 服务器)
- ✓ 准备好了方向盘和仪表盘 (配置了快捷键)
- ✗ **但从未启动引擎** (没有调用 setup 或 enable 函数)

---

## 解决方法

### 方案一: 使用 Neovim 0.11+ 原生 API (推荐)

这是最现代化的方案,完全不依赖 nvim-lspconfig 插件。

#### 1. 修复 blink.cmp 配置

**文件**: `lua/plugins/completion.lua`

```lua
return {
  'saghen/blink.cmp',  -- 修正拼写错误
  dependencies = {
    'rafamadriz/friendly-snippets',
    'williamboman/mason.nvim',
  },
  event = { 'BufReadPost', 'BufNewFile' },
  version = '1.*',
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = {
      documentation = { auto_show = false }
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
  opts_extend = { "sources.default" },

  config = function(_, opts)
    -- 1. 设置 blink.cmp
    require('blink.cmp').setup(opts)

    -- 2. 配置诊断显示
    vim.diagnostic.config({
      underline = false,
      signs = false,
      update_in_insert = false,
      virtual_text = { spacing = 2, prefix = "●" },
      severity_sort = true,
      float = { border = "rounded" },
    })

    -- 3. LSP 附加时设置快捷键
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
          buffer = ev.buf,
          desc = "[LSP] Show diagnostic",
        })
        vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, 
          { desc = "[LSP] Signature help" })
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, 
          { desc = "[LSP] Add workspace folder" })
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, 
          { desc = "[LSP] Remove workspace folder" })
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { desc = "[LSP] List workspace folders" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, 
          { buffer = ev.buf, desc = "[LSP] Rename" })
      end,
    })

    -- 4. 获取 LSP capabilities (关键!)
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- 5. 配置 LSP 服务器 (使用 Neovim 0.11+ 原生 API)
    vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', 
                       '.stylua.toml', 'stylua.toml', '.git' },
      capabilities = capabilities,
    })

    vim.lsp.config('clangd', {
      cmd = { 'clangd' },
      root_markers = { '.clangd', '.clang-tidy', '.clang-format', 
                       'compile_commands.json', '.git' },
      capabilities = capabilities,
    })

    -- 6. 自动启动 LSP 服务器 (关键!)
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
```

#### 2. 简化 Mason 配置

**文件**: `lua/plugins/lsp.lua`

```lua
-- Mason: LSP/DAP/Linter/Formatter 包管理器
return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "clangd",
    },
  },
  opts_extend = { "ensure_installed" },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")

    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end
    
    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end
  end,
}
```

#### 3. 清理未使用的插件

重启 Neovim 后,运行:
```vim
:Lazy clean
```

这会自动移除不再需要的 `nvim-lspconfig` 插件。

---

### 方案二: 使用 nvim-lspconfig (传统方案)

如果你使用的是 Neovim 0.10 或更早版本,可以使用这个方案。

**文件**: `lua/plugins/lsp.lua`

```lua
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "clangd",
      },
    },
    opts_extend = { "ensure_installed" },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "williamboman/mason.nvim" },
    config = function()
      -- 配置诊断
      vim.diagnostic.config({
        underline = false,
        signs = false,
        update_in_insert = false,
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- LSP 快捷键
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
            buffer = ev.buf,
            desc = "[LSP] Show diagnostic",
          })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
            { buffer = ev.buf, desc = "[LSP] Rename" })
          -- ... 其他快捷键
        end,
      })

      -- 获取 capabilities (关键!)
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require('lspconfig')

      -- 启动 LSP 服务器 (关键!)
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })
    end,
  },
}
```

---

## 验证和测试

### 1. 重启 Neovim

```bash
# 退出 Neovim
:qa

# 重新打开 Neovim
nvim
```

### 2. 检查 LSP 状态

打开一个 Lua 文件,然后运行:

```vim
:LspInfo
```

应该看到:
```
Language client log: ~/.local/state/nvim/lsp.log
Detected filetype:   lua

1 client(s) attached to this buffer:
  Client: lua_ls (id: 1, bufnr: [1])
    filetypes:       lua
    autostart:       true
    root directory:  /path/to/your/project
    cmd:             lua-language-server
```

### 3. 测试补全功能

在 Lua 文件中输入:
```lua
vim.
```

应该会自动弹出补全菜单,显示 `vim` 模块的所有可用函数和属性。

### 4. 测试诊断功能

故意写一个错误的代码:
```lua
local x = unknownFunction()
```

应该会看到虚拟文本提示 `● undefined global 'unknownFunction'`

### 5. 运行健康检查

```vim
:checkhealth lsp
```

应该显示:
```
vim.lsp: Active Clients ~
- lua_ls (id=1, root_dir=/path/to/project)
```

---

## 关键要点总结

### ✅ 必须做的事情

1. **安装 LSP 服务器** (通过 Mason)
2. **配置 LSP 服务器** (使用 `vim.lsp.config` 或 `lspconfig.xxx.setup`)
3. **启动 LSP 服务器** (使用 `vim.lsp.enable` 或在 setup 中自动启动)
4. **传递 capabilities** (让 LSP 知道客户端支持的功能)

### ❌ 常见错误

1. ❌ 只安装了 Mason 和 nvim-lspconfig,但没有调用 setup 函数
2. ❌ 配置了快捷键,但 LSP 从未启动,快捷键永远不会生效
3. ❌ 忘记传递 capabilities,导致补全功能不完整
4. ❌ 在 Neovim 0.11+ 中使用旧的 `require('lspconfig')` API

### 🎯 推荐配置

| Neovim 版本 | 推荐方案 | 插件依赖 |
|------------|---------|---------|
| 0.11+ | 原生 `vim.lsp.config` API | blink.cmp + mason.nvim |
| 0.10 及以下 | nvim-lspconfig | blink.cmp + mason.nvim + nvim-lspconfig |

### 📚 相关文档

- [Neovim LSP 官方文档](https://neovim.io/doc/user/lsp.html)
- [vim.lsp.config 文档](https://neovim.io/doc/user/lsp.html#vim.lsp.config())
- [blink.cmp 官方文档](https://cmp.saghen.dev/)
- [Mason 官方文档](https://github.com/williamboman/mason.nvim)

---

## 添加更多 LSP 服务器

### 示例: 添加 Python LSP (pyright)

#### 1. 在 Mason 中添加

```lua
-- lua/plugins/lsp.lua
opts = {
  ensure_installed = {
    "lua-language-server",
    "clangd",
    "pyright",  -- 添加 Python LSP
  },
},
```

#### 2. 配置并启动 (方案一: 原生 API)

```lua
-- lua/plugins/completion.lua 的 config 函数中添加

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
  capabilities = capabilities,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function()
    vim.lsp.enable('pyright')
  end,
})
```

#### 3. 配置并启动 (方案二: nvim-lspconfig)

```lua
-- lua/plugins/lsp.lua 的 config 函数中添加

lspconfig.pyright.setup({ capabilities = capabilities })
```

---

**文档创建时间**: 2025-11-14
**适用 Neovim 版本**: 0.10+, 推荐 0.11+
**测试环境**: Windows 11, Neovim 0.11+

