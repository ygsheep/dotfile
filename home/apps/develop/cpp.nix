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

    # Development tools
    clang-tools
    bear
    ccache
  ];
}
