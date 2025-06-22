# Claude Code Permission Switcher for Windows PowerShell
# Usage: .\switch-env.ps1 -Template <template-name>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Template,
    
    [Parameter()]
    [switch]$List,
    
    [Parameter()]
    [switch]$Current,
    
    [Parameter()]
    [switch]$Help
)

# Script configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$ClaudeDir = Join-Path $ProjectRoot ".claude"
$TemplatesDir = Join-Path $ClaudeDir "templates"
$SettingsFile = Join-Path $ClaudeDir "settings.json"

# Color functions
function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Error { Write-Host "✗ $args" -ForegroundColor Red }
function Write-Warning { Write-Host "⚠ $args" -ForegroundColor Yellow }

# Find template file
function Find-Template {
    param([string]$TemplateName)
    
    # Direct path
    $directPath = Join-Path $TemplatesDir "$TemplateName.json"
    if (Test-Path $directPath) {
        return $directPath
    }
    
    # Search in subdirectories
    foreach ($dir in @('development', 'testing', 'production', 'specialized')) {
        $templatePath = Join-Path $TemplatesDir "$dir\$TemplateName.json"
        if (Test-Path $templatePath) {
            return $templatePath
        }
    }
    
    return $null
}

# List available templates
function Show-Templates {
    Write-Host "Available templates:" -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($category in @('development', 'testing', 'production', 'specialized')) {
        $categoryPath = Join-Path $TemplatesDir $category
        if (Test-Path $categoryPath) {
            Write-Host "  $($category.ToUpper()):" -ForegroundColor Yellow
            Get-ChildItem -Path $categoryPath -Filter "*.json" | ForEach-Object {
                Write-Host "    - $($_.BaseName)"
            }
            Write-Host ""
        }
    }
}

# Show current settings
function Show-Current {
    if (-not (Test-Path $SettingsFile)) {
        Write-Error "No settings file found at: $SettingsFile"
        return
    }
    
    Write-Host "Current settings file: $SettingsFile" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        $settings = Get-Content $SettingsFile | ConvertFrom-Json
        
        Write-Host "Permissions:" -ForegroundColor Yellow
        Write-Host "  Allowed: $($settings.permissions.allow.Count) rules"
        Write-Host "  Denied: $($settings.permissions.deny.Count) rules"
        
        if ($settings.env) {
            Write-Host ""
            Write-Host "Environment variables:" -ForegroundColor Yellow
            $settings.env.PSObject.Properties | ForEach-Object {
                Write-Host "  $($_.Name) = $($_.Value)"
            }
        }
        
        if ($settings.mcpServers) {
            Write-Host ""
            Write-Host "MCP Servers:" -ForegroundColor Yellow
            $settings.mcpServers.PSObject.Properties | ForEach-Object {
                Write-Host "  $($_.Name)"
            }
        }
    }
    catch {
        Write-Warning "Could not parse JSON. Showing raw content:"
        Get-Content $SettingsFile | Select-Object -First 20
    }
}

# Switch to template
function Switch-Template {
    param([string]$TemplateName)
    
    $templatePath = Find-Template $TemplateName
    if (-not $templatePath) {
        Write-Error "Template not found: $TemplateName"
        Write-Host ""
        Show-Templates
        return
    }
    
    # Backup current settings
    if (Test-Path $SettingsFile) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupFile = "$SettingsFile.backup.$timestamp"
        Copy-Item $SettingsFile $backupFile
        Write-Success "Backed up current settings to: $(Split-Path -Leaf $backupFile)"
    }
    
    # Copy template
    try {
        Copy-Item $templatePath $SettingsFile -Force
        Write-Success "Switched to template: $TemplateName"
        Write-Host ""
        Write-Host "Template: $templatePath" -ForegroundColor Gray
        Write-Host "Target: $SettingsFile" -ForegroundColor Gray
        Write-Host ""
        Write-Warning "Remember to restart Claude Code for changes to take effect!"
    }
    catch {
        Write-Error "Failed to switch template: $_"
    }
}

# Show help
function Show-Help {
    Write-Host "Claude Code Permission Switcher" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\switch-env.ps1 [-Template] <template> | -List | -Current | -Help"
    Write-Host ""
    Write-Host "Parameters:" -ForegroundColor Yellow
    Write-Host "  -Template <name>  Switch to the specified template"
    Write-Host "  -List             List all available templates"
    Write-Host "  -Current          Show current settings"
    Write-Host "  -Help             Show this help message"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\switch-env.ps1 dev-full"
    Write-Host "  .\switch-env.ps1 -Template qa-manual"
    Write-Host "  .\switch-env.ps1 -List"
}

# Main logic
if ($Help -or (-not $Template -and -not $List -and -not $Current)) {
    Show-Help
} elseif ($List) {
    Show-Templates
} elseif ($Current) {
    Show-Current
} elseif ($Template) {
    Switch-Template $Template
}