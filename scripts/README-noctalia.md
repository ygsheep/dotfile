# Noctalia 官方集成指南

Noctalia 是一个基于 Qt6 的现代化桌面环境 shell，现已使用官方 Home Manager 模块完全集成到 Niri-Dot 项目中。

## 🌙 Noctalia 特性

- **完整桌面环境**: 不仅仅是启动器，而是完整的桌面 shell
- **现代化界面**: 基于 Qt6 的流畅用户界面
- **顶部栏**: 系统监控、工作区、音量、亮度、时钟等
- **控制中心**: 集中管理所有系统设置
- **应用启动器**: 智能搜索和分类
- **壁纸管理**: 自动壁纸切换和过渡效果
- **通知系统**: 现代化的通知管理
- **系统集成**: 音量、亮度、媒体控制

## 📦 安装状态

✅ **已集成**: Noctalia 官方模块已完全集成到 Niri-Dot 配置中
- 官方 Home Manager 模块导入
- systemd 服务自动启动
- 完整的中文本地化配置
- 多媒体键绑定

## 🎯 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Super + Shift + R` | 打开/关闭 Noctalia 应用启动器 |
| `Super + C` | 打开/关闭 Noctalia 控制中心 |
| `Super + Ctrl + L` | 锁定屏幕 |
| `Super + R` | 启动 AnyRun（传统启动器） |
| `Alt + Space` | QuickShell Spotlight |
| `XF86AudioRaiseVolume` | 增加音量 |
| `XF86AudioLowerVolume` | 减少音量 |
| `XF86AudioMute` | 静音/取消静音 |
| `XF86MonBrightnessUp` | 增加亮度 |
| `XF86MonBrightnessDown` | 减少亮度 |

## ⚙️ 配置文件

Noctalia 的配置由官方 Home Manager 模块管理：

- **主配置**: [`home/software/octalia/default.nix`](home/software/octalia/default.nix)
- **运行时配置**: `~/.config/noctalia/settings.json`
- **GUI 设置**: `~/.config/noctalia/gui-settings.json`

## 🎨 配置详解

### 顶部栏配置

```nix
bar = {
  position = "top";           # 位置
  backgroundOpacity = 0.95;   # 透明度
  density = "compact";        # 密度
  showCapsule = true;         # 显示胶囊
  exclusive = true;           # 独占模式

  widgets = {
    left = [
      { id = "SystemMonitor"; }     # 系统监控
      { id = "ActiveWindow"; }       # 活动窗口
      { id = "MediaMini"; }          # 媒体控制
    ];
    center = [
      { id = "Workspace"; }           # 工作区
    ];
    right = [
      { id = "Battery"; }            # 电池
      { id = "Volume"; }             # 音量
      { id = "Brightness"; }         # 亮度
      { id = "Clock"; }              # 时钟
      { id = "ControlCenter"; }      # 控制中心
    ];
  };
};
```

### 应用启动器配置

```nix
appLauncher = {
  enableClipboardHistory = true;  # 剪贴板历史
  position = "center";            # 位置
  backgroundOpacity = 0.95;      # 背景透明度
  sortByMostUsed = true;          # 按使用频率排序
  terminalCommand = "ghostty";    # 默认终端
};
```

### 壁纸管理

```nix
wallpaper = {
  enabled = true;
  directory = "/home/sheep/.dotfile/assets";
  defaultWallpaper = "/home/sheep/.dotfile/assets/1.png";
  fillMode = "crop";             # 填充模式
  randomEnabled = false;         # 随机切换
  transitionDuration = 1000;     # 过渡时间
  transitionType = "fade";       # 过渡类型
};
```

### 主题和颜色

```nix
colorSchemes = {
  useWallpaperColors = false;     # 从壁纸提取颜色
  predefinedScheme = "Noctalia (default)";
  darkMode = true;                # 深色模式
  generateTemplatesForPredefined = true;  # 生成主题模板
};
```

## 🔧 高级配置

### 添加自定义快捷键

在 [`home/software/wayland/niri/binds.nix`](home/software/wayland/niri/binds.nix) 中添加：

```nix
# 应用启动器
"Mod+Shift+R".action = spawn [
  "noctalia-shell" "ipc" "call" "appLauncher" "toggle"
];

# 控制中心
"Mod+C".action = spawn [
  "noctalia-shell" "ipc" "call" "controlCenter" "toggle"
];

# 锁屏
"Mod+Ctrl+L".action = spawn [
  "noctalia-shell" "ipc" "call" "lockScreen" "toggle"
];
```

### IPC 命令参考

所有可用命令：
```bash
# 应用启动器
noctalia-shell ipc call appLauncher toggle

# 控制中心
noctalia-shell ipc call controlCenter toggle

# 锁屏
noctalia-shell ipc call lockScreen toggle

# 会话菜单
noctalia-shell ipc call sessionMenu toggle

# 音量控制
noctalia-shell ipc call volume increase
noctalia-shell ipc call volume decrease
noctalia-shell ipc call volume muteOutput

# 亮度控制
noctalia-shell ipc call brightness increase
noctalia-shell ipc call brightness decrease

# 壁纸选择器
noctalia-shell ipc call wallpaperSelector toggle

# 屏幕录制
noctalia-shell ipc call screenRecorder toggle
```

## 🎯 使用技巧

### 1. 桌面环境集成

Noctalia 与 Niri 完美集成：
- 自动适应 Niri 的工作区
- 支持 Wayland 原生缩放
- 与其他 Wayland 应用兼容

### 2. 多显示器支持

- 每个显示器可以有不同的壁纸
- 顶部栏可以在所有显示器或仅主显示器显示
- 支持显示器特定的配置

### 3. 模板生成

自动生成各种应用的主题：
- GTK 主题
- Qt 主题
- KDE 颜色方案
- 终端主题（Alacritty、Ghostty）

### 4. 实时配置

可以通过 GUI 实时调整设置：
```bash
# 打开控制中心
noctalia-shell ipc call controlCenter toggle

# 查看配置差异
nix shell nixpkgs#jq nixpkgs#colordiff -c bash -c "
diff -u <(jq -S . ~/.config/noctalia/settings.json) \
         <(jq -S . ~/.config/noctalia/gui-settings.json) | colordiff
"
```

## 🔧 故障排除

### 服务启动问题

```bash
# 检查服务状态
systemctl --user status noctalia-shell

# 查看日志
journalctl --user -u noctalia-shell -f

# 重启服务
systemctl --user restart noctalia-shell
```

### 配置问题

```bash
# 检查配置文件
ls -la ~/.config/noctalia/

# 查看运行时配置
cat ~/.config/noctalia/settings.json

# 查看临时 GUI 配置
cat ~/.config/noctalia/gui-settings.json

# 清理配置备份
rm ~/.config/noctalia/*.backup
```

### 快捷键不工作

```bash
# 检查 Niri 配置
niri --check ~/.config/niri/config.kdl

# 重新加载配置
niri-session -r

# 测试 IPC 命令
noctalia-shell ipc call appLauncher toggle
```

### 性能问题

```bash
# 检查资源使用
htop | grep noctalia

# 降低动画速度
# 在配置中设置 animationSpeed = 0.5

# 禁用阴影
# 在配置中设置 enableShadows = false
```

## 🎨 自定义主题

### 颜色配置

```nix
colors = {
  mError = "#ff5555";           # 错误色
  mPrimary = "#8aadf4";         # 主色调
  mSecondary = "#a6da95";       # 次要色
  mSurface = "#24273a";         # 表面色
  mOnSurface = "#cad3f5";       # 表面文字色
  # ... 其他颜色
};
```

### 字体配置

```nix
ui = {
  fontDefault = "Noto Sans CJK SC";     # 默认字体
  fontFixed = "Geist Mono Nerd Font";   # 等宽字体
  fontDefaultScale = 1.0;               # 字体缩放
};
```

## 📚 相关资源

- **Noctalia 项目**: https://github.com/noctalia-dev/noctalia-shell
- **官方文档**: 详见项目 README
- **Niri 文档**: https://github.com/YaLTeR/niri/
- **Qt6 文档**: https://doc.qt.io/qt-6/

## 🔄 更新配置

修改配置后：

```bash
# 应用 Home Manager 配置
home-manager switch --flake ~/.dotfile#sheep@desktop

# 或使用 nh
nh home switch

# 重启 Noctalia 服务
systemctl --user restart noctalia-shell
```

## 🤝 贡献

如需修改 Noctalia 配置：

1. 编辑 [`home/software/octalia/default.nix`](home/software/octalia/default.nix)
2. 测试配置
3. 提交更改

---

享受完整的现代化桌面环境体验！🌙✨