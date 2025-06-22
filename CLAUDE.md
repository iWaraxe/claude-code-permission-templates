# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a permission template management system for Claude Code. It provides pre-configured permission sets that can be quickly switched between based on the current work context (development, testing, production, etc.).

## Core Architecture

### Permission Hierarchy
The system uses a three-level permission hierarchy where **deny always wins**:
1. Global user settings (`~/.claude/settings.json`)
2. Project settings (`.claude/settings.json`) 
3. Local project settings (`.claude/settings.local.json`)

### Template Organization
Templates are organized in `.claude/templates/` by category:
- `development/`: Full access, frontend, backend, restricted
- `testing/`: Manual QA, automation, e2e, performance, security, CI
- `production/`: Read-only, debug, hotfix, staging
- `specialized/`: Code review, documentation, data migration, demo

## Essential Commands

### Switching Templates
```bash
# Unix/Linux/macOS
./scripts/unix/switch-env.sh dev-full
./scripts/unix/switch-env.sh list
./scripts/unix/switch-env.sh current

# Windows CMD
scripts\windows\switch-env.bat dev-full

# Windows PowerShell
.\scripts\windows\switch-env.ps1 -Template dev-full

# Cross-platform Node.js
node scripts/cross-platform/switch-env.js dev-full
```

### Quick Access (after sourcing quick-switch.sh)
```bash
claude-dev      # Switch to dev-full
claude-qa       # Switch to qa-manual
claude-prod     # Switch to prod-readonly
claude-backup   # Backup current settings
claude-restore  # Restore latest backup
```

## Template Selection Guide

When working in this codebase, use these templates:

- **Development Work**: Use `dev-full` for general development
- **Documentation Updates**: Use `documentation` template
- **Code Reviews**: Use `code-review` template
- **Testing Scripts**: Use appropriate `qa-*` template
- **Demo/Presentation**: Use `demo` template for safe mode

## Permission Syntax

Permissions use the format `Tool(specifier)`:
- `Edit(src/**/*.js)` - Edit JavaScript files in src
- `Bash(npm *)` - Run any npm command
- `Read(**)` - Read all files
- Pattern matching supports exact match, prefix (`*`), and glob (`**`)

## Key Considerations

1. **Template Modifications**: When editing templates, test the JSON validity first
2. **Cross-Platform Paths**: Always use forward slashes in JSON paths (works on Windows too)
3. **Backup Management**: Scripts auto-backup settings; find backups with `.backup.` timestamp suffix
4. **Windows Users**: Prefer Git Bash for consistency, or use PowerShell with appropriate execution policy

## Testing Changes

After modifying templates:
```bash
# Validate JSON syntax
python -m json.tool .claude/templates/category/template.json

# Test switching
./scripts/unix/switch-env.sh your-template

# Verify current settings
cat .claude/settings.json | jq .permissions
```

## Common Development Tasks

- To add a new template: Create JSON file in appropriate category under `.claude/templates/`
- To modify permissions: Edit the template file and test switching
- To share with team: Commit template to repository (never commit `.claude/settings.local.json`)

## Architecture Notes

The switching scripts follow a consistent pattern:
1. Find template file (searches subdirectories)
2. Backup current settings
3. Copy template to `.claude/settings.json`
4. Display summary (if `jq` available)
5. Remind user to restart Claude Code

The permission system evaluates in order, with denies taking precedence at all levels.