# Windows User Guide

## Prerequisites

### Required
- Windows 10 or later
- Claude Code installed
- Command Prompt or PowerShell

### Recommended
- Git for Windows (includes Git Bash)
- Visual Studio Code or preferred JSON editor
- Node.js (for cross-platform script)

## Installation

### Using Command Prompt
```cmd
cd claude-code-templates
scripts\windows\install.bat
```

### Using PowerShell
```powershell
cd claude-code-templates
.\scripts\windows\install.ps1
```

### Using Git Bash
```bash
cd claude-code-templates
./scripts/unix/install.sh
```

## File Paths

### Windows vs Unix Paths
Windows uses backslashes, but forward slashes work in JSON:

```json
// Both work in settings.json:
"Edit(src\\**\\*.js)"    // Windows style
"Edit(src/**/*.js)"      // Unix style (recommended)
```

### Home Directory
- Unix: `~/.claude/settings.json`
- Windows: `%USERPROFILE%\.claude\settings.json`
- Typically: `C:\Users\YourName\.claude\settings.json`

## Command Equivalents

| Unix Command | Windows CMD | PowerShell | Purpose |
|--------------|-------------|------------|---------|
| ls | dir | Get-ChildItem | List files |
| cat | type | Get-Content | Show file |
| grep | findstr | Select-String | Search text |
| tail -f | - | Get-Content -Wait | Follow logs |
| rm | del | Remove-Item | Delete files |
| cp | copy | Copy-Item | Copy files |
| mv | move | Move-Item | Move files |
| pwd | cd | Get-Location | Current dir |
| which | where | Get-Command | Find program |

## Script Usage

### Command Prompt
```cmd
:: List templates
scripts\windows\switch-env.bat list

:: Switch template
scripts\windows\switch-env.bat dev-full

:: Show current
scripts\windows\switch-env.bat current
```

### PowerShell
```powershell
# First time - allow scripts
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

# List templates
.\scripts\windows\switch-env.ps1 -List

# Switch template
.\scripts\windows\switch-env.ps1 dev-full

# Show current
.\scripts\windows\switch-env.ps1 -Current
```

### Git Bash (Recommended)
```bash
# Works like Unix/Linux
./scripts/unix/switch-env.sh list
./scripts/unix/switch-env.sh dev-full
```

## Windows-Specific Permissions

### File System Differences
```json
{
  "permissions": {
    "deny": [
      "Edit(C:\\Windows\\**)",     // System files
      "Edit(C:\\Program Files\\**)", // Program files
      "Bash(format *)",            // Format drives
      "Bash(del /f /s /q C:\\*)"  // Recursive delete
    ]
  }
}
```

### Windows Commands
```json
{
  "permissions": {
    "allow": [
      "Bash(dir *)",              // List directory
      "Bash(type *)",             // Show file
      "Bash(findstr *)",          // Search files
      "Bash(where *)",            // Find programs
      "Bash(ipconfig *)",         // Network info
      "Bash(systeminfo)",         // System info
      "Bash(tasklist)",           // List processes
      "Bash(netstat *)"           // Network stats
    ]
  }
}
```

### PowerShell Commands
```json
{
  "permissions": {
    "allow": [
      "Bash(Get-ChildItem *)",
      "Bash(Get-Content *)",
      "Bash(Select-String *)",
      "Bash(Get-Process)",
      "Bash(Get-Service)",
      "Bash(Test-Path *)"
    ]
  }
}
```

## Cross-Platform Development

### Best Practices
1. Use forward slashes in JSON paths
2. Prefer npm scripts over OS commands
3. Use Node.js tools when possible
4. Test on both platforms

### Universal Commands
These work on all platforms:
```json
{
  "permissions": {
    "allow": [
      "Bash(npm *)",
      "Bash(node *)",
      "Bash(git *)",
      "Bash(docker *)",
      "Bash(python *)"
    ]
  }
}
```

## Git Bash Setup

### Why Git Bash?
- Provides Unix commands on Windows
- Consistent with macOS/Linux
- Included with Git for Windows
- No additional setup required

### Using Git Bash
1. Right-click in project folder
2. Select "Git Bash Here"
3. Use Unix commands and scripts

### Configure as Default
1. In VS Code: Set default terminal to Git Bash
2. In Windows Terminal: Add Git Bash profile
3. In Claude Code: Works automatically

## Troubleshooting

### Script Errors
- **"not recognized"**: Use full path or add to PATH
- **"cannot be loaded"**: PowerShell execution policy
- **"Access denied"**: Run as administrator (if needed)

### Path Issues
- Use forward slashes in JSON
- Quote paths with spaces: `"Edit(\"Program Files/**\")"`
- Escape backslashes: `"C:\\\\Users\\\\Name"`

### Command Not Found
1. Check if command exists: `where command`
2. Install missing tools:
   - Git Bash for Unix commands
   - Node.js for JavaScript tools
   - Python for Python scripts

## Tips for Windows Users

1. **Use Git Bash** for consistency with Unix examples
2. **Create aliases** for common commands
3. **Use npm scripts** instead of shell scripts
4. **Test permissions** with both CMD and PowerShell
5. **Document** Windows-specific setup for team