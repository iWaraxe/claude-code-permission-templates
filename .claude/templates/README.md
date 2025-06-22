# Permission Templates

This directory contains permission templates for different workflows and roles.

## Categories

### Development (`development/`)
- `dev-full.json` - Full development access
- `dev-frontend.json` - Frontend development
- `dev-backend.json` - Backend development
- `dev-restricted.json` - Junior developer restrictions

### Testing (`testing/`)
- `qa-manual.json` - Manual testing
- `qa-automation.json` - Automated testing
- `qa-e2e.json` - End-to-end testing
- `qa-performance.json` - Performance testing
- `qa-security.json` - Security testing
- `qa-ci.json` - CI/CD testing

### Production (`production/`)
- `prod-readonly.json` - Read-only access
- `prod-debug.json` - Debugging access
- `prod-hotfix.json` - Emergency fixes
- `staging.json` - Staging environment

### Specialized (`specialized/`)
- `code-review.json` - Code review only
- `documentation.json` - Documentation updates
- `data-migration.json` - Database work
- `demo.json` - Safe for demonstrations

## Usage

Switch to a template using the provided scripts:

```bash
# Unix/Linux/macOS
../scripts/unix/switch-env.sh qa-manual

# Windows
..\scripts\windows\switch-env.bat qa-manual
```

## Creating New Templates

1. Copy an existing template as a starting point
2. Modify permissions for your specific needs
3. Test thoroughly before sharing
4. Document the template's purpose
5. Add to appropriate category directory