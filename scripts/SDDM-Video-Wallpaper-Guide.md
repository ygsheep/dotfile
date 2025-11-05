# SDDM Astronaut 主题视频壁纸配置指南

SDDM Astronaut 主题支持多种动态壁纸，包括 GIF 动画和视频文件。以下是详细的配置方法。

## 🎬 支持的媒体格式

### 📹 视频格式
- MP4 (推荐)
- WebM
- AVI
- MOV
- MKV

### 🎨 动图格式
- GIF
- APNG
- WebP 动画

## ⚙️ 视频壁纸配置参数

在主题配置文件（如 `Themes/astronaut.conf`）中，你可以使用以下参数：

### 核心参数

```ini
[General]
# 媒体文件路径（相对于主题目录）
Background=Backgrounds/your_video.mp4

# 播放速度控制（0.0-10.0，1.0 为正常速度）
BackgroundSpeed=1.0

# 暂停动画播放（仅适用于 GIF）
PauseBackground=false

# 背景裁剪模式
CropBackground=true

# 水平对齐（当 CropBackground=false 时）
BackgroundHorizontalAlignment=center

# 垂直对齐（当 CropBackground=false 时）
BackgroundVerticalAlignment=center

# 视频开始前的占位图片
BackgroundPlaceholder=Backgrounds/placeholder.jpg
```

## 📁 文件组织结构

```
/usr/share/sddm/themes/sddm-astronaut-theme/
├── Backgrounds/                    # 媒体文件目录
│   ├── your_video.mp4             # 你的视频文件
│   ├── animated_background.gif    # GIF 动图
│   └── placeholder.jpg            # 占位图片
├── Themes/
│   ├── astronaut.conf             # 主题配置文件
│   ├── cyberpunk.conf
│   └── custom_video.conf          # 自定义配置
├── Main.qml                       # 主界面文件
└── metadata.desktop               # 主题元数据
```

## 🎯 配置步骤

### 1. 准备媒体文件

```bash
# 创建背景文件目录
sudo mkdir -p /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds

# 复制你的视频文件
sudo cp /path/to/your/video.mp4 /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/

# 设置文件权限
sudo chmod 644 /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/video.mp4
```

### 2. 创建自定义主题配置

```bash
# 复制默认配置作为模板
sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Themes/astronaut.conf \
   /usr/share/sddm/themes/sddm-astronaut-theme/Themes/custom_video.conf
```

### 3. 编辑配置文件

```bash
sudo nano /usr/share/sddm/themes/sddm-astronaut-theme/Themes/custom_video.conf
```

配置示例：

```ini
[General]
# 使用视频背景
Background=Backgrounds/my_video.mp4

# 设置播放速度（可选）
BackgroundSpeed=1.2

# 视频播放前的占位图（可选）
BackgroundPlaceholder=Backgrounds/loading.jpg

# 裁剪模式（true=填充屏幕，false=适应屏幕）
CropBackground=true

# 对齐方式（当不裁剪时）
BackgroundHorizontalAlignment=center
BackgroundVerticalAlignment=center
```

### 4. 应用自定义配置

编辑 `metadata.desktop` 文件：

```bash
sudo nano /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
```

修改 `ConfigFile=` 行：
```ini
[X-SDDM-Theme]
ConfigFile=Themes/custom_video.conf
```

### 5. 重启 SDDM

```bash
sudo systemctl restart sddm
```

## 🎨 预设主题配置示例

### 🔥 Cyberpunk 风格视频背景

```ini
[General]
Background=Backgrounds/cyberpunk_video.mp4
BackgroundSpeed=1.0
CropBackground=true
```

### 🌸 日式美学 GIF 背景

```ini
[General]
Background=Backgrounds/japanese_aesthetic.gif
BackgroundSpeed=0.8
PauseBackground=false
CropBackground=false
BackgroundHorizontalAlignment=center
BackgroundVerticalAlignment=center
```

### 🕳️ 黑洞动画背景

```ini
[General]
Background=Backgrounds/black_hole.webm
BackgroundSpeed=0.5
CropBackground=true
```

### 🌌 太空主题

```ini
[General]
Background=Backgrounds/space_video.mp4
BackgroundSpeed=1.0
BackgroundPlaceholder=Backgrounds/space_loading.jpg
CropBackground=true
```

## 🎬 视频优化建议

### 📏 分辨率和格式
- **推荐分辨率**: 1920x1080 或更高
- **推荐格式**: MP4 (H.264 编码)
- **推荐帧率**: 30-60 FPS
- **推荐时长**: 10-30 秒循环

### 🗜️ 文件大小优化
- 使用 H.264 或 H.265 编码
- 控制文件大小在 50MB 以内
- 使用适当的压缩率

### 🔄 循环播放
- 视频应该是无缝循环的
- 开始和结束帧应该相似
- 避免明显的跳跃

## 🛠️ 故障排除

### 视频不播放

```bash
# 检查视频文件权限
ls -la /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/

# 检查视频编码格式
ffprobe /usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/your_video.mp4

# 查看 SDDM 日志
journalctl -u sddm -f
```

### 播放卡顿

1. **降低视频分辨率**
2. **减少视频文件大小**
3. **降低播放速度**
4. **检查系统资源使用**

```ini
[General]
Background=Backgrounds/your_video.mp4
BackgroundSpeed=0.8  # 降低速度
```

### 音频问题

SDDM 登录界面通常不会播放音频，如果视频包含音频：
```bash
# 移除音频轨道（推荐）
ffmpeg -i input.mp4 -vcodec copy -an output.mp4

# 或者在配置中禁用音频（如果支持）
```

## 🎯 高级配置

### 多媒体切换

你可以创建一个脚本在不同背景之间切换：

```bash
#!/bin/bash
# switch_background.sh

THEMES=("astronaut" "cyberpunk" "japanese_aesthetic" "black_hole")
SELECTED_THEME=${THEMES[$RANDOM % ${#THEMES[@]}]}

sudo sed -i "s|ConfigFile=Themes/.*\.conf|ConfigFile=Themes/${SELECTED_THEME}.conf|" \
    /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop

sudo systemctl restart sddm
```

### 时间相关背景

创建根据时间变化的背景：

```bash
#!/bin/bash
# time_based_background.sh

HOUR=$(date +%H)

if [ $HOUR -ge 6 ] && [ $HOUR -lt 12 ]; then
    THEME="astronaut"      # 早晨
elif [ $HOUR -ge 12 ] && [ $HOUR -lt 18 ]; then
    THEME="cyberpunk"      # 下午
elif [ $HOUR -ge 18 ] && [ $HOUR -lt 22 ]; then
    THEME="japanese_aesthetic"  # 傍晚
else
    THEME="black_hole"     # 夜晚
fi

sudo sed -i "s|ConfigFile=Themes/.*\.conf|ConfigFile=Themes/${THEME}.conf|" \
    /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop

sudo systemctl restart sddm
```

## 🎨 创意建议

### 1. 动态雨滴效果
- 使用带雨滴的视频
- 配合雨天音效（虽然不会播放）

### 2. 粒子动画
- 使用粒子系统视频
- 设置较低的播放速度

### 3. 渐变动画
- 使用颜色渐变视频
- 设置 BackgroundSpeed=0.5

### 4. 抽象动画
- 使用抽象几何图形动画
- 设置 CropBackground=false 以适应屏幕

## 📚 参考资源

- **视频转换工具**: FFmpeg
- **GIF 制作工具**: GIMP, ImageMagick
- **视频素材网站**: Pexels, Pixabay, Mixkit
- **主题仓库**: https://github.com/Keyitdev/sddm-astronaut-theme

---

配置完成后，你的登录界面将拥有动态的视觉效果！🚀