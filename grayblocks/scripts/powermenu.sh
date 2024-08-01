#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="~/.config/polybar/grayblocks/scripts/rofi"
uptime=$(uptime -p | sed -e 's/up //g;s/day/天/g;s/,//g;s/hours/小时/g;s/minutes/分/g')

rofi_command="rofi -no-config -theme $dir/powermenu.rasi"

# Options
shutdown=" 关机"
reboot=" 重启"
lock=" 锁定"
suspend=" 睡眠"
logout=" 注销"

# Confirmation
confirm_exit() {
  rofi -dmenu -no-config -i -no-fixed-num-lines -p "Are You Sure? : " \
    -theme $dir/confirm.rasi
}

# Message
msg() {
  rofi -no-config -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "开机时间: $uptime" -dmenu -selected-row 0)"
case $chosen in
$shutdown)
  systemctl poweroff
  ;;
$reboot)
  systemctl reboot
  ;;
$lock)
  if [[ -f /usr/bin/i3lock ]]; then
    i3lock
  elif [[ -f /usr/bin/betterlockscreen ]]; then
    betterlockscreen -l
  fi
  ;;
$suspend)
  mpc -q pause
  amixer set Master mute
  systemctl suspend
  ;;
$logout)
  if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
    openbox --exit
  elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
    bspc quit
  elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
    i3-msg exit
  fi
  ;;
esac
