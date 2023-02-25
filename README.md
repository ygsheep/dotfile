# ~/.dotfiles
My ArchLinux backup


## Quet start

```shell
# 
sudo pacman -S base-devel

# xorg x11 
sudo pacman -S xorg xorg-xinit 



# chromium 
yay -S chromium micorsoft-edge-stable-bin

# keyd 
yay -S keyd 
sudo systemctl enable keyd

# config: /etc/keyd/default.conf
[ids]
*
[main]
capslock = overload(control, esc)


------------------------

# build tools 
sudo pacman -S gcc cmake cland 

# ranger
sudo pacman -S ueberzug

```

## fcitx5 
```shell
sudo pacman -S fcitx5 fcitx5-qt fcitx5-gtk fcitx5-config-qt fcitx5-material-color fcitx5-im fcitx5-rime 
sudo pacman -S fcitx5-chinese-addons

sudo echo '
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus' >> /etc/environment
```

## 音频和蓝牙
```shell
sudo pacman -S pipewire-pulse
sudo pacman -S pavucontrol
sudo pacman -S bluez bluez-utils bluedevil # bluedevil 为gui蓝牙管理
pactl load-module module-bluetooth-discover

sudo vim /etc/bluetooth/main.conf
FastConnectable=true
AutoEnable=true
```

## 自动挂载硬盘
```shell
yay -S udisks2 udevil
sudo systemctl enable devmon@yysheep.service
```

## more tool
```shell
yay -S lxappearance              # gui设置
yay -S paper-gtk-theme-git       # gtk主题
yay -S pavucontrol               # 音频设置
yay -S breeze-icons              # 图标
yay -S rofi                      # 菜单
yay -S flameshot                 # 截图软件
yay -S google-chrome wyeb-git    # 浏览器             
yay -S byzanz                    # gif截图依赖
yay -S wps-office-cn             # wps
yay -S libnotify dunst           # 通知 可使用 dunst -b 命令 启动通知服务
yay -S xorg-xsetroot             # dwm设置状态栏
yay -S xf86-input-synaptics      # 触控板
yay -S network-manager-applet    # 网络托盘
yay -S amf-amdgpu-pro            # amd gpu 驱动
yay -S obs-studio-amf            # obs for amd_gpu
yay -S mpc mpd ncmpcpp           # tui music player
```

## .Xresources
x11 dpi等设置
```bash
# vim  ~/.Xresources
# 100	--> 95
# 125	--> 120
# 150	--> 144
# 200	--> 192
Xft.dpi: 144 # dpi 设置

```
## oh-my-zsh
配置文件：`./config/.zshrc`


## [dwm](https://github.com/yaoccc/dwm) [St](https://github.com/yaoccc/st)
使用的是[yaoccc](https://github.com/yaoccc/)的配置



## [nvim](https://github.com/ygsheep/nvim)
个人自用配置
