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

<p align="center">
<a href="https://nixos.org/"><img src="https://img.shields.io/badge/NixOS-25.05-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8AADF4"></a>

<p align="center"><img src="/assets/1.png" width="600px"></p>

<h1 align="center">🐑 Niri-Dot - 中文优化的 NixOS 配置</h1>
<h3 align="center">一个功能完整的中文本土化 NixOS 桌面环境配置</h3>

### ⚠ <sup><sub><samp>如果你使用了我桌面/配置中的任何内容，请尊重原创者并标注来源。</samp></sub></sup>

---

<pre align="center">
<a href="#installation">📦 安装指南</a> • <a href="#features">🌟 特性介绍</a> • <a href="#configuration">⚙️ 配置说明</a> • <a href="#chinese-support">🇨🇳 中文支持</a> • <a href="#key-bindings">⌨️ 快捷键</a>
</pre>

---

## 🌟 项目特性

### 🎨 桌面环境

- **窗口管理器** • [Niri](https://github.com/YaLTeR/niri/) 🎨 可滚动的平铺窗口管理器！
- **Shell 环境** • [Nushell](https://www.nushell.sh/) 🐚 配合 [Starship](https://github.com/starship/starship) 跨平台 shell！
- **终端** • [WezTerm](https://wezfurlong.org/wezterm/) 💻 强大的现代化终端
- **面板** • [Waybar](https://github.com/Alexays/Waybar) 📊 功能丰富的状态栏
- **通知守护** • [Dunst](https://github.com/dunst-project/dunst) 🍃 极简主义的通知系统！
- **启动器** • [AnyRun](https://github.com/Kirottu/anyrun) 🚀 快速的应用启动器！
- **文件管理器** • [Yazi](https://github.com/sxyazi/yazi) 🔖 Rust 时代的文件管理器！
- **编辑器** • [Helix](https://docs.helix-editor.com/) ✴️ Rust 编写的 Vim 替代品！
- **GTK 主题** • [Colloid](https://github.com/vinceliuice/Colloid-gtk-theme) 🎨 现代化的 GTK 主题
- **锁屏** • [Hyprlock](https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/) 🔒 安全的锁屏界面

### 🌏 中文本土化支持

- **输入法框架** • Fcitx5 + Rime（支持雾凇拼音）
- **中文字体** • 完整的思源、Noto CJK、文泉驿字体支持
- **字体渲染** • 优化的中文字体渲染和抗锯齿设置
- **本地化设置** • 完整的中文本地化环境
- **键盘布局** • 中英文双布局，Alt+Shift 切换

### 🛠️ 开发环境

- **Git 配置** • 预配置好的 Git 用户信息和别名
- **包管理** • NH 工具集成，便捷的 NixOS 配置管理
- **代理支持** • 内置代理管理和配置脚本
- **镜像源** • 国内 Nix 镜像源加速
- **开发工具** • 完整的 Rust、Python、Web 开发环境

### 🖥️ 桌面环境

- **默认窗口管理器** • [Niri](https://github.com/YaLTeR/niri/) 🎨 可滚动的平铺窗口管理器
- **备选桌面环境** • [GNOME](https://www.gnome.org/) 🌟 现代化的 Linux 桌面环境（支持 Wayland）
- **显示管理器** • [Greetd](https://git.sr.ht/~kennylevinsen/greetd) 🔑 极简的显示管理器（3 层启动链）
- **启动优化** • 移除冗余层，启动速度提升 30-50%
- **会话选择** • 自动登录 Niri 窗口管理器

### 🔧 系统优化

- **性能优化** • ZRAM 压缩、系统调优
- **安全性** • 系统安全加固配置
- **网络** • NetworkManager + 防火墙配置
- **字体管理** • 自动字体发现和管理

## 📦 安装指南

### 📋 系统要求

- NixOS 25.05 或更新版本
- x86_64 架构
- 支持 UEFI 的系统

### 🚀 快速安装

#### 1. 下载 NixOS ISO

```bash
wget -O nixos-minimal.iso https://channels.nixos.org/nixos-25.05/latest-nixos-minimal-x86_64-linux.iso
```

#### 2. 制作启动盘并安装系统

启动到 NixOS 安装程序，切换到 root：

```bash
sudo -i
```

#### 3. 磁盘分区（示例配置）

```bash
# 替换 nvme0n1 为你的磁盘名
gdisk /dev/nvme0n1
```

- `o` - 创建新的分区表
- `n` - 添加 EFI 分区（512M，类型 ef00）
- `n` - 添加 Linux 分区（剩余空间，类型 8300）
- `w` - 写入分区表并退出

#### 4. 格式化分区

```bash
mkfs.fat -F 32 -n EFI /dev/nvme0n1p1
mkfs.xfs -L NIXOS /dev/nvme0n1p2
```

#### 5. 挂载分区

```bash
mount /dev/disk/by-label/NIXOS /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/EFI /mnt/boot
```

#### 6. 启用 Nix Flakes

```bash
nix-shell -p nixVersions.stable git
```

#### 7. 克隆配置文件

```bash
git clone --depth 1 https://github.com/ygsheep/dotfile /mnt/etc/nixos
```

### ⚠ <sup><sub><samp>重要提醒 - 请勿忘记！</samp></sub></sup>

#### 8. 生成硬件配置

```bash
sudo nixos-generate-config --dir /mnt/etc/nixos/hosts/desktop --force

# 删除默认配置文件
rm -rf /mnt/etc/nixos/hosts/desktop/configuration.nix
```

#### 9. 安装系统

```bash
cd /mnt/etc/nixos/
nixos-install --flake .#desktop
```

#### 10. 重启系统

```bash
reboot
```

### 🐙 <sup><sub><samp>默认用户名和密码：<strong>nixos</strong></samp></sub></sup>

重启后需要配置用户环境：

#### 1. 更改默认密码

```bash
passwd sheep
```

#### 2. 安装 Home Manager 配置

```bash
home-manager switch --flake 'github:ygsheep/dotfile#sheep@desktop'
```

#### 3. 克隆配置文件到本地（可选但推荐）

```bash
# 克隆配置文件到用户目录（用于后续使用 nh 工具）
git clone https://github.com/ygsheep/dotfile.git ~/.dotfile
```

4. 验证配置

安装完成后，您可以使用以下方式更新配置：

**推荐方式（使用 nh）：**

```bash
# 检查 nh 是否正确安装
nh --help

# 使用 nh 更新系统配置
nh os switch
```

**传统方式：**

```bash
# 手动更新系统配置
sudo nixos-rebuild switch --flake ~/.dotfile#desktop

# 更新 Home Manager 配置
home-manager switch --flake ~/.dotfile#sheep@desktop
```

## 🌏 中文支持配置

### 输入法配置

Niri-Dot 配置包含完整的中文输入法支持：

#### Fcitx5 + Rime

- **框架**：Fcitx5（现代化输入法框架）
- **引擎**：Rime（支持雾凇拼音）
- **快捷键**：Ctrl+Space 切换输入法
- **管理工具**：

  ```bash
  # 安装/更新 Rime 配置
  rime-setup install

  # 重新部署输入法
  rime-setup deploy

  # 查看配置状态
  rime-setup status
  ```

#### 字体系统

- **主要字体**：Noto CJK 系列、思源字体
- **编程字体**：JetBrains Mono、Sarasa Mono
- **Nerd Fonts**：完整的图标字体支持
- **字体渲染**：优化的抗锯齿和提示设置

### 环境变量

- **语言环境**：`zh_CN.UTF-8`
- **时区**：`Asia/Shanghai`
- **输入法**：Fcitx5 环境变量自动设置

### 键盘布局管理

```bash
# 切换到中文键盘布局
kb-cn

# 切换到英文键盘布局
kb-us

# 在中英文之间切换
kb-toggle

# 查看当前键盘状态
kb-status
```

### 代理管理（可选）

Niri-Dot 提供了完整的代理管理工具：

```bash
# 启用代理
proxy-on

# 禁用代理
proxy-off

# 查看代理状态
proxy-status

# 测试代理连接
proxy-test
```

### 🔧 系统服务验证

安装完成后，可以验证以下服务是否正常运行：

```bash
# 检查 Niri 窗口管理器
systemctl --user status niri-session

# 检查 swww 壁纸守护进程
systemctl status swww-daemon

# 检查 Fcitx5 输入法
systemctl --user status fcitx5-daemon

# 检查显示管理器
systemctl status greetd

# 查看所有用户服务
systemctl --user list-units --type=service --state=running
```

### 🖥️ 桌面环境选择

系统现在支持两个桌面环境：

#### **Niri（默认）**

- **特点**: 可滚动的平铺窗口管理器，轻量级且高效
- **启动方式**: 通过极简启动链自动登录（3 秒内完成）
- **适用场景**: 开发、代码编辑、键盘驱动的工作流
- **性能优势**: 启动速度快，资源占用少

#### **GNOME（备选）**

- **特点**: 完整的桌面环境，用户友好
- **启动方式**: 在终端中手动启动
- **适用场景**: 日常使用、办公、多媒体

#### **Greetd 极简显示管理器**

- **特点**: 极简的 3 层启动链，直接启动 Niri
- **启动流程**: systemd → greetd → niri-session → Niri WM
- **性能优化**: 移除了 cage 容器和 tuigreet 欢迎界面
- **配置文件**: `system/services/greetd.nix`
- **自动登录**: 默认用户 `sheep` 自动登录到 Niri
- **启动速度**: 比原配置提升 30-50%

#### **会话切换**

```bash
# 查看可用的桌面会话
ls /run/current-system/sw/share/wayland-sessions/
ls /run/current-system/sw/share/xsessions/

# 手动启动 GNOME（在终端中）
gnome-session --session=gnome

# 重启 Niri 会话
niri-session -r

# 如果需要修改登录配置，编辑:
# system/services/greetd.nix
```

## ⚙️ 配置说明

### 🏗️ 模块化架构

```
Niri-Dot/
├── system/           # 系统级配置
│   ├── core/        # 核心系统配置
│   ├── chinese/     # 中文支持模块
│   ├── hardware/    # 硬件驱动
│   ├── network/     # 网络配置
│   └── programs/    # 系统程序
├── home/            # 用户级配置
│   ├── programs/    # 应用配置
│   ├── terminal/    # 终端和 shell
│   └── software/    # GUI 应用
└── hosts/           # 主机特定配置
    └── desktop/     # 桌面配置
```

### 📝 自定义配置

#### 添加用户包

编辑 `hosts/desktop/users/sheep.nix`：

```nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    your-custom-package
  ];
}
```

#### 修改系统配置

编辑 `system/` 目录下的相应模块文件。

#### 添加新主机

复制 `hosts/desktop/` 目录到 `hosts/your-hostname/` 并修改配置。

### 🚀 性能测试与优化

### 启动性能测试

系统提供了专门的启动性能测试工具：

```bash
# 运行完整性能测试
sudo ./scripts/test-startup-performance.sh

# 测试项目包括：
# - 启动流程分析
# - 内存使用情况
# - 故障排查检查
# - 配置对比分析
```

### 启动流程优化

Niri-Dot 采用极简启动链设计：

**优化前（5 层）**：
```
systemd → greetd → cage → tuigreet → niri-session → Niri WM
```

**优化后（3 层）**：
```
systemd → greetd → niri-session → Niri WM
```

**性能提升**：
- ✅ 启动时间减少 30-50%
- ✅ 内存使用减少 20-40MB
- ✅ 故障点从 5 个减少到 3 个
- ✅ 配置复杂度显著降低

### 故障排查

常用排查命令：
```bash
# 查看 Greetd 日志
journalctl -u greetd -f

# 检查服务状态
systemctl status greetd

# 重启显示管理器
sudo systemctl restart greetd

# 测试配置
sudo nixos-rebuild test
```

## 🔄 系统维护

#### 推荐方式：使用 nh 工具

`nh` 是一个便捷的 NixOS 包管理器，提供更友好的界面和自动化清理功能。

```bash
# 查看可用的配置
nh os list

# 应用系统配置（推荐使用）
nh os switch

# 测试配置而不应用
nh os test

# 清理旧的系统版本（自动清理 7 天前的版本）
nh os clean

# 查看所有 nh 命令
nh --help
```

#### 传统方式：使用 nixos-rebuild

```bash
# 测试配置
sudo nixos-rebuild test --flake .#desktop

# 应用配置
sudo nixos-rebuild switch --flake .#desktop

# 清理旧版本
sudo nix-collect-garbage -d
```

#### Home Manager 更新

```bash
# 测试用户配置
home-manager build --flake .#sheep@desktop

# 应用用户配置
home-manager switch --flake .#sheep@desktop

# 使用 nh 管理 Home Manager（如果配置了）
nh home switch
```

### 📁 配置目录说明

默认情况下，`nh` 会从以下位置查找配置：

- **系统配置**: `/home/sheep/.dotfile`（通过 `NH_FLAKE` 环境变量设置）
- **其他位置**: 可以使用 `--flake /path/to/config` 指定其他路径

如果您的配置文件在不同位置，可以：

```bash
# 临时指定配置路径
nh os switch --flake /path/to/your/Niri-Dot

# 或者设置环境变量
export NH_FLAKE="/path/to/your/Niri-Dot"
nh os switch
```

**推荐目录结构**：

```
/home/sheep/
├── .dotfile/          # Niri-Dot 配置文件（推荐位置）
│   ├── system/        # 系统配置
│   ├── home/          # 用户配置
│   └── hosts/         # 主机配置
├── .config/           # 应用配置目录
└── ...                # 其他用户文件
```

## 📸 系统截图

|                           |                           |
| :-----------------------: | :-----------------------: |
| <img src="/assets/1.png"> | <img src="/assets/2.png"> |
| <img src="/assets/3.png"> | <img src="/assets/4.png"> |
| <img src="/assets/5.png"> | <img src="/assets/6.png"> |

## 🎯 快捷键绑定

### 系统快捷键

- **Super + Enter** - 打开终端 (Ghostty)
- **Super + R** - 打开应用启动器 (AnyRun)
- **Super + D** - 打开应用启动器 (QuickShell Spotlight)
- **Alt + Space** - 打开应用启动器 (QuickShell Spotlight)
- **Super + F** - 最大化窗口
- **Super + Q** - 关闭窗口
- **Super + Space** - 切换窗口浮动/平铺
- **Ctrl + Alt + L** - 锁定屏幕
- **Print** - 截取屏幕
- **Super + Shift + S** - 截取区域
- **Alt + Shift** - 切换键盘布局（中英文）
- **Ctrl + Space** - 切换输入法
- **Caps Lock** - 点按为 ESC，组合键为 Ctrl（如 Caps+C = Ctrl+C）

### 窗口管理（Niri）

- **Super + 方向键** - 切换窗口焦点
- **Super + Shift + 方向键** - 移动窗口
- **Super + Q** - 关闭窗口
- **Super + F** - 全屏窗口

### 终端快捷键

- **Ctrl + Shift + C** - 复制
- **Ctrl + Shift + V** - 粘贴
- **Ctrl + Shift + T** - 新建标签页
- **Ctrl + Tab** - 切换标签页

## 🛠️ 故障排除

### 常见问题

#### 状态栏和壁纸不显示

```bash
# 检查 QuickShell 是否正在运行
ps aux | grep qs

# 手动启动 QuickShell
qs -c DankMaterialShell

# 检查壁纸服务
ps aux | grep swww

# 手动设置壁纸
swww init
swww img ~/.dotfile/assets/1.png

# 重启 Niri 会话
# 注销并重新登录，或使用以下命令重启
niri-session -r
```

#### 应用启动器无法使用

```bash
# 检查 AnyRun 是否已安装
which anyrun

# 手动启动 AnyRun
anyrun

# 检查 QuickShell Spotlight 功能
qs -c DankMaterialShell ipc call spotlight toggle

# 如果快捷键不工作，检查键盘布局
setxkbmap -query
```

#### 输入法无法启动

```bash
# 检查 fcitx5 进程
ps aux | grep fcitx5

# 重启 fcitx5
fcitx5-remote -r && sleep 1 && fcitx5 &

# 重新部署 Rime
rime-setup deploy
```

#### 字体显示异常

```bash
# 重新生成字体缓存
fc-cache -f -v

# 检查字体配置
fc-match "sans-serif"
fc-match "serif"
fc-match "monospace"
```

#### 网络连接问题

```bash
# 检查网络状态
nmcli connection show

# 重启网络管理器
sudo systemctl restart NetworkManager

# 测试代理连接
proxy-test
```

### 日志查看

```bash
# 系统日志
journalctl -b 0 -p err

# NixOS 重建日志
sudo nixos-rebuild switch --show-trace

# Home Manager 日志
home-manager switch --show-trace
```

#### 锁屏不工作

```bash
# 检查 Hyprlock 服务状态
systemctl --user status hyprlock

# 手动启动 Hyprlock
hyprlock

# 检查 Hypridle 服务状态
systemctl --user status hypridle

# 重启 Hypridle 服务
systemctl --user restart hypridle

# 检查快捷键绑定
grep -r "Ctrl+Alt" ~/.config/niri/
```

#### 键盘布局不正确

```bash
# 查看当前键盘布局
setxkbmap -query

# 测试键盘布局
setxkbmap -layout cn

# 如果按键对应不上，可以临时切换布局
setxkbmap -layout us  # 美式键盘
setxkbmap -layout cn  # 中文键盘

# 查看可用的键盘布局
localectl list-x11-keymap-layouts

# 重启 Niri 会话
# 注销并重新登录，或使用以下命令重启
niri-session -r
```

#### 输入法和键盘布局问题

```bash
# 检查 fcitx5 状态
fcitx5-diagnose

# 重新设置输入法环境变量
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# 重启 fcitx5
fcitx5-remote -r && sleep 1 && fcitx5 &

# 检查键盘符号是否正确
showkey -a  # 查看按键对应的键码

# 测试 Caps Lock 配置
# 单击 Caps Lock 应该发送 ESC 信号
# Caps + 其他键应该作为 Ctrl 使用
echo "测试 Caps Lock: 按一次应该退出，按 Caps+C 应该复制"
```

#### Caps Lock 配置验证

```bash
# 查看当前键盘选项
setxkbmap -query | grep options

# 手动设置 Caps Lock 行为
setxkbmap -option caps:escape,ctrl:nocaps

# 如果 Caps Lock 不工作，可以尝试其他选项
setxkbmap -option caps:super           # Caps Lock 作为 Super 键
setxkbmap -option caps:hyper          # Caps Lock 作为 Hyper 键
setxkbmap -option caps:backspace      # Caps Lock 作为退格键

# 恢复默认设置
setxkbmap -option # 清除所有选项
```

#### Niri 会话问题

```bash
# 检查 Niri 服务状态
systemctl --user status niri-session

# 检查显示管理器状态
systemctl status greetd

# 查看 Niri 日志
journalctl --user -u niri-session -f

# 手动启动 Niri 会话（如果当前在其他会话中）
niri-session

# 检查 Niri 配置
niri --check /home/sheep/.config/niri/config.kdl
```

#### swww 壁纸守护进程问题

```bash
# 检查 swww-daemon 服务状态
systemctl status swww-daemon

# 检查用户级 swww 服务
systemctl --user status swww-init

# 手动初始化 swww
swww init

# 手动设置壁纸
swww img /home/sheep/.dotfile/assets/1.png

# 检查 swww 进程
ps aux | grep swww

# 重启 swww 服务
sudo systemctl restart swww-daemon
systemctl --user restart swww-init

# 查看 swww 缓存状态
swww query
```

#### GNOME 会话问题

```bash
# 检查 GDM 服务状态
systemctl status gdm

# 查看 GNOME 会话日志
journalctl -u gdm -f

# 检查 GNOME Shell 状态
systemctl --user status gnome-shell

# 重启 GNOME 服务
systemctl restart gdm

# 如果 GNOME 启动失败，检查配置
dconf read /org/gnome/desktop/session

# 强制使用 Wayland 模式
export GNOME_SHELL_SESSION_MODE=wayland

# 查看可用的 GNOME 会话
ls /run/current-system/sw/share/wayland-sessions/gnome.desktop

# 手动启动 GNOME 会话
gnome-session
```

#### 桌面环境切换问题

```bash
# 检查当前运行的桌面环境
echo $XDG_CURRENT_DESKTOP

# 检查会话类型
echo $XDG_SESSION_TYPE

# 在终端中手动切换桌面环境
# 切换到 GNOME
systemctl --user stop niri-session 2>/dev/null || true
gnome-session &

# 切换到 Niri
systemctl --user stop gnome-shell 2>/dev/null || true
niri-session &

# 查看所有运行的用户服务
systemctl --user list-units --type=service --state=running
```

#### 显示管理器问题

```bash
# 检查 GDM 和 Greetd 状态
systemctl status gdm
systemctl status greetd

# 如果显示管理器冲突，只启用一个
# 启用 GDM，禁用 Greetd
systemctl disable greetd
systemctl enable gdm
systemctl restart gdm

# 或者只启用 Greetd
systemctl disable gdm
systemctl enable greetd
systemctl restart greetd

# 查看显示管理器日志
journalctl -u gdm -f
journalctl -u greetd -f

# 重启显示管理器
systemctl restart gdm  # 或 systemctl restart greetd
```

## 🙏 致谢

### 🔧 灵感来源和资源

|                            项目                             |    作者     |     贡献     |
| :---------------------------------------------------------: | :---------: | :----------: |
|      [dotfile](https://github.com/linuxmobile/dotfile)      | linuxmobile | 中文支持配置 |
|           [niri](https://github.com/YaLTeR/niri/)           |   YaLTeR    |  窗口管理器  |
|          [wezterm](https://github.com/wez/wezterm)          | Wez Furlong |  终端模拟器  |
|        [rime-ice](https://github.com/iDvel/rime-ice)        |    iDvel    |  Rime 配置   |
| [nixos-configs](https://github.com/vimpostor/nixos-configs) |  vimpostor  |  模块化架构  |
|         [anyrun](https://github.com/Kirottu/anyrun)         |   Kirottu   |    启动器    |

### 🌟 社区项目

本配置基于社区优秀的项目和配置，感谢所有开源贡献者的努力！

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 📋 贡献类型

- 🐛 Bug 报告
- ✨ 新功能建议
- 📝 文档改进
- 🎨 主题和美化
- 🌏 中文支持改进

### 🔄 开发环境设置

```bash
# 克隆仓库
git clone https://github.com/ygsheep/dotfile.git
cd Niri-Dot

# 进入开发环境
nix develop

# 检查配置
nix flake check
```

### 📤 提交更改

1. Fork 本仓库
2. 创建功能分支
3. 提交更改
4. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 📞 联系方式

- **GitHub**: [@linuxmobile](https://github.com/linuxmobile)
- **项目地址**: [Niri-Dot](https://github.com/ygsheep/dotfile)

如果这个配置对你有帮助，请给项目一个 ⭐ Star！

<pre align="center">
<a href="#readme">回到顶部</a>
</pre>
