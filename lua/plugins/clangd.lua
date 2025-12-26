return {
  -- 覆盖 LazyVim 的 clangd 配置
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 确保 servers 表存在
      opts.servers = opts.servers or {}

      -- 动态查找 Mason 安装的 clangd 路径
      local function find_clangd_path()
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/clangd"
        -- 使用 glob 查找所有 clangd_* 目录下的 clangd.exe
        local clangd_pattern = mason_path .. "/clangd_*/bin/clangd.exe"
        local matches = vim.fn.glob(clangd_pattern, false, true)
        
        if #matches > 0 then
          -- 如果有多个版本，选择第一个（通常 glob 会按字母顺序排序，最新版本可能在最后）
          -- 为了选择最新版本，我们可以按路径排序并选择最后一个
          table.sort(matches)
          return matches[#matches]
        end
        
        -- 如果找不到，回退到系统 PATH 中的 clangd
        return "clangd"
      end

      -- 配置 clangd
      opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd or {}, {
        cmd = {
          -- 动态查找 Mason 安装的 clangd 路径
          find_clangd_path(),
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          -- 使用系统 PATH 中的 gcc/g++（通过 query-driver 让 clangd 自动发现头文件）
          "--query-driver=gcc,g++",
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        init_options = {
          compilationDatabasePath = ".",
        },
      })

      return opts
    end,
  },
}
