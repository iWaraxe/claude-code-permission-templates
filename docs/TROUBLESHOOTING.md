# Troubleshooting Guide

## Common Issues

### Permission Denied Errors

#### Issue: "Claude wants to run: npm install"
**Cause**: Operation not in allow list
**Solution**: 
1. Add to template: `"Bash(npm install *)"`
2. Or allow temporarily when prompted

#### Issue: Can't edit files despite allow rule
**Cause**: Deny rule taking precedence
**Solution**: 
1. Check all levels for deny rules: `grep -r "deny" .claude/`
2. Remove conflicting deny rule

#### Issue: Pattern not matching files
**Cause**: Incorrect glob syntax
**Solutions**:
- Use `**` for recursive: `Edit(src/**/*.js)`
- Not `*` alone: `Edit(src/*.js)` only matches direct children
- Check case sensitivity on Unix systems

### Platform-Specific Issues

#### Windows: "Command not found"
**Cause**: Unix command on Windows CMD
**Solutions**:
1. Use Git Bash instead of CMD
2. Use Windows equivalent commands
3. Install WSL for full Unix compatibility

#### Windows: Scripts not running
**Cause**: Execution permissions
**Solutions**:
1. PowerShell: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`
2. Use `.bat` files instead of `.ps1`
3. Run scripts with full path

#### macOS: "Operation not permitted"
**Cause**: macOS security restrictions
**Solution**: Grant terminal full disk access in System Preferences > Security & Privacy

### Configuration Issues

#### Settings not taking effect
**Cause**: Claude Code only loads at startup
**Solution**: Exit and restart Claude Code after changing settings

#### Can't find template
**Cause**: Incorrect path or name
**Solution**: 
1. Use `list` command to see available templates
2. Check file exists: `ls .claude/templates/`

#### JSON parsing errors
**Cause**: Invalid JSON syntax
**Solution**:
1. Validate JSON: `jq . .claude/settings.json`
2. Common issues:
   - Missing commas between items
   - Trailing commas (not allowed)
   - Unescaped quotes in strings

### Performance Issues

#### Slow permission checks
**Cause**: Too many wildcard patterns
**Solution**: Use specific patterns where possible
```json
// Slow
"Edit(**/*)"

// Better
"Edit(src/**/*.js)"
```

#### High token usage
**Cause**: Large context from complex permissions
**Solution**: Simplify permissions, remove redundant rules

## Debug Commands

### Check current permissions
```bash
# View current settings
cat .claude/settings.json | jq .

# Check specific permission
cat .claude/settings.json | jq '.permissions.allow[] | select(contains("npm"))'

# Find deny rules
cat .claude/settings.json | jq '.permissions.deny'
```

### Test permission patterns
```bash
# Test if a file matches pattern (using find)
find . -path "./src/**/*.js" -print

# Count files matching pattern
find . -path "./src/**/*.js" | wc -l
```

### Audit permission usage
```bash
# Check Claude's working directory
pwd

# List recently modified files
find . -type f -mtime -1

# Check git status for changes
git status
```

## Getting Help

1. Check documentation in `docs/`
2. Review examples in `examples/`
3. Run script with help flag: `switch-env.sh help`
4. Validate JSON syntax
5. Check Claude Code logs if available

## Reporting Issues

When reporting issues, include:
1. Operating system and version
2. Claude Code version
3. Current settings.json (sanitized)
4. Exact error message
5. Steps to reproduce