# NixOS 文档中心

欢迎来到 NixOS 配置的文档中心！这里包含了完整的使用指南和配置说明。

## 📚 文档导航

### 🚀 安装指南

- [SDDM Astronaut 主题安装](./installation/sddm-astronaut.md) - 安装和配置 SDDM 登录管理器主题

### ⚙️ 配置说明

- [Noctalia 桌面 Shell](./configuration/noctalia.md) - Noctalia 桌面环境配置详解
- [视频壁纸配置](./configuration/video-wallpaper.md) - SDDM 视频壁纸设置指南

### 🔧 故障排除

- [常见问题解答](./troubleshooting/faq.md) - 常见问题和解决方案
- [调试指南](./troubleshooting/debugging.md) - 系统调试和问题诊断

## 🏗️ 项目结构

```
NixOS/
├── docs/                    # 📖 文档目录
│   ├── installation/        # 安装指南
│   ├── configuration/       # 配置说明
│   └── troubleshooting/     # 故障排除
├── home/                    # 🏠 Home Manager 配置
│   ├── cli/                # 命令行工具配置
│   ├── apps/               # GUI 应用程序配置
│   ├── desktop/            # 桌面环境配置
│   └── programs/           # 程序配置
├── scripts/                # 🛠️ 脚本工具
│   ├── setup/              # 安装配置脚本
│   ├── maintenance/        # 维护脚本
│   └── testing/            # 测试脚本
├── system/                 # ⚙️ 系统级配置
└── assets/                 # 🎨 资源文件
```

## 🎯 快速开始

1. **克隆仓库**：
   ```bash
   git clone <repository-url>
   cd NixOS
   ```

2. **验证配置**：
   ```bash
   ./scripts/testing/ci-check.sh
   ```

3. **应用配置**：
   ```bash
   sudo nixos-rebuild switch --flake .
   ```

## 📖 文档贡献

欢迎贡献文档！请遵循以下指南：

- 使用 Markdown 格式
- 添加清晰的标题和目录
- 包含实际示例和命令
- 保持语言简洁明了

## 🔗 相关链接

- [主 README](../README.md) - 项目主要介绍
- [GitHub 仓库](https://github.com/ygsheep/dotfile) - 源代码仓库
- [NixOS 官方文档](https://nixos.org/manual/nixos/stable/) - NixOS 官方文档
- [Home Manager 文档](https://nix-community.github.io/home-manager/) - Home Manager 手册

---

*最后更新: 2025-01-08*