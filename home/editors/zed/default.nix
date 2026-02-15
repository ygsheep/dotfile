{pkgs, ...}: {
  home.packages = with pkgs; [
    pkgs.nodejs_24
    biome
    vue-language-server
    vscode-langservers-extracted
    nil
    typescript-language-server
    typescript
    zed-editor
    astro-language-server
  ];
}
