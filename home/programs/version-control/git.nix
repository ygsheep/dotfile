{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      key = "481EFFCF2C7B8C7B";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "sheep";
        email = "sheep@sheep.dev";
      };

      init.defaultBranch = "main";
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      core.editor = "hx";
      push.default = "current";
      merge.stat = "true";
      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      repack.usedeltabaseoffset = "true";
      pull.ff = "only";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };

      alias = {
        co = "checkout";
        fuck = "commit --amend -m";
        ca = "commit -am";
        d = "diff";
        ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
        pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
        af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
        st = "status";
        br = "branch";
        df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
        hist = ''
          log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all
        '';
        llog = ''
          log --graph --name-status --pretty=format:"%C(red)%h %Creset(%cd) %C(green)%an %Creset%s %C(yellow)%d%C(reset)" --date=relative'';
        edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
      };
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        true-color = "never";
        features = "unobtrusive-line-numbers decorations";
        unobtrusive-line-numbers = {
          line-numbers = true;
          line-numbers-left-format = "{nm:>4}│";
          line-numbers-right-format = "{np:>4}│";
          line-numbers-left-style = "grey";
          line-numbers-right-style = "grey";
        };
        decorations = {
          commit-decoration-style = "bold grey box ul";
          file-style = "bold blue";
          file-decoration-style = "ul";
          hunk-header-decoration-style = "box";
        };
      };
    };

    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];
  };

  # GitHub CLI integration
  home.packages = with pkgs; [gh];
}
