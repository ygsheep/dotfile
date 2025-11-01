#!/bin/bash

# 随机壁纸切换脚本
# 每300秒（5分钟）自动切换壁纸

WALLPAPER_DIR="/home/sheep/Niri-Dot/assets/wallpaper"
INTERVAL=300  # 300秒 = 5分钟

# 检查swww是否运行
if ! pgrep -x "swww-daemon" > /dev/null; then
    echo "启动 swww-daemon..."
    swww-daemon &
    sleep 2
fi

echo "开始随机壁纸切换，间隔 ${INTERVAL} 秒"
echo "按 Ctrl+C 停止"

while true; do
    # 随机选择一张壁纸
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

    if [ -n "$WALLPAPER" ]; then
        echo "切换到壁纸: $(basename "$WALLPAPER")"
        # 使用平滑过渡效果设置壁纸
        swww img "$WALLPAPER" --transition-type center --transition-fps 60 --transition-step 2
    else
        echo "未找到壁纸文件"
    fi

    # 等待指定时间
    sleep $INTERVAL
done
