return {
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            -- 使用 'general' 方法
            vim.g.vimtex_view_method = "general"

            -- 指定 SumatraPDF 的完整路径（根据你提供的路径）
            vim.g.vimtex_view_general_viewer = "C:\\SumatraPDF\\SumatraPDF.exe"

            -- 配置正向搜索参数
            vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"

            -- 设置本地 leader 键
            -- vim.g.maplocalleader = ","
        end,
    },
}
