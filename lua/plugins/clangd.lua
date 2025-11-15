return {
  -- 覆盖 LazyVim 的 clangd 配置
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 确保 servers 表存在
      opts.servers = opts.servers or {}

      -- 配置 clangd，使用 compile flags 方式指定头文件路径
      opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd or {}, {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          -- 方法1: 使用 query-driver（可能在某些 Windows 版本上不工作）
          "--query-driver=C:/msys64/mingw64/bin/gcc.exe,C:/msys64/mingw64/bin/g++.exe",
          -- 方法2: 直接指定编译标志（备用方案）
          "--compile-commands-dir=.",
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        -- 设置初始化选项，添加编译标志
        init_options = {
          compilationDatabasePath = ".",
          fallbackFlags = {
            "-IC:/msys64/mingw64/include",
            "-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include",
            "-IC:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/15.2.0/include-fixed",
          },
        },
      })

      return opts
    end,
  },
}

