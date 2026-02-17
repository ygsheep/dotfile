# AGENTS.md

Guidelines for agentic coding agents working in the NixOS repository.

## Project Overview
**Output Format**: Reply in Chinese (中文), end with "喵！"

## Build, Lint & Test Commands

### Essential Commands
```bash
# Run all validation (must do before commit)
make check

# Format all Nix files (alejandra)
make format
# OR: nix run nixpkgs#alejandra -- .

# Quick syntax check (no build)
nix flake check --no-build

# Enter development environment
nix develop
```

### Build & Deploy
```bash
# Quick commands (default: thinkbook)
make s                    # Apply config (switch shortcut)
make b                    # Build config (build shortcut)

# Interactive host selection
make si                   # Select host & apply
make bi                   # Select host & build

# Full commands with HOST variable
make switch HOST=desktop  # Apply desktop config
make build HOST=thinkbook # Build thinkbook config

# Alternative using nh tool
nh os switch
```

### Running Individual Checks
```bash
# File integrity and syntax
./scripts/testing/validate-config.sh

# Project structure
./scripts/testing/check-structure.sh

# Shell script quality checks
# CI script checks for: shebangs, set -euo pipefail, bash syntax
```

### Update Dependencies
```bash
make update
# OR: nix flake update
```

## Code Style Guidelines

### Nix Code Style

#### Formatting
- **Formatter**: Use `alejandra` (enforced by CI)
- **Line length**: Follow alejandra defaults
- **Indentation**: 2 spaces
- Run `make format` before committing

#### Imports & Module Structure
```nix
# Standard module header
{ config, pkgs, lib, ... }: {
  # Implementation
}

# When using globals
{ config, pkgs, lib, globals, ... }: {
  homeDirectory = globals.homeDir;
}

# Let binding for local variables
{ config, pkgs, ... }: let
  pointer = config.home.pointerCursor;
in {
  # Use 'pointer' here
}
```

#### Naming Conventions
- **Variables**: Use `camelCase` for local variables, `kebab-case` for Nix attribute names
- **Options**: `programs.programName.enable` pattern
- **Files**: Use `kebab-case.nix` for filenames
- **Globals**: Always use `globals.user`, `globals.homeDir` - **never hardcode "sheep"**

#### Comments
- Use `#` for single-line comments
- Add module purpose at top: `# path/to/module.nix - Brief description`
- Comment in Chinese for Chinese-specific features (input methods, localization)

### Global Variables (CRITICAL)

**Always use globals from `lib/globals.nix`**:
```nix
# ❌ WRONG - Hardcoded
homeDirectory = "/home/sheep";
username = "sheep";

# ✅ CORRECT - Use globals
homeDirectory = globals.homeDir;
username = globals.user;
```

### Error Handling Patterns

#### Shell Scripts
All shell scripts MUST include:
```bash
#!/bin/bash
set -euo pipefail
```

#### Nix Modules
- Use `lib.mkIf` for conditional enabling
- Provide defaults for all options
- Validate inputs with `lib.types`

### Service Management Pattern
```nix
# Niri startup services
spawn-at-startup = [
  { command = [ "fcitx5" "-d" "--replace" ]; }
  { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }
];
```

### Flake Architecture
- Uses `flake-parts` for modular structure
- No outputs in individual module files
- Imports: `./home/profiles`, `./hosts`, `./pkgs`
- System-specific configs in `hosts/`

## Git Workflow

### Required (MUST)
1. Create feature branch: `git checkout -b feature/description`
2. Run `make check` before every commit
3. Test build before merging: `make test-build`
4. Write meaningful commit messages

### Branch Naming
- `feature/add-xwayland-support`
- `bugfix/fix-fcitx5-crash`
- `refactor/clean-up-modules`

### Prohibited (NEVER)
- Direct changes to main branch
- Pushing without `make check`
- Committing secrets or API keys

## Project Structure

```
lib/              globals.nix          # Global config variables
pkgs/             Custom packages
modules/          Reusable NixOS modules
home/             Home Manager config
  ├── apps/        GUI applications
  ├── cli/         CLI tools
  ├── desktop/     Desktop environment (Niri/KDE)
  ├── editors/     Editor configs
  ├── programs/    Input method, git
  ├── services/    User services
  └── profiles/    Host-specific profiles
system/           System-level NixOS config
  ├── chinese/     Fonts, input methods
  ├── core/        Boot, security
  ├── desktop/     KDE integration
  ├── hardware/    Bluetooth, graphics
  ├── network/     Network config
  ├── nix/         Nix settings
  ├── programs/    System programs
  └── services/    System services
hosts/            Host configurations
  ├── desktop/     Niri + greetd
  └── thinkbook/   KDE + SDDM
scripts/          Utility scripts
```

## Key Files Reference

| File | Purpose |
|------|---------|
| `flake.nix` | Entry point, flake-parts config |
| `lib/globals.nix` | Global variables (user, paths) |
| `Makefile` | Build commands |
| `home/default.nix` | Home Manager entry |
| `system/default.nix` | System module lists |
| `home/desktop/wayland/niri/settings.nix` | Niri WM settings |
| `system/chinese/input-methods.nix` | Fcitx5 + Rime config |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails | Run `make check` |
| Format errors | Run `make format` |
| Syntax errors | `nix flake check --no-build` |
| Service issues | `systemctl status greetd` |
| Home Manager | `systemctl --user status home-manager-sheep` |

## Cursor/Copilot Rules

This repository does not have specific `.cursorrules` or Copilot instructions. Follow the guidelines above and refer to `CLAUDE.md` for additional context.
