{config, pkgs, ... }: 

{
  home.packages = with pkgs; [
    pkgs.clang
    pkgs.cmake
    pkgs.ninja
    pkgs.gnumake
    clang-tools
    codespell
    conan
    cppcheck
    doxygen
    gtest
    lcov
  ];
}
