{pkgs, ...}: {
  home.packages = with pkgs; [
    # Compilers
    gcc
    cmake
    ninja
    pkg-config

    # Debuggers
    gdb
    valgrind

    # Build tools
    gnumake
    autoconf
    automake
    libtool

    # Libraries
    boost
    openssl
    zlib

    # Graphics & GUI libraries
    SDL2
    SDL2.dev
    wayland
    wayland-protocols
    libxkbcommon
    mesa
    glew
    glfw

    # X11 libraries
    xorg.libX11
    xorg.libXext
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi

    # Development tools
    clang-tools
    bear
    ccache
  ];
}
