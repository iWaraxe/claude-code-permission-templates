#!/bin/bash

# Quick switch shortcuts for common templates
# Usage: source quick-switch.sh (or add to .bashrc/.zshrc)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create aliases for common switches
alias claude-dev="$SCRIPT_DIR/switch-env.sh dev-full"
alias claude-qa="$SCRIPT_DIR/switch-env.sh qa-manual"
alias claude-prod="$SCRIPT_DIR/switch-env.sh prod-readonly"
alias claude-debug="$SCRIPT_DIR/switch-env.sh prod-debug"
alias claude-review="$SCRIPT_DIR/switch-env.sh code-review"

# Quick status
alias claude-status="$SCRIPT_DIR/switch-env.sh current"
alias claude-templates="$SCRIPT_DIR/switch-env.sh list"

# Quick backup
claude-backup() {
    local backup_dir="$HOME/.claude-backups"
    mkdir -p "$backup_dir"
    cp "$PROJECT_ROOT/.claude/settings.json" "$backup_dir/settings.$(date +%Y%m%d_%H%M%S).json"
    echo "✓ Backed up current settings"
}

# Quick restore
claude-restore() {
    local backup_dir="$HOME/.claude-backups"
    local latest=$(ls -t "$backup_dir"/settings.*.json 2>/dev/null | head -1)
    
    if [[ -n "$latest" ]]; then
        cp "$latest" "$PROJECT_ROOT/.claude/settings.json"
        echo "✓ Restored from: $latest"
    else
        echo "✗ No backups found"
    fi
}

echo "Claude Code quick switches loaded!"
echo "Commands: claude-dev, claude-qa, claude-prod, claude-debug, claude-review"
echo "Status: claude-status, claude-templates"
echo "Backup: claude-backup, claude-restore"