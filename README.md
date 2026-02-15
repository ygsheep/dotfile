<p align="center"><img src="https://i.imgur.com/X5zKxvp.png" width="300px"></p>

<p align="center">
  <a href="https://nixos.org/">
    <img src="https://img.shields.io/static/v1?label=NixOS&message=25.05&style=flat&logo=nixos&colorA=24273A&colorB=8AADF4&logoColor=CAD3F5"/>
  </a>
   <a href="https://github.com/ygsheep/dotfile">
    <img src="https://img.shields.io/github/stars/ygsheep/dotfile?style=flat&logo=github&colorA=24273A&colorB=f85149&logoColor=CAD3F5" alt="stars-badge">
   </a>
  <a href="https://nixos.wiki/wiki/Flakes">
    <img src="https://img.shields.io/static/v1?label=Nix Flake&message=check&style=flat&logo=nixos&colorA=24273A&colorB=9173ff&logoColor=CAD3F5">
  </a>
   <a href="https://github.com/ygsheep/dotfile/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/ygsheep/dotfile?style=flat&logo=github&colorA=24273A&colorB=4fc8f&logoColor=CAD3F5" alt="license-badge">
  </a>
</p>

<p align="center"><img src="/assets/1.png" width="600px"></p>

<h1 align="center">🐑 Niri-Dot - 中文优化的模块化 NixOS 配置</h1>
<h3 align="center">NixOS + Niri + Noctalia - v2.0.0 模块化桌面环境</h3>

---

<pre align="center">
<a href="#安装">📦 快速安装</a> • <a href="#特性">🌟 核心特性</a> • <a href="#使用">⚙️ 基本使用</a> • <a href="#架构">🏗️ 项目架构</a>
</pre>

---

## 📦 快速安装

### 1. 准备 NixOS 系统
确保已安装 NixOS 25.05 或更新版本，并启用了 Flakes 支持。

### 2. 克隆配置
```bash
git clone https://github.com/ygsheep/dotfile ~/.dotfile
cd ~/.dotfile
```

### 3. 生成硬件配置
```bash
# 主机名可以是: desktop, laptop, thinkbook 等
sudo nixos-generate-config --dir ~/.dotfile/hosts/thinkbook --force
rm ~/.dotfile/hosts/thinkbook/configuration.nix
```

### 4. 安装系统

#### 国内用户代理配置（可选）
如果在国内网络环境下，建议使用代理加速下载：
```bash
# 方法1：临时使用代理
sudo http_proxy="http://your-proxy:port" https_proxy="http://your-proxy:port" nixos-rebuild switch --flake .#thinkbook

# 方法2：配置 substituters（推荐）
# 编辑 /etc/nixos/configuration.nix 或在配置中添加：
nix.settings.substituters = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org";
```

#### 正常安装
```bash
# 使用 Makefile（推荐）
make switch-thinkbook

# 或直接使用 nixos-rebuild
sudo nixos-rebuild switch --flake .#thinkbook
```

### 5. 安装用户配置
```bash
home-manager switch --flake .#sheep@thinkbook
```

### 6. 重启系统
```bash
reboot
```

**默认用户名和密码：`sheep` / `nixos`**

---

## 🌟 核心特性

### 🎨 桌面环境
- **窗口管理器** • [Niri](https://github.com/YaLTeR/niri/) - 可滚动的平铺窗口管理器
- **桌面 Shell** • [Noctalia](https://github.com/noctalia-dev/noctalia-shell) - 现代化桌面环境
- **显示管理** • [Greetd](https://git.sr.ht/~kennylevinsen/greetd) - 极简显示管理器 (3层启动链)
- **终端** • [WezTerm](https://wezfurlong.org/wezterm/) - 强大的现代化终端
- **文件管理** • [Yazi](https://github.com/sxyazi/yazi) - Rust 时代的文件管理器
- **编辑器** • 多编辑器支持：Neovim、Helix、VSCode、Zed
- **启动器** • [AnyRun](https://github.com/Kirottu/anyrun) - 快速应用启动器

### 🌏 中文本土化
- **输入法** • Fcitx5 + Rime（雾凇拼音），Ctrl+Space 切换
- **字体** • 完整的思源、Noto CJK 字体支持
- **本地化** • 完整的中文本地化环境
- **键盘布局** • 中英文双布局，Alt+Shift 切换

### 🛠️ 开发环境
- **包管理** • NH 工具集成，便捷的 NixOS 配置管理
- **开发工具** • 完整的 Rust、Python、Web 开发环境
- **版本控制** • Git 预配置和别名

---

## ⚙️ 基本使用

### 🚀 系统管理
```bash
# 推荐方式：使用 Makefile（默认主机：thinkbook）
make help               # 查看所有命令
make switch             # 应用配置（使用默认主机）
make switch-thinkbook   # 应用 thinkbook 配置
make switch-desktop     # 应用 desktop 配置
make check              # 运行检查
make format             # 格式化代码
make update             # 更新依赖

# 指定主机名
make build HOST=desktop
make switch HOST=laptop

# 或使用 nh 工具
nh os switch            # 应用系统配置
nh os clean             # 清理旧版本
```

### ⌨️ 快捷键
- **Super + Enter** - 打开终端
- **Super + R** - 打开应用启动器
- **Super + C** - 打开 Noctalia 控制中心
- **Super + Q** - 关闭窗口
- **Super + F** - 最大化窗口
- **Ctrl + Space** - 切换输入法
- **Alt + Shift** - 切换键盘布局
- **Print** - 截取屏幕

### 📝 自定义配置
编辑配置文件来个性化系统：

```nix
# 添加用户包 - 编辑 home/editors/nvim/default.nix
home.packages = with pkgs; [
  your-custom-package
];

# 修改系统配置 - 编辑 system/ 目录下的模块
# 添加新主机 - 复制 hosts/thinkbook/ 到 hosts/your-hostname/
# 然后在 Makefile 中添加对应的快捷命令
```

**支持的主机配置:**
- `desktop` - 桌面机完整配置
- `thinkbook` - ThinkBook 笔记本（默认）
- `laptop` - 通用笔记本配置

---

## 🏗️ 项目架构

```
Niri-Dot/
├── flake.nix                # 入口点，全局变量
├── Makefile                 # 项目管理命令（支持多主机）
├── home/                    # 用户级配置
│   ├── apps/               # GUI 应用（原 software/）
│   ├── cli/                # 命令行工具（原 terminal/）
│   ├── desktop/            # 桌面环境
│   ├── editors/            # 编辑器配置
│   └── programs/           # 程序配置
├── system/                  # 系统级配置
│   ├── core/               # 核心系统
│   ├── chinese/            # 中文本土化
│   ├── nix/                # Nix 相关
│   └── services/           # 系统服务
├── hosts/                   # 主机配置
│   ├── desktop/            # 桌面机配置
│   ├── thinkbook/          # ThinkBook 笔记本
│   └── laptop/             # 通用笔记本配置
├── scripts/                 # 工具脚本
│   ├── setup/              # 安装脚本
│   ├── maintenance/        # 维护脚本
│   └── testing/            # 测试脚本
└── assets/                  # 资源文件（壁纸、字体）
```

---

## 🔧 故障排除

### 常见问题

#### Home Manager 启动失败
如果遇到 `home-manager-sheep.service` 失败：
```bash
# 检查错误日志
journalctl -u home-manager-sheep -n 50

# 常见原因：Profile Sync Daemon (PSD) 与 Home Manager 扩展管理冲突
# 解决方案：扩展已手动安装，Home Manager 不再自动管理 Chromium 扩展
```

#### 桌面环境问题
```bash
# 检查服务状态
systemctl --user status niri-session
systemctl --user status noctalia-shell
systemctl status greetd

# 查看日志
journalctl -u greetd -f
journalctl --user -u niri-session -f

# 重启桌面环境
niri-session -r
```

#### 构建问题
```bash
# 检查配置语法
make check

# 清理并重新构建
make clean
make switch
```

---

## 📄 许可证

MIT License - 查看 [LICENSE](LICENSE) 文件了解详情

---

## 📞 联系方式

- **GitHub**: [@ygsheep](https://github.com/ygsheep)
- **项目地址**: [Niri-Dot](https://github.com/ygsheep/dotfile)

如果这个配置对你有帮助，请给项目一个 ⭐ Star！

<pre align="center">
<a href="#readme">回到顶部</a>
</pre>