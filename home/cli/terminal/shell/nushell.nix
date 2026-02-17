{
  pkgs,
  lib,
  globals,
  ...
}: {
  programs = {
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    nushell = {
      enable = true;

      plugins = with pkgs.nushellPlugins; [
        # skim
        query
        gstat
        polars
      ];

      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "vi";
          buffer_editor = "hx";

          completions = {
            algorithm = "substring";
            sort = "smart";
            case_sensitive = false;
            quick = true;
            partial = true;
            use_ls_colors = true;
          };

          shell_integration = {
            osc2 = true;
            osc7 = true;
            osc8 = true;
          };

          use_kitty_protocol = true;
          bracketed_paste = true;
          use_ansi_coloring = true;
          error_style = "fancy";

          display_errors = {
            exit_code = false;
            termination_signal = true;
          };

          table = {
            mode = "single";
            index_mode = "always";
            show_empty = true;
            padding.left = 1;
            padding.right = 1;
            trim = {
              methodology = "wrapping";
              wrapping_try_keep_words = true;
              truncating_suffix = "...";
            };
            header_on_separator = true;
            abbreviated_row_count = null;
            footer_inheritance = true;
          };

          ls.use_ls_colors = true;
          rm.always_trash = false;

          menus = [
            {
              name = "completion_menu";
              only_buffer_difference = false;
              marker = "? ";
              type = {
                layout = "ide";
                min_competion_width = 0;
                max_completion_width = 150;
                max_completion_height = 25;
                padding = 0;
                border = false;
                cursor_offset = 0;
                description_mode = "prefer_right";
                min_description_width = 0;
                max_description_width = 50;
                max_description_height = 10;
                description_offset = 1;
                correct_cursor_pos = true;
              };
              style = {
                text = "white";
                selected_text = "white_reverse";
                match_text = {
                  attr = "u";
                };
                selected_match_text = {
                  attr = "ur";
                };
                description_text = "yellow";
              };
            }
          ];

          cursor_shape = {
            vi_insert = "line";
            vi_normal = "block";
          };

          highlight_resolved_externals = true;
        };
        completions = let
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
        in
          names: builtins.foldl' (prev: str: "${prev}\n${str}") "" (map completion names);
      in ''
        $env.config = ${conf};

        ${completions [
          "git"
          "nix"
          "man"
          "rg"
          "gh"
          "glow"
          "bat"
        ]}

        # use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu
        # source ${pkgs.nu_scripts}/share/nu_scripts/modules/formats/from-env.nu

        # const path = "~/.nushellrc.nu"
        # const null = "/dev/null"
        # source (if ($path | path exists) {
        #     $path
        # } else {
        #     $null
        # })


        def fcd [] {
          let dir = (fd --type d | sk | str trim)
          if ($dir != "") {
            cd $dir
          }
        }

        def installed [] {
          nix-store --query --requisites /run/current-system/ | parse --regex '.*?-(.*)' | get capture0 | sk
        }

        def installedall [] {
          nix-store --query --requisites /run/current-system/ | sk | wl-copy
        }

        def --env fm [...args] {
        	let tmp = (mktemp -t "yazi-cwd.XXXXX")
        	yazi ...$args --cwd-file $tmp
        	let cwd = (open $tmp)
        	if $cwd != "" and $cwd != $env.PWD {
        		cd $cwd
        	}
        	rm -fp $tmp
        }
      '';

      shellAliases = {
        cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
        listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
        nixremove = "nix-store --gc";
        bloat = "nix path-info -Sh /run/current-system";
        c = "clear";
        q = "exit";
        cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
        trimall = "sudo fstrim -va";
        temp = "cd /tmp/";
        zed = "zeditor";
        koji = "meteor";
        gitui = "lazygit";

        test-build = "sudo nixos-rebuild test --flake .#desktop";
        switch-build = "sudo nixos-rebuild switch --flake .#desktop --show-trace";

        # 键盘布局
        kb-cn = "setxkbmap -layout cn";
        kb-us = "setxkbmap -layout us";
        kb-toggle = "setxkbmap -layout cn,us -option grp:alt_shift_toggle";
        kb-status = "setxkbmap -query";

        # git
        g = "git";
        add = "git add .";
        commit = "git commit";
        push = "git push";
        pull = "git pull";
        diff = "git diff --staged";
        gcld = "git clone --depth 1";
        gco = "git checkout";
        gitgrep = "git ls-files | rg";
        # gitrm = "git ls-files --deleted -z | xargs -0 git rm";

        cat = "bat --number --color=always --paging=never --tabs=2 --wrap=never";
        # fcd = "cd (fd --type d | sk | str trim)";
        grep = "rg";
        l = "eza -lF --time-style=long-iso --icons";
        # la = "eza -lah --tree";
        # ls = "eza -h --git --icons --color=auto --group-directories-first -s extension";
        ll = "eza -h --git --icons --color=auto --group-directories-first -s extension";
        tree = "eza --tree --icons --tree";

        # systemctl
        us = "systemctl --user";
        rs = "sudo systemctl";
      };

      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "  ";
        PROMPT_INDICATOR_VI_NORMAL = "∙ ";
        PROMPT_COMMAND = "";
        PROMPT_COMMAND_RIGHT = "";
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = "${pkgs.nushell}/bin/nu";
        EDITOR = "hx";
        VISUAL = "hx";
        CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash";

        # 中文环境变量
        LANG = "zh_CN.UTF-8";
        LC_ALL = "zh_CN.UTF-8";
      };
      extraEnv = ''
        $env.CARAPACE_BRIDGES = 'inshellisense,carapace,zsh,fish,bash'

        # ========== C++ 开发环境变量 ==========
        # 动态使用当前用户名，避免硬编码
        let nix_profile = $"/etc/profiles/per-user/($env.USER)"

        # 头文件路径
        $env.CPATH = ($env.CPATH? | default [] | split row (char esep)
          | prepend $"($nix_profile)/include"
          | str join (char esep))

        # CMake 前缀路径
        $env.CMAKE_PREFIX_PATH = ($env.CMAKE_PREFIX_PATH? | default [] | split row (char esep)
          | prepend $nix_profile
          | str join (char esep))

        # Boost 路径
        $env.BOOST_ROOT = $nix_profile

        # SDL 显示后端自动检测
        if ($env.WAYLAND_DISPLAY? | default null) != null {
          $env.SDL_VIDEODRIVER = 'wayland'
        } else if ($env.DISPLAY? | default null) != null {
          $env.SDL_VIDEODRIVER = 'x11'
        }

        # 用户本地 bin 路径（优先级从高到低）
        # OpenCode, 用户本地工具
        # Python: pipx, poetry
        # Node.js: npm, pnpm, yarn, bun, deno
        # Rust: cargo
        # Go: go
        $env.PATH = ($env.PATH | split row (char esep)
          | prepend '${globals.homeDir}/.local/bin'
          | prepend '${globals.homeDir}/.local/share/pnpm'
          | prepend '${globals.homeDir}/.local/share/npm/bin'
          | prepend '${globals.homeDir}/.npm-global/bin'
          | prepend '${globals.homeDir}/.bun/bin'
          | prepend '${globals.homeDir}/.deno/bin'
          | prepend '${globals.homeDir}/.cargo/bin'
          | prepend '${globals.homeDir}/go/bin'
          | prepend '${globals.homeDir}/.opencode/bin'
          | prepend '${globals.homeDir}/bin')
      '';
    };
  };
}
