# 💤 LazyVim Windows 配置

[English Version](./README_EN.md) | 中文版本

这是一个针对 Windows 系统优化的 [LazyVim](https://github.com/LazyVim/LazyVim) 配置文件。
本配置已针对 Windows 环境下的常见问题进行了特殊处理，包括代理设置、编译器配置和路径问题。

## 📋 目录

- [系统要求](#系统要求)
- [快速开始](#快速开始)
- [插件配置详解](#插件配置详解)
- [需要根据电脑配置的项目](#需要根据电脑配置的项目)
- [常见问题](#常见问题)

## 🖥️ 系统要求

### 必需软件
- **Neovim** >= 0.9.0
- **Git** for Windows
- **Node.js** >= 18.0 (用于 LSP 服务器)
- **Python** >= 3.8 (用于 Python 开发)
- **MSYS2/MinGW64** (用于 C/C++ 开发)
- **Zig** (用于编译 Treesitter 解析器)

### 可选软件
- **Nerd Font** (推荐 JetBrainsMono Nerd Font 或 FiraCode Nerd Font)
- **ripgrep** (用于更快的文件搜索)
- **fd** (用于更快的文件查找)

## 🚀 快速开始

1. **备份现有配置**（如果有）：
   ```powershell
   Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
   ```

2. **克隆此配置**：
   ```powershell
   git clone <your-repo-url> $env:LOCALAPPDATA\nvim
   ```

3. **启动 Neovim**：
   ```powershell
   nvim
   ```
   首次启动时，LazyVim 会自动安装所有插件。

4. **安装 Treesitter 解析器**：
   ```vim
   :TSInstall jsonc json lua bash python c cpp
   ```

5. **检查健康状态**：
   ```vim
   :checkhealth
   ```

## 🔌 插件配置详解

### 1. Treesitter (`lua/plugins/treesitter.lua`)

**功能**：提供语法高亮、代码折叠、增量选择等功能。

**配置说明**：
- 使用 **Zig 编译器**编译解析器（绕过 Windows 上的 EBUSY 错误）
- 配置了 **HTTP 代理**用于下载解析器源码
- 强制使用 Git 模式下载源码，避免使用有问题的 tree-sitter-cli

**⚠️ 需要根据电脑配置**：
```lua
-- 代理设置（第 23 行）
install.command_extra_args = {
  curl = {
    "--proxy", "http://127.0.0.1:8118",  -- 修改为你的代理地址和端口
    "--connect-timeout", "60",
    "--max-time", "300",
  }
}
```

**如果不需要代理**：注释掉或删除 `install.command_extra_args` 部分。

---

### 2. Clangd (`lua/plugins/clangd.lua`)

**功能**：为 C/C++ 提供 LSP 支持（代码补全、跳转、诊断等）。

**配置说明**：
- 配置了 MinGW64 的头文件路径
- 使用 `compile_flags.txt` 文件指定编译标志
- 启用了 clang-tidy 和智能头文件插入

**⚠️ 需要根据电脑配置**：
```lua
-- 第 20 行：MinGW64 路径
"--query-driver=C:/msys64/mingw64/bin/gcc.exe,C:/msys64/mingw64/bin/g++.exe",

-- 第 31-34 行：头文件路径
fallbackFlags = {
  "-IC:/msys64/mingw64/include",
  "-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include",
  "-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include-fixed",
},
```

**如何修改**：
1. 找到你的 MSYS2 安装路径（通常是 `C:/msys64`）
2. 找到 GCC 版本号：
   ```powershell
   C:\msys64\mingw64\bin\gcc.exe --version
   ```
3. 更新路径中的版本号（例如 `15.2.0` 改为你的版本）

**同时需要修改 `compile_flags.txt`**：
```
-IC:/msys64/mingw64/include
-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include
-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include-fixed
-std=c11
```

---

### 3. Python LSP (`lua/plugins/python.lua`)

**功能**：为 Python 提供 LSP 支持（使用 Pyright）。

**配置说明**：
- 启用自动搜索路径
- 基础类型检查模式
- 仅对打开的文件进行诊断

**⚠️ 可能需要配置**：
如果你使用虚拟环境或特定的 Python 解释器，可以添加：
```lua
settings = {
  python = {
    pythonPath = "C:/path/to/your/python.exe",  -- 指定 Python 路径
    venvPath = "C:/path/to/your/venvs",         -- 虚拟环境路径
  },
},
```

---

### 4. Blink.cmp (`lua/plugins/blink-cmp.lua`)

**功能**：现代化的自动补全引擎。

**配置说明**：
- 自动显示补全菜单
- 自动括号配对
- 集成 LSP、路径、代码片段和缓冲区补全

**无需修改**：此配置适用于所有系统。

---

### 5. Noice.nvim (`lua/plugins/noice.lua`)

**功能**：美化 Neovim 的 UI，包括命令行、消息和通知。

**配置说明**：
- 使用弹出窗口样式的命令行
- LSP 文档和签名帮助带边框
- 自定义消息路由规则

**快捷键**：
- `<leader>snl` - 显示最后一条消息
- `<leader>snh` - 显示消息历史
- `<leader>sna` - 显示所有消息
- `<leader>snd` - 关闭所有通知
- `<C-f>` / `<C-b>` - 在悬浮窗口中滚动

**无需修改**：此配置适用于所有系统。

---

### 6. 代理配置 (`init.lua`)

**功能**：为 Neovim 的网络请求设置代理。

**⚠️ 需要根据电脑配置**：
```lua
-- 第 3-6 行：HTTP 代理
vim.env.HTTP_PROXY = "http://127.0.0.1:8118"
vim.env.HTTPS_PROXY = "http://127.0.0.1:8118"
vim.env.http_proxy = "http://127.0.0.1:8118"
vim.env.https_proxy = "http://127.0.0.1:8118"

-- 如果使用 SOCKS5 代理，取消注释：
-- vim.env.ALL_PROXY = "socks5://127.0.0.1:1080"
-- vim.env.all_proxy = "socks5://127.0.0.1:1080"
```

**如果不需要代理**：注释掉或删除这些行。

---

## ⚙️ 需要根据电脑配置的项目

### 🔴 必须修改的配置

| 文件 | 位置 | 说明 | 如何确定 |
|------|------|------|----------|
| `lua/plugins/clangd.lua` | 第 20 行 | MinGW64 GCC/G++ 路径 | 运行 `where gcc` 或 `where g++` |
| `lua/plugins/clangd.lua` | 第 31-34 行 | GCC 头文件路径和版本号 | 运行 `gcc --version` 查看版本 |
| `compile_flags.txt` | 第 2-3 行 | GCC 头文件路径和版本号 | 同上 |

### 🟡 可能需要修改的配置

| 文件 | 位置 | 说明 | 何时需要修改 |
|------|------|------|--------------|
| `init.lua` | 第 3-6 行 | HTTP/HTTPS 代理地址 | 如果你使用代理访问网络 |
| `lua/plugins/treesitter.lua` | 第 23 行 | Treesitter 下载代理 | 如果你使用代理访问 GitHub |
| `lua/plugins/python.lua` | 整个文件 | Python 解释器路径 | 如果使用虚拟环境或非默认 Python |

### 🟢 无需修改的配置

- `lua/plugins/blink-cmp.lua` - 补全配置
- `lua/plugins/noice.lua` - UI 美化
- `lua/config/` - LazyVim 基础配置

---

## 🛠️ 常见问题

### 1. Treesitter 安装失败（EBUSY 错误）

**症状**：运行 `:TSInstall` 时出现 "EBUSY: resource busy or locked" 错误。

**解决方案**：
1. 确保已安装 Zig：
   ```powershell
   zig version
   ```
2. 运行修复脚本：
   ```powershell
   .\保留\fix_ebusy.ps1
   ```
3. 重启 Neovim 并重试。

---

### 2. Clangd 找不到头文件

**症状**：C/C++ 代码中 `#include <stdio.h>` 等标准库报错。

**解决方案**：
1. 检查 MSYS2 安装路径：
   ```powershell
   Test-Path C:\msys64\mingw64\include
   ```
2. 更新 `lua/plugins/clangd.lua` 和 `compile_flags.txt` 中的路径。
3. 重启 Neovim。

---

### 3. 代理设置不生效

**症状**：插件下载失败或 Treesitter 解析器下载超时。

**解决方案**：
1. 确认代理服务正在运行：
   ```powershell
   Test-NetConnection -ComputerName 127.0.0.1 -Port 8118
   ```
2. 检查 `init.lua` 中的代理地址和端口是否正确。
3. 如果使用 SOCKS5 代理，取消注释相应行。

---

### 4. Mason 安装 LSP 服务器失败

**症状**：`:Mason` 中安装工具失败。

**解决方案**：
1. 检查网络连接和代理设置。
2. 手动安装：
   ```vim
   :MasonInstall pyright clangd lua-language-server
   ```
3. 查看日志：
   ```vim
   :MasonLog
   ```

---

## 📚 参考资源

- [LazyVim 官方文档](https://lazyvim.github.io/)
- [Neovim 官方文档](https://neovim.io/doc/)
- [Treesitter 文档](https://github.com/nvim-treesitter/nvim-treesitter)
- [Mason.nvim 文档](https://github.com/williamboman/mason.nvim)

---

## 📝 许可证

本配置基于 LazyVim 模板，遵循相同的许可证。

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**最后更新**：2025-11-15
