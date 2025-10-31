{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols

      # 基础字体
      dejavu_fonts
      liberation_ttf

      # Noto 字体系列
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts

      # 思源字体
      source-han-sans
      source-han-serif
      source-han-mono

      # 文泉驿字体
      wqy_microhei
      wqy_zenhei

      # 编程字体
      jetbrains-mono
      fira-code
      fira-code-symbols

      # 更纱黑体（编程用中文字体）
      sarasa-gothic

      # 其他常用字体
      ubuntu-classic
      roboto
      roboto-mono
      adwaita-fonts

      # Nerd Fonts（编程图标字体）
      nerd-fonts.symbols-only
      nerd-fonts.geist-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.ubuntu-mono
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = false;
        style = "slight"; # 使用轻量级提示以获得更好的中文渲染效果
      };
      subpixel = {
        lcdfilter = "default"; # 使用默认LCD过滤器
        rgba = "rgb";
      };

      defaultFonts = let
        addAll = builtins.mapAttrs (_: v: ["Symbols Nerd Font"] ++ v ++ ["Noto Color Emoji"]);
      in
        addAll {
          serif = [
            "Noto Serif CJK SC"
            "Noto Serif"
            "Source Han Serif SC"
          ];
          sansSerif = [
            "Noto Sans CJK SC"
            "Adwaita Sans"
            "Source Han Sans SC"
          ];
          monospace = [
            "JetBrains Mono"
            "Sarasa Mono SC"
            "Geist Nerd Font Mono"
            "Noto Sans Mono CJK SC"
          ];
          emoji = ["Noto Color Emoji"];
        };

      # 字体渲染本地配置
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- 启用抗锯齿 -->
          <match target="font">
            <edit name="antialias" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="hinting" mode="assign">
              <bool>true</bool>
            </edit>
            <edit name="hintstyle" mode="assign">
              <const>hintslight</const>
            </edit>
            <edit name="lcdfilter" mode="assign">
              <const>default</const>
            </edit>
          </match>

          <!-- 字体替换规则 -->
          <alias binding="strong">
            <family>SimSun</family>
            <prefer>
              <family>Noto Serif CJK SC</family>
            </prefer>
          </alias>

          <alias binding="strong">
            <family>SimHei</family>
            <prefer>
              <family>Noto Sans CJK SC</family>
            </prefer>
          </alias>

          <alias binding="strong">
            <family>Microsoft YaHei</family>
            <prefer>
              <family>Noto Sans CJK SC</family>
            </prefer>
          </alias>

          <!-- 禁用位图字体 -->
          <selectfont>
            <rejectfont>
              <pattern>
                <patelt name="scalable">
                  <bool>false</bool>
                </patelt>
              </pattern>
            </rejectfont>
          </selectfont>
        </fontconfig>
      '';
    };
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
  };

  # 用户字体目录支持
  system.fsPackages = [ pkgs.bindfs ];
  system.userActivationScripts.fonts = ''
    mkdir -p $HOME/.local/share/fonts
  '';
}
