# Permission Switching Scripts

This directory contains scripts for switching between Claude Code permission templates across different platforms.

## Available Scripts

### Unix/Linux/macOS (`unix/`)
- `switch-env.sh` - Main switching script
- `quick-switch.sh` - Aliases for common templates
- `install.sh` - Setup script

### Windows (`windows/`)
- `switch-env.bat` - CMD batch script
- `switch-env.ps1` - PowerShell script
- `install.bat` - Windows setup

### Cross-platform (`cross-platform/`)
- `switch-env.js` - Node.js switcher (works on all platforms)

## Quick Start

### Unix/Linux/macOS
```bash
# Run installation
./scripts/unix/install.sh

# Switch templates
./scripts/unix/switch-env.sh dev-full
./scripts/unix/switch-env.sh list

# Use quick aliases (after sourcing)
source scripts/unix/quick-switch.sh
claude-dev          # Switch to dev-full
claude-qa           # Switch to qa-manual
claude-prod         # Switch to prod-readonly
```

### Windows Command Prompt
```cmd
:: Run installation
scripts\windows\install.bat

:: Switch templates
scripts\windows\switch-env.bat dev-full
scripts\windows\switch-env.bat list
```

### Windows PowerShell
```powershell
# Switch templates
.\scripts\windows\switch-env.ps1 -Template dev-full
.\scripts\windows\switch-env.ps1 -List
```

### Node.js (All Platforms)
```bash
# Switch templates
node scripts/cross-platform/switch-env.js dev-full
node scripts/cross-platform/switch-env.js list
```

## Available Commands

All scripts support these commands:
- `<template-name>` - Switch to specific template
- `list` - Show all available templates
- `current` - Display current settings
- `help` - Show usage information

## Template Categories

- **Development**: `dev-full`, `dev-frontend`, `dev-backend`, `dev-restricted`
- **Testing**: `qa-manual`, `qa-automation`, `qa-e2e`, `qa-performance`, `qa-security`, `qa-ci`
- **Production**: `prod-readonly`, `prod-debug`, `prod-hotfix`, `staging`
- **Specialized**: `code-review`, `documentation`, `data-migration`, `demo`