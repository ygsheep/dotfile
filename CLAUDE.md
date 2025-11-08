# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Niri-Dot is a modular NixOS desktop environment configuration featuring **Niri** (scrollable tiling window manager) + **Noctalia** (modern desktop shell), optimized for Chinese users. The project uses a **3-layer startup chain** architecture: `systemd → greetd → niri-session → Niri WM + Noctalia-shell`.

## Essential Commands

### Development & Testing
```bash
# Enter development environment
nix develop

# Run all checks (syntax, format, build validation)
make check
# or
./scripts/testing/ci-check.sh

# Validate configuration integrity
make validate
# or
./scripts/testing/validate-config.sh

# Check project structure
./scripts/testing/check-structure.sh

# Format all Nix files
make format
# or
alejandra .

# Quick syntax check without building
nix flake check --no-build
```

### Build & Deployment
```bash
# Build configuration
make build

# Apply configuration (requires root)
make switch
# or
sudo nixos-rebuild switch --flake .

# Test build without applying
make test-build
# or
nix build .#nixosConfigurations.desktop.config.system.build.toplevel

# Recommended: use nh tool for deployment
nh os switch
nh os test
nh os clean
```

### Maintenance
```bash
# Update dependencies
make update
# or
nix flake update

# Clean build artifacts
make clean

# Show project status
make status
```

## Architecture Overview

### Core Directory Structure
```
Niri-Dot/
├── flake.nix                    # Entry point with global variables
├── home/                        # User-level configuration (Home Manager)
│   ├── apps/                   # GUI applications (was software/)
│   ├── cli/                    # Command-line tools (was terminal/)
│   ├── desktop/                # Desktop environment config
│   └── programs/               # Program-specific configs
├── system/                     # System-level NixOS configuration
├── hosts/                      # Host-specific configurations
├── scripts/                    # Utility scripts
│   ├── setup/                  # Installation scripts
│   ├── maintenance/            # Maintenance scripts
│   └── testing/                # Testing and validation
├── assets/                     # Shared resources (wallpapers, fonts)
└── docs/                       # Documentation center
```

### Global Variables Pattern
The project uses centralized configuration in `flake.nix`:
```nix
globals = {
  user = "sheep";
  homeDir = "/home/sheep";
  projectDir = toString ./.;
  assetsDir = "${toString ./.}/assets";
  version = "2.0.0";
};
```

**Always use `globals.user` instead of hardcoding "sheep"**, and `globals.homeDir` instead of hardcoded paths.

### Module Import Pattern
Configuration follows this import hierarchy:
- System level: `system/default.nix` → modules (chinese/, core/, hardware/, etc.)
- User level: `home/default.nix` → modules (cli/, apps/, desktop/, etc.)
- Host level: `hosts/default.nix` → system + user configurations

### Key Configuration Files

#### Entry Points
- `flake.nix`: Global variables, dependencies, outputs, dev environment
- `home/default.nix`: User configuration entry, Stylix theme system
- `system/default.nix`: System configuration entry
- `hosts/default.nix`: Host-specific configuration merging

#### Critical Components
- `home/desktop/wayland/niri/`: Niri window manager settings, binds, animations
- `home/apps/noctalia/`: Noctalia desktop shell unified configuration
- `system/services/greetd.nix`: Display manager with 3-layer startup chain
- `system/chinese/`: Complete Chinese localization (fonts, input methods)

## Development Workflow

### 1. Before Making Changes
```bash
# Always run checks first
make check

# Validate structure
./scripts/testing/check-structure.sh
```

### 2. Configuration Development
- Use `nix develop` for development environment
- Format code with `make format` before committing
- Test changes with `nixos-rebuild test --flake .`
- Apply with `make switch` when ready

### 3. Module Creation
When adding new modules:
- Follow the existing directory structure
- Use global variables instead of hardcoded values
- Add appropriate imports to parent `default.nix`
- Test with validation scripts

## Important Patterns & Conventions

### Global Variables Usage
```nix
# ❌ Hardcoded
homeDirectory = "/home/sheep";
NH_FLAKE = "/home/sheep/.dotfile";

# ✅ Global variables
homeDirectory = globals.homeDir;
NH_FLAKE = globals.projectDir;
```

### Service Management Pattern
```nix
# Startup services in Niri settings
spawn-at-startup = [
  {command = ["swww-daemon"];}
  {command = ["wl-paste" "--watch" "cliphist" "store"];}
];
```

### Theme System
Uses Stylix for unified theming:
```nix
stylix = {
  enable = true;
  polarity = "dark";
  base16Scheme = "${inputs.self}/home/shared/colors/gruvbox-dark-hard.yml";
};
```

### Input Method Configuration
Chinese input method setup:
- Framework: Fcitx5 + Rime (雾凇拼音)
- Switch: Ctrl+Space
- Layout: CN with optimizations

## Testing & Validation

### Automated Checks
The project includes comprehensive validation scripts that check:
- Syntax errors in all .nix files
- Code formatting (alejandra)
- Module import consistency
- Global variable usage
- Script quality and error handling
- File integrity and structure

### Performance Testing
```bash
# Startup performance analysis
./scripts/testing/test-startup-performance.sh
```

### Maintenance Scripts
```bash
# Random wallpaper switching (every 5 minutes)
./scripts/maintenance/random-wallpaper.sh
```

## Configuration Management

### NH Tool Integration
The project integrates with `nh` for better NixOS management:
- `nh os switch` - Apply configuration
- `nh os test` - Test configuration
- `nh os clean` - Clean old generations

### Dependency Management
- Uses Nix Flakes with version locking
- Critical inputs follow `nixpkgs` for consistency
- Regular updates with `nix flake update`

## Special Considerations

### Path Migrations (v2.0.0)
Recent reorganization changed these paths:
- `home/software/` → `home/apps/`
- `home/terminal/` → `home/cli/`
- Scripts moved to subdirectories: `setup/`, `maintenance/`, `testing/`

### Performance Optimizations
- 3-layer startup chain (reduced from 5 layers)
- ZRAM compression (25% of RAM)
- Optimized service startup order

### Chinese Localization
Complete Chinese support including:
- Fonts: Noto CJK, Source Han Sans
- Input methods: Fcitx5 + Rime
- Mirrors: Chinese package mirrors
- Localization: System-wide Chinese settings

## Troubleshooting Common Issues

### Build Failures
1. Run `make check` to identify syntax issues
2. Check `flake.lock` consistency
3. Verify all imports exist
4. Use `nix flake check --no-build` for syntax-only validation

### Service Issues
```bash
# Check display manager
systemctl status greetd

# Check user session
systemctl --user status niri-session

# View logs
journalctl -u greetd -f
journalctl --user -u niri-session -f
```

### Performance Issues
- Run `./scripts/testing/test-startup-performance.sh`
- Check for unnecessary services
- Monitor memory usage with `systemd-cgtop`