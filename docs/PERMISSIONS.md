# Claude Code Permission System Guide

## Understanding Permissions

Claude Code uses a hierarchical permission system with three configuration levels:

1. **Global User Settings** (`~/.claude/settings.json` or `%USERPROFILE%\.claude\settings.json`)
   - Applied across all projects
   - Personal development preferences
   - Minimal security restrictions

2. **Project Settings** (`.claude/settings.json`)
   - Team-shared configuration
   - Project-specific rules
   - Version controlled

3. **Local Project Settings** (`.claude/settings.local.json`)
   - Personal overrides
   - Git-ignored
   - API keys and secrets

## Permission Rules

### The Golden Rule: Deny Always Wins

If an operation is denied at ANY level, it cannot be allowed at another level.

```
Global deny + Project allow = DENIED ❌
Global allow + Project deny = DENIED ❌
No deny + Allow at any level = ALLOWED ✅
No deny + No allow = PROMPT USER ❓
```

### Permission Syntax

Permissions use the format: `Tool(specifier)`

Available tools:
- `Bash` - Command execution
- `Edit` - File modification
- `Read` - File reading
- `Write` - File writing
- `Create` - File creation
- `WebFetch` - Web requests
- `Grep` - Pattern searching
- `Glob` - File pattern matching

### Pattern Matching

- Exact match: `Bash(npm test)`
- Prefix match: `Bash(npm run *)`
- Glob patterns: `Edit(src/**/*.js)`
- Multiple extensions: `Edit(src/**/*.{js,ts})`

## Best Practices

1. **Minimal Global Restrictions**
   - Only deny universally dangerous operations
   - Examples: fork bombs, system deletion

2. **Project-Specific Controls**
   - Team conventions and standards
   - Shared development rules

3. **Local Overrides**
   - Personal API keys
   - Individual preferences
   - Never commit to version control

4. **Use Templates**
   - Consistent configurations
   - Easy environment switching
   - Reduced human error

## Security Considerations

### Never Deny Globally Unless Necessary

Once denied globally, an operation cannot be re-enabled for specific projects.

Bad example:
```json
{
  "permissions": {
    "deny": ["Bash(docker*)"]  // Can never use Docker!
  }
}
```

Good example:
```json
{
  "permissions": {
    "deny": ["Bash(:(){ :|:& };:)"]  // Only the fork bomb
  }
}
```

### Protect Sensitive Files

Always deny access to:
- SSH keys: `Edit(~/.ssh/id_rsa*)`
- Production secrets: `Edit(.env.production)`
- System files: `Edit(/etc/*)`

### Platform Considerations

Windows users should note:
- Paths can use forward slashes in JSON
- File patterns are case-insensitive
- Some Unix commands need Git Bash or WSL