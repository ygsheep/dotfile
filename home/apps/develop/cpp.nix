{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # ========== 编译工具 ==========
    gcc
    cmake
    ninja
    pkg-config

    # ========== 调试工具 ==========
    gdb
    valgrind
    cppcheck

    # ========== 构建工具 ==========
    gnumake
    autoconf
    automake
    libtool

    # ========== C++ 库 ==========
    boost190

    # ========== OpenGL/Vulkan ==========
    mesa
    libGL
    vulkan-loader
    vulkan-headers
    vulkan-tools
    mesa.drivers # Intel/AMD/Software Vulkan 驱动
    egl-wayland

    # ========== Wayland ==========
    wayland
    wayland-protocols
    libxkbcommon
    wayland-scanner
    libffi

    # ========== X11 ==========
    xorgproto
    libX11
    libXext
    libXcursor
    libXrandr
    libXi
    libXfixes
    libXScrnSaver
    libXtst
    libxcb
    xcbutil
    xcbutilcursor
    xcbutilkeysyms
    xcbutilwm

    # ========== PipeWire ==========
    pipewire

    # ========== 其他开发工具 ==========
    clang-tools
    bear
    ccache
  ];

  # ========== Shell 初始化脚本 - 设置 C++ 开发环境变量 ==========
  # 使用 $USER 环境变量动态构建路径，避免硬编码用户名
  programs.bash.initExtra = ''
    # C++ 开发环境 - 动态设置库路径
    export NIX_PROFILE="/etc/profiles/per-user/$USER"

    # 头文件路径
    export CPATH="$NIX_PROFILE/include:$CPATH"

    # CMake 前缀路径
    export CMAKE_PREFIX_PATH="$NIX_PROFILE:$CMAKE_PREFIX_PATH"

    # Boost 路径
    export BOOST_ROOT="$NIX_PROFILE"

    # 库路径
    export LD_LIBRARY_PATH="$NIX_PROFILE/lib:$LD_LIBRARY_PATH"

    # PKG_CONFIG_PATH
    export PKG_CONFIG_PATH="$NIX_PROFILE/lib/pkgconfig:$PKG_CONFIG_PATH"

    # SDL 显示后端
    if [ -n "$WAYLAND_DISPLAY" ]; then
      export SDL_VIDEODRIVER=wayland
    elif [ -n "$DISPLAY" ]; then
      export SDL_VIDEODRIVER=x11
    fi
  '';

  programs.zsh.initExtra = ''
    # C++ 开发环境 - 动态设置库路径
    export NIX_PROFILE="/etc/profiles/per-user/$USER"

    # 头文件路径
    export CPATH="$NIX_PROFILE/include:$CPATH"

    # CMake 前缀路径
    export CMAKE_PREFIX_PATH="$NIX_PROFILE:$CMAKE_PREFIX_PATH"

    # Boost 路径
    export BOOST_ROOT="$NIX_PROFILE"

    # 库路径
    export LD_LIBRARY_PATH="$NIX_PROFILE/lib:$LD_LIBRARY_PATH"

    # PKG_CONFIG_PATH
    export PKG_CONFIG_PATH="$NIX_PROFILE/lib/pkgconfig:$PKG_CONFIG_PATH"

    # SDL 显示后端
    if [ -n "$WAYLAND_DISPLAY" ]; then
      export SDL_VIDEODRIVER=wayland
    elif [ -n "$DISPLAY" ]; then
      export SDL_VIDEODRIVER=x11
    fi
  '';

  programs.nushell.extraConfig = ''
    # C++ 开发环境 - 动态设置库路径
    $env.NIX_PROFILE = $"/etc/profiles/per-user/($env.USER)"

    # 头文件路径
    $env.CPATH = $"($env.NIX_PROFILE)/include:($env.CPATH? | default [])"

    # CMake 前缀路径
    $env.CMAKE_PREFIX_PATH = $"($env.NIX_PROFILE):($env.CMAKE_PREFIX_PATH? | default [])"

    # Boost 路径
    $env.BOOST_ROOT = $env.NIX_PROFILE

    # 库路径
    $env.LD_LIBRARY_PATH = $"($env.NIX_PROFILE)/lib:($env.LD_LIBRARY_PATH? | default [])"

    # PKG_CONFIG_PATH
    $env.PKG_CONFIG_PATH = $"($env.NIX_PROFILE)/lib/pkgconfig:($env.PKG_CONFIG_PATH? | default [])"

    # SDL 显示后端
    if ($env.WAYLAND_DISPLAY? | default null) != null {
      $env.SDL_VIDEODRIVER = "wayland"
    } else if ($env.DISPLAY? | default null) != null {
      $env.SDL_VIDEODRIVER = "x11"
    }
  '';
}
