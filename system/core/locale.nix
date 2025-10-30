# systems/core/locale.nix - 区域和语言设置
{ config, pkgs, lib, ... }:

{
  # 控制台配置
  console = {
    useXkbConfig = true; # 使用 xkb 配置
  };
}