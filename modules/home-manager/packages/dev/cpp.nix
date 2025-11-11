{pkgs, ...}: {
  home.packages = with pkgs; [
    # Compilers
    gcc
    clang
    cmake
    ninja
    pkg-config

    # Debuggers
    gdb
    lldb
    valgrind

    # Build tools
    make
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
