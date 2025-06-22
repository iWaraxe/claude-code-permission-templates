# Team Setup Guide

## Repository Structure

```
your-project/
├── .claude/
│   ├── settings.json          # Current (from template)
│   ├── settings.local.json    # Personal (gitignored)
│   └── templates/             # Shared templates
│       ├── README.md
│       ├── dev.json
│       ├── qa.json
│       └── prod.json
├── .gitignore                 # Include .claude/settings.local.json
└── README.md                  # Document template usage
```

## Initial Setup

1. **Add to .gitignore**
   ```
   .claude/settings.local.json
   ```

2. **Create Team Templates**
   - Development template with team conventions
   - QA templates for different testing scenarios
   - Production templates with appropriate restrictions

3. **Document Usage**
   Add to your project README:
   ```markdown
   ## Claude Code Setup
   
   1. Copy appropriate template:
      ```bash
      cp .claude/templates/dev.json .claude/settings.json
      ```
   
   2. Create local overrides if needed:
      ```bash
      cp .claude/settings.local.json.example .claude/settings.local.json
      ```
   ```

## Role-Based Templates

### Developers
- `dev-full.json` - Senior developers
- `dev-restricted.json` - Junior developers
- `dev-frontend.json` - Frontend specialists
- `dev-backend.json` - Backend specialists

### QA Team
- `qa-manual.json` - Manual testing
- `qa-automation.json` - Test automation
- `qa-e2e.json` - End-to-end testing
- `qa-performance.json` - Performance testing

### DevOps
- `ops-deployment.json` - Deployment tasks
- `ops-monitoring.json` - System monitoring
- `ops-emergency.json` - Emergency access

## Workflow Integration

### Git Hooks
```bash
#!/bin/bash
# .git/hooks/pre-commit
# Prevent committing production templates as active

if [[ $(cat .claude/settings.json | grep '"ENVIRONMENT": "production"') ]]; then
    echo "Error: Production settings active. Switch to development before committing."
    exit 1
fi
```

### CI/CD Integration
```yaml
# .github/workflows/test.yml
- name: Switch to CI permissions
  run: cp .claude/templates/qa-ci.json .claude/settings.json

- name: Run Claude Code tests
  run: claude --headless "run all tests and generate report"
```

## Regular Reviews

Schedule monthly reviews to:
1. Update templates with new patterns
2. Remove obsolete permissions
3. Add new tool integrations
4. Adjust based on team feedback