# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NixOS is a modular NixOS desktop environment configuration optimized for Chinese users. Features:
- **Dual Desktop**: Niri WM (desktop) + KDE Plasma 6 (laptop)
- **Chinese Localization**: Fcitx5 + Rime input method, complete font support
- **3-Layer Startup**: `systemd → greetd → niri-session → desktop environment`
- **Architecture**: flake-parts based modular configuration

**Output Format**: Reply in Chinese (中文), end with "主人！主人！任务完成了，喵！"

## Essential Commands

```bash
# Development
nix develop              # Enter dev environment
make check              # Run all checks
make format              # Format Nix files
nix flake update        # Update dependencies

# Build & Deploy
make switch             # Apply config (default: thinkbook)
make switch-desktop     # Apply desktop config
make switch-thinkbook   # Apply thinkbook config
make build HOST=xxx     # Build specific host
nh os switch            # Apply with nh tool

# Hosts: desktop, thinkbook
```

## Architecture Overview

```
lib/              globals.nix          # Global variables (user, paths, version)
pkgs/             Custom packages
modules/          Reusable NixOS modules
home/             User-level config (Home Manager)
  ├── apps/        GUI applications
  ├── cli/         CLI tools (terminal, shell, software)
  ├── desktop/     Desktop env (kde.nix, wayland/niri/)
  ├── editors/     Editor configs (helix, nvim, vscode, zed)
  ├── programs/    Input method, version control
  ├── services/    User services
  ├── shared/      Colors, themes
  └── profiles/   Host-specific profiles (desktop/, thinkbook/)
system/           System-level NixOS config
  ├── chinese/     Fonts, input methods, localization
  ├── core/        Boot, security, users
  ├── desktop/     KDE integration
  ├── hardware/    Bluetooth, graphics
  ├── network/      Avahi, network config
  ├── nix/         NH, substituters, nixpkgs
  ├── programs/    System programs
  └── services/    System services (greetd, pipewire, etc.)
hosts/            Host-specific hardware configs
  ├── desktop/     Niri WM + greetd
  └── thinkbook/   KDE Plasma 6 + SDDM
scripts/          Utility scripts (maintenance/, testing/)
```

## Global Variables

**Location**: `lib/globals.nix`

```nix
globals = {
  user = "sheep";
  homeDir = "/home/sheep";
  projectDir = toString self;
  assetsDir = "${toString self}/assets";
  version = "2.0.0";
};
```

**Always use `globals.user` instead of "sheep"**, avoid hardcoding paths.

## Host Configurations

### Desktop (`hosts/desktop/`)
- Desktop Environment: Niri WM + QuickShell/Noctalia
- Display Manager: greetd
- Use Case: Desktop workstation

### ThinkBook (`hosts/thinkbook/`)
- Desktop Environment: KDE Plasma 6 + Niri WM (dual)
- Display Manager: SDDM
- Display Scaling: 1.75x (HiDPI: 2560x1600 @ 120Hz)
- Use Case: Laptop/workstation

### Common
- Chinese: Fcitx5 + Rime (Ctrl+Space)
- Terminal: Kitty/Foot
- Theme: Stylix (Gruvbox Dark Hard)
- Dev Tools: Rust, Python, Node.js, Go

## Key Files

| File | Purpose |
|------|---------|
| `flake.nix` | Entry point, flake-parts config |
| `lib/globals.nix` | Global variables |
| `home/default.nix` | Home Manager entry |
| `home/profiles/default.nix` | Profile definitions |
| `system/default.nix` | System module lists |
| `hosts/default.nix` | Host configurations |
| `home/desktop/wayland/niri/settings.nix` | Niri WM settings |
| `system/chinese/input-methods.nix` | Fcitx5 + Rime setup |

## Git Workflow

**REQUIRED**:
1. Always create feature branch before changes
2. Always run `make check` before commit
3. Always test build before merge
4. Write meaningful commit messages

**PROHIBITED**:
- Direct changes to main branch
- Pushing untested changes
- Skipping validation

**Branch Naming**: `feature/xxx`, `bugfix/xxx`, `refactor/xxx`

## Important Patterns

### Global Variables Usage
```nix
# ❌ Hardcoded
homeDirectory = "/home/sheep";

# ✅ Global variables
homeDirectory = globals.homeDir;
```

### Service Management
```nix
# Niri startup services
spawn-at-startup = [
  {command = ["fcitx5" "-d" "--replace"];}
  {command = ["wl-paste" "--watch" "cliphist" "store"];}
];
```

### Theme System
```nix
stylix = {
  enable = true;
  polarity = "dark";
  base16Scheme = "${inputs.self}/home/shared/colors/gruvbox-dark-hard.yml";
};
```

## Maintenance Scripts

```bash
./scripts/maintenance/toggle-kde-theme.sh    # Toggle KDE theme
./scripts/maintenance/random-wallpaper.sh     # Random wallpaper
```

## Testing

```bash
make check                        # All checks
./scripts/testing/ci-check.sh       # CI validation
./scripts/testing/validate-config.sh # Config integrity
nix flake check --no-build        # Syntax only
```

## Troubleshooting

| Issue | Command |
|--------|----------|
| Build fail | `make check` |
| Service status | `systemctl status greetd`, `systemctl --user status niri-session` |
| View logs | `journalctl -u greetd -f`, `journalctl --user -u niri-session -f` |
| Home Manager | `systemctl --user status home-manager-sheep` |
| KDE issues | `./scripts/maintenance/toggle-kde-theme.sh` |

## Version History

- **v2.0.0**: Path reorganization (`home/software/` → `home/apps/`, `home/terminal/` → `home/cli/`)
