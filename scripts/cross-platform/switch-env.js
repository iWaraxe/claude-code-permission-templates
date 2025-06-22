#!/usr/bin/env node

/**
 * Claude Code Permission Switcher - Cross-platform Node.js version
 * Usage: node switch-env.js <template-name>
 */

const fs = require('fs');
const path = require('path');

// Configuration
const scriptDir = __dirname;
const projectRoot = path.resolve(scriptDir, '..', '..');
const claudeDir = path.join(projectRoot, '.claude');
const templatesDir = path.join(claudeDir, 'templates');
const settingsFile = path.join(claudeDir, 'settings.json');

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m'
};

// Color output functions
const success = (msg) => console.log(`${colors.green}✓ ${msg}${colors.reset}`);
const error = (msg) => console.log(`${colors.red}✗ ${msg}${colors.reset}`);
const warning = (msg) => console.log(`${colors.yellow}⚠ ${msg}${colors.reset}`);
const info = (msg) => console.log(`${colors.cyan}${msg}${colors.reset}`);

// Find template file
function findTemplate(templateName) {
  // Direct path
  const directPath = path.join(templatesDir, `${templateName}.json`);
  if (fs.existsSync(directPath)) {
    return directPath;
  }

  // Search in subdirectories
  const subdirs = ['development', 'testing', 'production', 'specialized'];
  for (const dir of subdirs) {
    const templatePath = path.join(templatesDir, dir, `${templateName}.json`);
    if (fs.existsSync(templatePath)) {
      return templatePath;
    }
  }

  return null;
}

// List available templates
function listTemplates() {
  info('Available templates:\n');

  const categories = ['development', 'testing', 'production', 'specialized'];
  
  for (const category of categories) {
    const categoryPath = path.join(templatesDir, category);
    if (fs.existsSync(categoryPath)) {
      console.log(`  ${colors.yellow}${category.toUpperCase()}:${colors.reset}`);
      
      const templates = fs.readdirSync(categoryPath)
        .filter(file => file.endsWith('.json'))
        .map(file => path.basename(file, '.json'));
      
      templates.forEach(template => {
        console.log(`    - ${template}`);
      });
      console.log();
    }
  }
}

// Show current settings
function showCurrent() {
  if (!fs.existsSync(settingsFile)) {
    error(`No settings file found at: ${settingsFile}`);
    return;
  }

  info(`Current settings file: ${settingsFile}\n`);

  try {
    const settings = JSON.parse(fs.readFileSync(settingsFile, 'utf8'));
    
    console.log(`${colors.yellow}Permissions:${colors.reset}`);
    console.log(`  Allowed: ${settings.permissions?.allow?.length || 0} rules`);
    console.log(`  Denied: ${settings.permissions?.deny?.length || 0} rules`);

    if (settings.env) {
      console.log(`\n${colors.yellow}Environment variables:${colors.reset}`);
      Object.entries(settings.env).forEach(([key, value]) => {
        console.log(`  ${key} = ${value}`);
      });
    }

    if (settings.mcpServers) {
      console.log(`\n${colors.yellow}MCP Servers:${colors.reset}`);
      Object.keys(settings.mcpServers).forEach(server => {
        console.log(`  ${server}`);
      });
    }
  } catch (err) {
    warning('Could not parse JSON. Showing raw content:');
    const content = fs.readFileSync(settingsFile, 'utf8');
    console.log(content.split('\n').slice(0, 20).join('\n'));
  }
}

// Backup current settings
function backupSettings() {
  if (fs.existsSync(settingsFile)) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, -5);
    const backupFile = `${settingsFile}.backup.${timestamp}`;
    fs.copyFileSync(settingsFile, backupFile);
    success(`Backed up current settings to: ${path.basename(backupFile)}`);
  }
}

// Switch to template
function switchTemplate(templateName) {
  const templatePath = findTemplate(templateName);
  
  if (!templatePath) {
    error(`Template not found: ${templateName}\n`);
    listTemplates();
    return;
  }

  // Backup current settings
  backupSettings();

  // Copy template
  try {
    fs.copyFileSync(templatePath, settingsFile);
    success(`Switched to template: ${templateName}\n`);
    console.log(`Template: ${templatePath}`);
    console.log(`Target: ${settingsFile}\n`);
    warning('Remember to restart Claude Code for changes to take effect!');
  } catch (err) {
    error(`Failed to switch template: ${err.message}`);
  }
}

// Show help
function showHelp() {
  info('Claude Code Permission Switcher\n');
  console.log('Usage: node switch-env.js <command> [template]\n');
  console.log('Commands:');
  console.log('  <template>      Switch to the specified template');
  console.log('  list            List all available templates');
  console.log('  current         Show current settings');
  console.log('  help            Show this help message\n');
  console.log('Examples:');
  console.log('  node switch-env.js dev-full');
  console.log('  node switch-env.js qa-manual');
  console.log('  node switch-env.js prod-readonly');
}

// Main
const args = process.argv.slice(2);
const command = args[0] || 'help';

switch (command) {
  case 'list':
    listTemplates();
    break;
  case 'current':
    showCurrent();
    break;
  case 'help':
  case '--help':
  case '-h':
    showHelp();
    break;
  default:
    switchTemplate(command);
}