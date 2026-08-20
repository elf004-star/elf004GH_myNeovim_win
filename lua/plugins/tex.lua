return {
    {
        "lervag/vimtex",
        lazy = false, -- VimTeX 官方建议不要懒加载，这里是正确的
        init = function()
            -- 1. 使用通用查看器方法
            vim.g.vimtex_view_method = "general"

            -- 2. 指定 SumatraPDF 的完整路径（不要在后面接参数）
            vim.g.vimtex_view_general_viewer = "C:\\SumatraPDF\\SumatraPDF.exe"

            -- 3. 修正参数配置：去掉多余的换行与空格，修复反向搜索命令
            vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"

            -- 4. 针对 SumatraPDF 的反向搜索设置（非常重要）
            vim.g.vimtex_view_general_options_latex_mode = "xelatex"

            -- 5. 指定默认编译引擎为 xelatex
            --    注意：引擎映射必须用 g:vimtex_compiler_latexmk_engines，
            --    g:vimtex_compiler_latexmk 里没有 engines 键，写在那里会被静默忽略，
            --    导致落回默认 -pdf（pdflatex），中文文档编译报 Undefined control sequence。
            vim.g.vimtex_compiler_latexmk_engines = {
                _ = "-xelatex",
            }

            -- 6. 输出目录 Build/（与 VS Code 的 -outdir=Build 保持一致），
            --    并补上 -shell-escape。options 会整体覆盖默认值，所以列全。
            vim.g.vimtex_compiler_latexmk = {
                out_dir = "Build",
                options = {
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-shell-escape",
                },
            }

            -- 告诉 VimTeX 怎么配置 SumatraPDF 的反向搜索命令行
            -- 注意：这里推荐使用 nvim-remote 或者直接让 VimTeX 自动配置
        end,
    },
}
