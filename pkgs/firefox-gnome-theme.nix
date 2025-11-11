{
  stdenv,
  fetchFromGitHub,
  theme,
  lib,
}:
stdenv.mkDerivation {
  pname = "firefox-gnome-theme";
  version = "latest";

  src = theme;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r * $out/

    # 确保用户样式文件存在
    touch $out/userChrome.css
    touch $out/userContent.css
  '';

  meta = with lib; {
    description = "A GNOME theme for Firefox";
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    license = licenses.unlicense;
    platforms = platforms.all;
  };
}
