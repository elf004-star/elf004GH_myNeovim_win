# 💤 LazyVim Windows Configuration

English Version | [中文版本](./README.md)

This is a [LazyVim](https://github.com/LazyVim/LazyVim) configuration optimized for Windows systems.
This configuration has been specially adapted to handle common Windows issues including proxy settings, compiler configuration, and path problems.

## 📋 Table of Contents

- [System Requirements](#system-requirements)
- [Quick Start](#quick-start)
- [Plugin Configuration Details](#plugin-configuration-details)
- [Machine-Specific Configuration](#machine-specific-configuration)
- [Troubleshooting](#troubleshooting)

## 🖥️ System Requirements

### Required Software
- **Neovim** >= 0.9.0
- **Git** for Windows
- **Node.js** >= 18.0 (for LSP servers)
- **Python** >= 3.8 (for Python development)
- **MSYS2/MinGW64** (for C/C++ development)
- **Zig** (for compiling Treesitter parsers)

### Optional Software
- **Nerd Font** (recommended: JetBrainsMono Nerd Font or FiraCode Nerd Font)
- **ripgrep** (for faster file searching)
- **fd** (for faster file finding)

## 🚀 Quick Start

1. **Backup existing configuration** (if any):
   ```powershell
   Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
   ```

2. **Clone this configuration**:
   ```powershell
   git clone <your-repo-url> $env:LOCALAPPDATA\nvim
   ```

3. **Start Neovim**:
   ```powershell
   nvim
   ```
   On first launch, LazyVim will automatically install all plugins.

4. **Install Treesitter parsers**:
   ```vim
   :TSInstall jsonc json lua bash python c cpp
   ```

5. **Check health**:
   ```vim
   :checkhealth
   ```

## 🔌 Plugin Configuration Details

### 1. Treesitter (`lua/plugins/treesitter.lua`)

**Features**: Provides syntax highlighting, code folding, incremental selection, etc.

**Configuration Details**:
- Uses **Zig compiler** to compile parsers (bypasses EBUSY errors on Windows)
- Configured **HTTP proxy** for downloading parser source code
- Forces Git mode for downloading source, avoiding problematic tree-sitter-cli

**⚠️ Machine-Specific Configuration**:
```lua
-- Proxy settings (line 23)
install.command_extra_args = {
  curl = {
    "--proxy", "http://127.0.0.1:8118",  -- Change to your proxy address and port
    "--connect-timeout", "60",
    "--max-time", "300",
  }
}
```

**If you don't need a proxy**: Comment out or delete the `install.command_extra_args` section.

---

### 2. Clangd (`lua/plugins/clangd.lua`)

**Features**: Provides LSP support for C/C++ (code completion, navigation, diagnostics, etc.).

**Configuration Details**:
- Configured MinGW64 header file paths
- Uses `compile_flags.txt` file to specify compilation flags
- Enables clang-tidy and smart header insertion

**⚠️ Machine-Specific Configuration**:
```lua
-- Line 20: MinGW64 path
"--query-driver=C:/msys64/mingw64/bin/gcc.exe,C:/msys64/mingw64/bin/g++.exe",

-- Lines 31-34: Header file paths
fallbackFlags = {
  "-IC:/msys64/mingw64/include",
  "-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include",
  "-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include-fixed",
},
```

**How to modify**:
1. Find your MSYS2 installation path (usually `C:/msys64`)
2. Find your GCC version:
   ```powershell
   C:\msys64\mingw64\bin\gcc.exe --version
   ```
3. Update the version number in paths (e.g., change `15.2.0` to your version)

**Also update `compile_flags.txt`**:
```
-IC:/msys64/mingw64/include
-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include
-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include-fixed
-std=c11
```

---

### 3. Python LSP (`lua/plugins/python.lua`)

**Features**: Provides LSP support for Python (using Pyright).

**Configuration Details**:
- Enables automatic path searching
- Basic type checking mode
- Diagnostics only for open files

**⚠️ May Need Configuration**:
If you use virtual environments or a specific Python interpreter, you can add:
```lua
settings = {
  python = {
    pythonPath = "C:/path/to/your/python.exe",  -- Specify Python path
    venvPath = "C:/path/to/your/venvs",         -- Virtual environment path
  },
},
```

---

### 4. Blink.cmp (`lua/plugins/blink-cmp.lua`)

**Features**: Modern auto-completion engine.

**Configuration Details**:
- Auto-show completion menu
- Auto bracket pairing
- Integrates LSP, path, snippets, and buffer completion

**No modification needed**: This configuration works for all systems.

---

### 5. Noice.nvim (`lua/plugins/noice.lua`)

**Features**: Beautifies Neovim's UI, including command line, messages, and notifications.

**Configuration Details**:
- Uses popup-style command line
- LSP documentation and signature help with borders
- Custom message routing rules

**Keybindings**:
- `<leader>snl` - Show last message
- `<leader>snh` - Show message history
- `<leader>sna` - Show all messages
- `<leader>snd` - Dismiss all notifications
- `<C-f>` / `<C-b>` - Scroll in floating windows

**No modification needed**: This configuration works for all systems.

---

### 6. Proxy Configuration (`init.lua`)

**Features**: Sets up proxy for Neovim's network requests.

**⚠️ Machine-Specific Configuration**:
```lua
-- Lines 3-6: HTTP proxy
vim.env.HTTP_PROXY = "http://127.0.0.1:8118"
vim.env.HTTPS_PROXY = "http://127.0.0.1:8118"
vim.env.http_proxy = "http://127.0.0.1:8118"
vim.env.https_proxy = "http://127.0.0.1:8118"

-- If using SOCKS5 proxy, uncomment:
-- vim.env.ALL_PROXY = "socks5://127.0.0.1:1080"
-- vim.env.all_proxy = "socks5://127.0.0.1:1080"
```

**If you don't need a proxy**: Comment out or delete these lines.

---

## ⚙️ Machine-Specific Configuration

### 🔴 Must Modify

| File | Location | Description | How to Determine |
|------|----------|-------------|------------------|
| `lua/plugins/clangd.lua` | Line 20 | MinGW64 GCC/G++ path | Run `where gcc` or `where g++` |
| `lua/plugins/clangd.lua` | Lines 31-34 | GCC header paths and version | Run `gcc --version` to check version |
| `compile_flags.txt` | Lines 2-3 | GCC header paths and version | Same as above |

### 🟡 May Need Modification

| File | Location | Description | When to Modify |
|------|----------|-------------|----------------|
| `init.lua` | Lines 3-6 | HTTP/HTTPS proxy address | If you use a proxy to access the network |
| `lua/plugins/treesitter.lua` | Line 23 | Treesitter download proxy | If you use a proxy to access GitHub |
| `lua/plugins/python.lua` | Entire file | Python interpreter path | If using virtual environments or non-default Python |

### 🟢 No Modification Needed

- `lua/plugins/blink-cmp.lua` - Completion configuration
- `lua/plugins/noice.lua` - UI beautification
- `lua/config/` - LazyVim base configuration

---

## 🛠️ Troubleshooting

### 1. Treesitter Installation Fails (EBUSY Error)

**Symptoms**: "EBUSY: resource busy or locked" error when running `:TSInstall`.

**Solution**:
1. Ensure Zig is installed:
   ```powershell
   zig version
   ```
2. Run the fix script:
   ```powershell
   .\保留\fix_ebusy.ps1
   ```
3. Restart Neovim and retry.

---

### 2. Clangd Cannot Find Header Files

**Symptoms**: Standard library headers like `#include <stdio.h>` show errors in C/C++ code.

**Solution**:
1. Check MSYS2 installation path:
   ```powershell
   Test-Path C:\msys64\mingw64\include
   ```
2. Update paths in `lua/plugins/clangd.lua` and `compile_flags.txt`.
3. Restart Neovim.

---

### 3. Proxy Settings Not Working

**Symptoms**: Plugin downloads fail or Treesitter parser downloads timeout.

**Solution**:
1. Confirm proxy service is running:
   ```powershell
   Test-NetConnection -ComputerName 127.0.0.1 -Port 8118
   ```
2. Check that proxy address and port in `init.lua` are correct.
3. If using SOCKS5 proxy, uncomment the corresponding lines.

---

### 4. Mason LSP Server Installation Fails

**Symptoms**: Tool installation fails in `:Mason`.

**Solution**:
1. Check network connection and proxy settings.
2. Install manually:
   ```vim
   :MasonInstall pyright clangd lua-language-server
   ```
3. View logs:
   ```vim
   :MasonLog
   ```

---

## 📚 References

- [LazyVim Official Documentation](https://lazyvim.github.io/)
- [Neovim Official Documentation](https://neovim.io/doc/)
- [Treesitter Documentation](https://github.com/nvim-treesitter/nvim-treesitter)
- [Mason.nvim Documentation](https://github.com/williamboman/mason.nvim)

---

## 📝 License

This configuration is based on the LazyVim template and follows the same license.

---

## 🤝 Contributing

Issues and Pull Requests are welcome!

---

**Last Updated**: 2025-11-15

