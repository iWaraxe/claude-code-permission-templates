# Claude Code Permission Templates

A comprehensive collection of permission templates for Claude Code, supporting developers, QA engineers, and DevOps teams across all platforms.

## Quick Start

1. Clone this repository
2. Run the installation script for your platform:
   - Unix/Linux/macOS: `./scripts/unix/install.sh`
   - Windows CMD: `scripts\windows\install.bat`
   - Windows PowerShell: `.\scripts\windows\install.ps1`

3. Switch to a template:
   ```bash
   # Unix/Linux/macOS
   ./scripts/unix/switch-env.sh dev-full

   # Windows
   scripts\windows\switch-env.bat dev-full
   ```

## Available Templates

### Development
- `dev-full` - Full development access
- `dev-frontend` - Frontend development only
- `dev-backend` - Backend development only
- `dev-restricted` - Junior developer restrictions

### Testing/QA
- `qa-manual` - Manual testing
- `qa-automation` - Automated testing
- `qa-e2e` - End-to-end testing
- `qa-performance` - Performance testing

### Production
- `prod-readonly` - Read-only production access
- `prod-debug` - Production debugging
- `prod-hotfix` - Emergency fixes
- `staging` - Staging environment

## Documentation

- [Permission System Guide](docs/PERMISSIONS.md)
- [Team Setup Guide](docs/TEAM-SETUP.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Windows Guide](docs/WINDOWS-GUIDE.md)