# modified from https://github.com/gytis-ivaskevicius/flake-utils/plus
{
  coreutils,
  gnused,
  writeShellScriptBin,
}: let
  repl = ../../lib/repl.nix;
in
  writeShellScriptBin "repl" ''
    case "$1" in
      "-h"|"--help"|"help")
        echo "Usage:"
        echo "  repl - Loads system flake if available."
        echo "  repl /path/to/flake.nix - Loads specified flake."
        ;;
      *)
        if [ -z "$1" ]; then
          nix repl ${repl}
        else
          nix repl --arg flakePath $(${coreutils}/bin/readlink -f $1 | ${gnused}/bin/sed 's|/flake.nix||') ${repl}
        fi
        ;;
    esac
  ''
