#!/bin/bash

# Claude Code Templates Installation Script for Unix/Linux/macOS

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Installing Claude Code Permission Templates..."
echo ""

# Make scripts executable
chmod +x "$SCRIPT_DIR"/*.sh
echo "✓ Made Unix scripts executable"

# Create symlink for easy access (optional)
read -p "Create 'claude-switch' command in /usr/local/bin? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo ln -sf "$SCRIPT_DIR/switch-env.sh" /usr/local/bin/claude-switch
    echo "✓ Created 'claude-switch' command"
fi

# Copy example local settings
if [[ ! -f "$PROJECT_ROOT/.claude/settings.local.json" ]]; then
    cp "$PROJECT_ROOT/.claude/settings.local.json.example" "$PROJECT_ROOT/.claude/settings.local.json"
    echo "✓ Created local settings file"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Usage:"
echo "  $SCRIPT_DIR/switch-env.sh list"
echo "  $SCRIPT_DIR/switch-env.sh dev-full"
if command -v claude-switch >/dev/null 2>&1; then
    echo ""
    echo "Or use the global command:"
    echo "  claude-switch list"
    echo "  claude-switch dev-full"
fi