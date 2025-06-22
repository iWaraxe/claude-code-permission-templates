#!/bin/bash

# Claude Code Permission Switcher for Unix/Linux/macOS
# Usage: ./switch-env.sh <template-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLAUDE_DIR="$PROJECT_ROOT/.claude"
TEMPLATES_DIR="$CLAUDE_DIR/templates"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }

# Function to find template file
find_template() {
    local template_name="$1"
    
    # Direct path if ends with .json
    if [[ "$template_name" == *.json ]]; then
        if [[ -f "$TEMPLATES_DIR/$template_name" ]]; then
            echo "$TEMPLATES_DIR/$template_name"
            return 0
        fi
    fi
    
    # Search in subdirectories
    for dir in development testing production specialized; do
        local template_path="$TEMPLATES_DIR/$dir/${template_name}.json"
        if [[ -f "$template_path" ]]; then
            echo "$template_path"
            return 0
        fi
    done
    
    # Search in root templates directory
    if [[ -f "$TEMPLATES_DIR/${template_name}.json" ]]; then
        echo "$TEMPLATES_DIR/${template_name}.json"
        return 0
    fi
    
    return 1
}

# Function to list available templates
list_templates() {
    echo "Available templates:"
    echo ""
    
    for category in development testing production specialized; do
        if [[ -d "$TEMPLATES_DIR/$category" ]]; then
            echo "  ${category^}:"
            for template in "$TEMPLATES_DIR/$category"/*.json; do
                if [[ -f "$template" ]]; then
                    basename="${template##*/}"
                    name="${basename%.json}"
                    echo "    - $name"
                fi
            done
            echo ""
        fi
    done
}

# Function to backup current settings
backup_settings() {
    if [[ -f "$SETTINGS_FILE" ]]; then
        local backup_file="$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$SETTINGS_FILE" "$backup_file"
        print_success "Backed up current settings to: $(basename "$backup_file")"
    fi
}

# Function to switch template
switch_template() {
    local template_name="$1"
    local template_path=$(find_template "$template_name")
    
    if [[ -z "$template_path" ]]; then
        print_error "Template not found: $template_name"
        echo ""
        list_templates
        return 1
    fi
    
    # Create backup of current settings
    backup_settings
    
    # Copy template to settings
    cp "$template_path" "$SETTINGS_FILE"
    
    if [[ $? -eq 0 ]]; then
        print_success "Switched to template: $template_name"
        echo ""
        echo "Template details:"
        echo "  Source: $template_path"
        echo "  Target: $SETTINGS_FILE"
        
        # Show brief summary of permissions
        echo ""
        echo "Permission summary:"
        if command -v jq >/dev/null 2>&1; then
            echo "  Allowed tools: $(jq -r '.permissions.allow | length' "$SETTINGS_FILE") rules"
            echo "  Denied tools: $(jq -r '.permissions.deny | length' "$SETTINGS_FILE") rules"
            
            # Show environment if exists
            if jq -e '.env' "$SETTINGS_FILE" >/dev/null 2>&1; then
                echo "  Environment: $(jq -r '.env | to_entries | map("\(.key)=\(.value)") | join(", ")' "$SETTINGS_FILE")"
            fi
        fi
        
        echo ""
        print_warning "Remember to restart Claude Code for changes to take effect!"
    else
        print_error "Failed to switch template"
        return 1
    fi
}

# Function to show current settings
show_current() {
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        print_error "No settings file found at: $SETTINGS_FILE"
        return 1
    fi
    
    echo "Current settings file: $SETTINGS_FILE"
    echo ""
    
    if command -v jq >/dev/null 2>&1; then
        echo "Permissions:"
        echo "  Allowed: $(jq -r '.permissions.allow | length' "$SETTINGS_FILE") rules"
        echo "  Denied: $(jq -r '.permissions.deny | length' "$SETTINGS_FILE") rules"
        
        if jq -e '.env' "$SETTINGS_FILE" >/dev/null 2>&1; then
            echo ""
            echo "Environment variables:"
            jq -r '.env | to_entries[] | "  \(.key) = \(.value)"' "$SETTINGS_FILE"
        fi
        
        if jq -e '.mcpServers' "$SETTINGS_FILE" >/dev/null 2>&1; then
            echo ""
            echo "MCP Servers:"
            jq -r '.mcpServers | to_entries[] | "  \(.key)"' "$SETTINGS_FILE"
        fi
    else
        print_warning "Install 'jq' for detailed settings view"
        head -20 "$SETTINGS_FILE"
    fi
}

# Main script logic
main() {
    case "${1:-}" in
        "list"|"-l"|"--list")
            list_templates
            ;;
        "current"|"-c"|"--current")
            show_current
            ;;
        "help"|"-h"|"--help"|"")
            echo "Claude Code Permission Switcher"
            echo ""
            echo "Usage: $0 <command> [template]"
            echo ""
            echo "Commands:"
            echo "  <template>      Switch to the specified template"
            echo "  list, -l        List all available templates"
            echo "  current, -c     Show current settings"
            echo "  help, -h        Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 dev-full                 # Switch to full development template"
            echo "  $0 qa-manual                # Switch to manual QA testing template"
            echo "  $0 prod-readonly            # Switch to production read-only template"
            echo "  $0 development/dev-full     # Use full path for template"
            ;;
        *)
            switch_template "$1"
            ;;
    esac
}

# Run main function
main "$@"