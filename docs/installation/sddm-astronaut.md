# SDDM Astronaut Theme 安装指南

本指南帮助你在 NixOS 项目中安装和配置漂亮的 SDDM Astronaut 主题。

## 🎨 主题预览

SDDM Astronaut Theme 提供多种精美样式：
- **Astronaut** - 太空主题
- **Black hole** - 黑洞主题  
- **Japanese aesthetic** - 日式美学
- **Cyberpunk** - 赛博朋克
- **Pixel sakura** - 像素樱花
- **Post-apocalyptic hacker** - 末世黑客
- 等等...

支持动态壁纸和虚拟键盘！

## 📦 安装方法

### 方法 1: 使用自动安装脚本（推荐）

```bash
# 运行自动安装脚本
sudo ./scripts/setup-sddm-astronaut.sh
```

脚本会自动：
- ✅ 下载主题文件
- ✅ 安装必要的字体
- ✅ 配置 SDDM 设置
- ✅ 启用虚拟键盘支持
- ✅ 重启 SDDM 服务

### 方法 2: 手动安装

1. **下载主题**
```bash
sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
```

2. **安装字体**
```bash
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
sudo fc-cache -f -v
```

3. **配置 SDDM**
编辑 `/etc/sddm.conf`:
```ini
[Theme]
Current=sddm-astronaut-theme
```

4. **启用虚拟键盘**
创建 `/etc/sddm.conf.d/virtualkbd.conf`:
```ini
[General]
InputMethod=qtvirtualkeyboard
```

5. **重启 SDDM**
```bash
sudo systemctl restart sddm
```

## ⚙️ 配置选项

### 切换主题样式

编辑主题配置文件：
```bash
sudo nano /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
```

修改 `ConfigFile=` 行来选择不同样式：
```
ConfigFile=Themes/astronaut.conf      # 默认太空主题
ConfigFile=Themes/black_hole.conf     # 黑洞主题
ConfigFile=Themes/cyberpunk.conf      # 赛博朋克
ConfigFile=Themes/japanese_aesthetic.conf  # 日式美学
ConfigFile=Themes/pixel_sakura.conf   # 像素樱花
```

### 预览主题

无需重启即可预览主题：
```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/
```

### 自定义背景

1. 将你的壁纸图片复制到主题目录：
```bash
sudo cp /path/to/your/wallpaper.png /usr/share/sddm/themes/sddm-astronaut-theme/
```

2. 编辑主题配置：
```bash
sudo nano /usr/share/sddm/themes/sddm-astronaut-theme/Themes/your-theme.conf
```

3. 修改 `background=` 行指向你的壁纸文件名

## 🔧 故障排除

### 主题未显示
```bash
# 检查主题文件
ls -la /usr/share/sddm/themes/sddm-astronaut-theme/

# 检查 SDDM 配置
cat /etc/sddm.conf

# 重启 SDDM 服务
sudo systemctl restart sddm
```

### 虚拟键盘不工作
```bash
# 检查虚拟键盘配置
cat /etc/sddm.conf.d/virtualkbd.conf

# 检查 Qt6 虚拟键盘包是否安装
nix-store -qR /run/current-system | grep qtvirtualkeyboard
```

### 字体显示异常
```bash
# 重新生成字体缓存
sudo fc-cache -f -v

# 检查字体文件
ls -la /usr/share/fonts/
```

### 回退到默认主题
```bash
# 编辑 SDDM 配置
sudo nano /etc/sddm.conf

# 修改主题为默认
[Theme]
Current=breeze

# 重启 SDDM
sudo systemctl restart sddm
```

## 📁 相关文件位置

- **主题目录**: `/usr/share/sddm/themes/sddm-astronaut-theme/`
- **SDDM 配置**: `/etc/sddm.conf`
- **虚拟键盘配置**: `/etc/sddm.conf.d/virtualkbd.conf`
- **字体目录**: `/usr/share/fonts/`
- **SDDM 日志**: `journalctl -u sddm`

## 🎯 优化建议

1. **性能优化**: 静态壁纸比动态壁纸性能更好
2. **分辨率支持**: 主题主要为 1080p 设计，其他分辨率可能需要微调
3. **字体优化**: 确保中文字体正确显示
4. **安全性**: 定期更新主题包以获得最新修复

## 🙏 致谢

感谢 **[Keyitdev](https://github.com/Keyitdev)** 开发的精美 SDDM 主题！

- 项目主页: https://github.com/Keyitdev/sddm-astronaut-theme
- 预览视频: https://youtu.be/4tQ56xh7wBc
- 支持作者: https://ko-fi.com/keyitdev

---

配置完成后，你的登录界面将拥有专业级的视觉效果！🚀