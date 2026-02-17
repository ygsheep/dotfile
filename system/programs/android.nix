# Android 开发环境配置
{pkgs, ...}: {
  # 接受 Android SDK 许可证
  nixpkgs.config.android_sdk.accept_license = true;

  # Android 开发工具
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    androidenv.androidPkgs.androidsdk
    androidenv.androidPkgs.ndk-bundle
    jdk
  ];
}
