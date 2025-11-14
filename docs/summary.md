## lazy.nvim 安装总结

- **启动失败原因**：Neovim 初次加载时 runtimepath 中缺少 `lazy.nvim`，由于尚未克隆仓库导致 `require("lazy")` 抛出模块缺失错误。
- **修复方法**：
  - 在 `lua/config/lazy.lua` 中加入自动 bootstrap，首次运行时执行 `git clone https://github.com/folke/lazy.nvim.git` 到 `stdpath("data")/lazy/lazy.nvim`。
  - 确认 Windows 系统已安装 `git` 并可访问 GitHub（必要时配置代理或镜像源）。
  - 重新启动 Neovim 后执行 `:Lazy sync` 验证安装，后续可通过 `:Lazy` 管理插件。

