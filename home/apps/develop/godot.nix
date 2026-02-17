# Godot 游戏引擎开发环境
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    godot_4
    godot_4-export-templates-bin
  ];

  home.file.".local/share/godot/export_templates/${
    builtins.replaceStrings ["-"] ["."] pkgs.godot_4-export-templates-bin.version
  }".source =
    pkgs.godot_4-export-templates-bin;

  programs.helix = {
    languages.language = [
      {
        name = "gdscript";
        auto-format = true;
      }
    ];
  };
}
