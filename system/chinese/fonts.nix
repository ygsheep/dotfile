# systems/chinese/fonts.nix - 中文字体专门配置
{
  config,
  globals,
  pkgs,
  lib,
  ...
}: {
  # 中文字体包
  fonts.packages = with pkgs; [
    # 思源字体系列（推荐）
    source-han-sans
    source-han-serif
    source-han-mono

    # Noto 字体（Google）
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    # 文泉驿字体
    wqy_microhei
    wqy_zenhei

    # 更纱黑体（编程字体）
    sarasa-gothic

    # 方正字体（如果可用）
    # fangzheng-fonts  # 需要额外配置

    # 中文 Nerd Fonts
    # 从 assets/fonts 目录安装
    # ./assets/fonts
  ];

  # 本地字体安装（从 assets/fonts）
  # 使用 home-manager 的 home.fonts.fontDir 配置


  # 中文字体配置优化
  fonts.fontconfig.localConf = ''
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
          <const>lcddefault</const>
        </edit>
      </match>

      <!-- 中文字体优先级配置 -->
      <alias>
        <family>serif</family>
        <prefer>
          <family>Noto Serif CJK SC</family>
          <family>Source Han Serif SC</family>
          <family>WenQuanYi Zen Hei</family>
          <family>AR PL UMing CN</family>
          <family>AR PL ShanHeiSun Uni</family>
        </prefer>
      </alias>

      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Noto Sans CJK SC</family>
          <family>Source Han Sans SC</family>
          <family>WenQuanYi Micro Hei</family>
          <family>WenQuanYi Zen Hei</family>
          <family>AR PL UMing CN</family>
        </prefer>
      </alias>

      <alias>
        <family>monospace</family>
        <prefer>
          <family>Sarasa Mono SC</family>
          <family>Source Han Mono SC</family>
          <family>Noto Sans Mono CJK SC</family>
          <family>WenQuanYi Micro Hei Mono</family>
        </prefer>
      </alias>

      <!-- 常见字体替换 -->
      <match target="pattern">
        <test name="family" qual="any">
          <string>SimSun</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Noto Serif CJK SC</string>
        </edit>
      </match>

      <match target="pattern">
        <test name="family" qual="any">
          <string>SimHei</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Noto Sans CJK SC</string>
        </edit>
      </match>

      <match target="pattern">
        <test name="family" qual="any">
          <string>Microsoft YaHei</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Noto Sans CJK SC</string>
        </edit>
      </match>

      <!-- 中文字体渲染优化 -->
      <match target="font">
        <test name="lang" compare="contains">
          <string>zh</string>
        </test>
        <edit name="spacing" mode="assign">
          <const>proportional</const>
        </edit>
        <edit name="globaladvance" mode="assign">
          <bool>false</bool>
        </edit>
      </match>

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
}
