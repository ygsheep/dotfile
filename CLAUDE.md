# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Niri-Dot is a modular NixOS desktop environment configuration featuring **Niri** (scrollable tiling window manager) + **Noctalia** (modern desktop shell), optimized for Chinese users. The project uses a **3-layer startup chain** architecture: `systemd → greetd → niri-session → Niri WM + Noctalia-shell`. This is a production-ready NixOS configuration with comprehensive Chinese localization and modern Wayland desktop environment.

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

### Flake-Based Architecture
The project uses modern flake-parts architecture:
- **flake.nix**: Central entry point with `inputs.flake-parts.lib.mkFlake`
- **imports**: `./home/profiles`, `./hosts`, `./pkgs` for modular structure
- **outputs**: Generated via perSystem configuration
- **globals**: Centralized variables passed through specialArgs

### Configuration Hierarchy
- **System level**: `system/default.nix` exports `desktop` and `laptop` module lists
- **User level**: `home/profiles/default.nix` defines Home Manager imports
- **Host level**: `hosts/default.nix` merges system + user using `nixosSystem`
- **Module pattern**: Each directory has `default.nix` for clean imports

### Key Configuration Files

#### Entry Points
- `flake.nix`: Central entry point using flake-parts, defines globals and dev environment
- `home/profiles/`: Home Manager configuration profiles (desktop, etc.)
- `system/default.nix`: System configuration with desktop/laptop variants
- `hosts/default.nix`: Merges system + user configurations via flake-parts

#### Critical Components
- `home/desktop/wayland/niri/`: Niri window manager settings, binds, animations
- `home/desktop/wayland/noctalia/unified.nix`: Noctalia desktop shell unified configuration
- `home/editors/`: Multi-editor support (nvim, helix, vscode, zed)
- `system/services/greetd.nix`: Display manager with 3-layer startup chain
- `system/chinese/`: Complete Chinese localization (fonts, input methods, mirrors)

## Development Workflow

### Git Branch Management
**IMPORTANT**: Always use branches for development work. Never make changes directly to the Niri-Dot branch.

```bash
# 1. Create feature branch for any changes
git checkout -b feature/your-change-name

# 2. Work on your branch, make changes
# - Edit files
# - Run validation tests
# - Commit changes with clear messages

# 3. Validate your changes
make check

# 4. When finished and all tests pass:
git checkout Niri-Dot    # Switch back to Niri-Dot branch
git merge feature/your-change-name    # Merge your changes

# 5. Push merged changes
git push origin Niri-Dot

# 6. Clean up (optional)
git branch -d feature/your-change-name
```

### 1. Development Environment
```bash
# Enter flake dev environment with globals
nix develop

# Environment variables available:
# NIRI_DOT_USER, NIRI_DOT_HOME, NIRI_DOT_PROJECT, NIRI_DOT_ASSETS
```

### 2. Validation & Testing (Before Commit)
```bash
# Always run full validation before committing
make check
# Individual checks:
./scripts/testing/ci-check.sh          # CI-style validation
./scripts/testing/validate-config.sh  # Configuration integrity
./scripts/testing/check-structure.sh  # Project structure validation
```

### 3. Module Development
When adding new modules:
- Create a feature branch first: `git checkout -b feature/new-module`
- Follow flake-parts pattern (no outputs in individual files)
- Use `globals` from specialArgs, not hardcoded values
- Add to appropriate parent `default.nix` imports
- Test with validation scripts before each commit
- Commit frequently with descriptive messages

### 4. Commit Standards
Write meaningful commit messages:
```bash
# Good commit format:
git commit -m "component: brief description

- Detailed explanation of what changed
- Why this change is needed
- Any breaking changes or side effects

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 5. Build & Deployment
```bash
# Test build without applying
make test-build
# Apply configuration (requires root)
make switch
# Or use nh tool
nh os switch
```

### 6. Before Merging Checklist
Before merging your feature branch to main:
- [ ] All validation tests pass (`make check`)
- [ ] Configuration builds successfully (`make test-build`)
- [ ] No breaking changes unless documented
- [ ] Code is properly formatted (`make format`)
- [ ] Commits have clear, descriptive messages
- [ ] Changes are tested on target system if possible

## Git Workflow Rules

### 🚫 PROHIBITED ACTIONS
- **NEVER** make changes directly to the `Niri-Dot` branch
- **NEVER** push untested changes to the `Niri-Dot` branch
- **NEVER** skip validation tests before committing
- **NEVER** commit without running `make check`

### ✅ REQUIRED WORKFLOW
1. **Always create a feature branch** before making any changes
2. **Always run validation** before committing (`make check`)
3. **Always test builds** before merging (`make test-build`)
4. **Always write meaningful commit messages**
5. **Always merge only after all tests pass**

### 📝 Branch Naming Convention
```bash
# Feature branches
feature/add-new-application
feature/fix-broken-service
feature/improve-performance

# Bugfix branches
bugfix/critical-security-issue
bugfix/input-method-crash

# Refactor branches
refactor/clean-up-configuration
refactor/update-niri-settings
```

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
Chinese input method setup using `system/chinese/input-methods.nix`:
- Framework: Fcitx5 + Rime (雾凇拼音)
- Switch: Ctrl+Space
- Layout: CN with optimizations
- Environment variables: Automatically configured for Wayland

### Desktop Environment Integration
The desktop environment integrates multiple components:
- **Niri WM**: Window management with animations and rules
- **Noctalia**: Desktop shell with QuickShell integration
- **3-Layer Chain**: `systemd → greetd → niri-session → desktop environment`
- **Service Startup**: Defined in Niri settings via `spawn-at-startup`

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

### Performance Optimizations (system/core/)
- **3-layer startup chain**: Reduced from 5 layers for faster boot
- **ZRAM compression**: 25% of RAM for memory efficiency
- **Optimized service order**: Critical services start first
- **Wayland native**: GPU acceleration throughout stack

### Chinese Localization (system/chinese/)
Complete Chinese support including:
- **Fonts**: Noto CJK, Source Han Sans, Adwaita in `fonts.nix`
- **Input methods**: Fcitx5 + Rime configuration in `input-methods.nix`
- **Mirrors**: Chinese package mirrors in `mirrors.nix`
- **Localization**: System-wide Chinese settings in `localization.nix`

## Troubleshooting Common Issues

### Build Failures
1. Run `make check` to identify syntax issues
2. Check `flake.lock` consistency and inputs
3. Verify all imports exist (flake-parts pattern)
4. Use `nix flake check --no-build` for syntax-only validation
5. Check flake-parts import paths in `flake.nix`

### Service Issues
```bash
# Check display manager (3-layer startup chain)
systemctl status greetd

# Check user session and desktop shell
systemctl --user status niri-session
systemctl --user status noctalia-shell

# View logs
journalctl -u greetd -f
journalctl --user -u niri-session -f
journalctl --user -u noctalia -f
```

### Home Manager Issues
```bash
# Check Home Manager service
systemctl --user status home-manager-sheep

# View Home Manager activation logs
journalctl -u home-manager-sheep -n 50

# Manually rebuild Home Manager config
home-manager switch --flake .#sheep@desktop
```

### Performance Issues
- Run `./scripts/testing/test-startup-performance.sh`
- Check for unnecessary services with `systemd-cgtop`
- Monitor memory usage and ZRAM compression
- Verify 3-layer startup chain is working optimally