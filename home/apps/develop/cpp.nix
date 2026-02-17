{pkgs, ...}: {
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

  # ========== C++ 开发环境变量 ==========
  home.sessionVariables = {
    # 库路径 - 确保 SDL3 可以动态加载 X11/Wayland 库
    LD_LIBRARY_PATH =
      "${pkgs.libGL}/lib:"
      + "${pkgs.mesa}/lib:"
      + "${pkgs.libX11}/lib:"
      + "${pkgs.libXext}/lib:"
      + "${pkgs.libXcursor}/lib:"
      + "${pkgs.libXrandr}/lib:"
      + "${pkgs.libXi}/lib:"
      + "${pkgs.libXfixes}/lib:"
      + "${pkgs.libffi}/lib:"
      + "${pkgs.wayland}/lib:"
      + "${pkgs.libxkbcommon}/lib:"
      + "${pkgs.pipewire}/lib:"
      + "${pkgs.vulkan-loader}/lib:$LD_LIBRARY_PATH";

    # PKG_CONFIG_PATH
    PKG_CONFIG_PATH =
      "${pkgs.wayland}/lib/pkgconfig:"
      + "${pkgs.libxkbcommon}/lib/pkgconfig:"
      + "${pkgs.libffi}/lib/pkgconfig:$PKG_CONFIG_PATH";

    # Vulkan ICD 路径 - Mesa 驱动 (lavapipe 软件渲染)
    VK_ICD_FILENAMES =
      "${pkgs.mesa.drivers}/share/vulkan/icd.d/lvp_icd.x86_64.json:"
      + "${pkgs.mesa.drivers}/share/vulkan/icd.d/intel_icd.x86_64.json:"
      + "${pkgs.mesa.drivers}/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  # ========== Shell 初始化脚本 ==========
  # 自动检测并使用合适的后端
  programs.bash.initExtra = ''
    # C++ 开发环境 - 自动检测显示后端
    if [ -n "$WAYLAND_DISPLAY" ]; then
      export SDL_VIDEODRIVER=wayland
    elif [ -n "$DISPLAY" ]; then
      export SDL_VIDEODRIVER=x11
    fi
  '';

  programs.zsh.initExtra = ''
    # C++ 开发环境 - 自动检测显示后端
    if [ -n "$WAYLAND_DISPLAY" ]; then
      export SDL_VIDEODRIVER=wayland
    elif [ -n "$DISPLAY" ]; then
      export SDL_VIDEODRIVER=x11
    fi
  '';

  programs.nushell.extraConfig = ''
    # C++ 开发环境 - 自动检测显示后端
    if ($env.WAYLAND_DISPLAY != null) {
      $env.SDL_VIDEODRIVER = "wayland"
    } else if ($env.DISPLAY != null) {
      $env.SDL_VIDEODRIVER = "x11"
    }
  '';
}
