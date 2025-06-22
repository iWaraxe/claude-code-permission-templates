@echo off
setlocal enabledelayedexpansion

:: Claude Code Permission Switcher for Windows CMD
:: Usage: switch-env.bat <template-name>

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%..\.."
set "CLAUDE_DIR=%PROJECT_ROOT%\.claude"
set "TEMPLATES_DIR=%CLAUDE_DIR%\templates"
set "SETTINGS_FILE=%CLAUDE_DIR%\settings.json"

:: Check if template name provided
if "%~1"=="" goto :show_help
if "%~1"=="help" goto :show_help
if "%~1"=="/?" goto :show_help
if "%~1"=="list" goto :list_templates
if "%~1"=="current" goto :show_current

:: Find and switch template
call :find_template "%~1"
if "%TEMPLATE_PATH%"=="" (
    echo [ERROR] Template not found: %~1
    echo.
    call :list_templates
    exit /b 1
)

:: Backup current settings
if exist "%SETTINGS_FILE%" (
    set "BACKUP_FILE=%SETTINGS_FILE%.backup.%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
    set "BACKUP_FILE=!BACKUP_FILE: =0!"
    copy "%SETTINGS_FILE%" "!BACKUP_FILE!" >nul
    echo [OK] Backed up current settings
)

:: Copy template to settings
copy /Y "%TEMPLATE_PATH%" "%SETTINGS_FILE%" >nul
if %errorlevel% equ 0 (
    echo [OK] Switched to template: %~1
    echo.
    echo Template: %TEMPLATE_PATH%
    echo Target: %SETTINGS_FILE%
    echo.
    echo [!] Remember to restart Claude Code for changes to take effect!
) else (
    echo [ERROR] Failed to switch template
    exit /b 1
)

goto :eof

:find_template
set "TEMPLATE_PATH="
set "TEMPLATE_NAME=%~1"

:: Check direct path
if exist "%TEMPLATES_DIR%\%TEMPLATE_NAME%.json" (
    set "TEMPLATE_PATH=%TEMPLATES_DIR%\%TEMPLATE_NAME%.json"
    goto :eof
)

:: Check in subdirectories
for %%d in (development testing production specialized) do (
    if exist "%TEMPLATES_DIR%\%%d\%TEMPLATE_NAME%.json" (
        set "TEMPLATE_PATH=%TEMPLATES_DIR%\%%d\%TEMPLATE_NAME%.json"
        goto :eof
    )
)
goto :eof

:list_templates
echo Available templates:
echo.
for %%d in (development testing production specialized) do (
    if exist "%TEMPLATES_DIR%\%%d" (
        echo   %%d:
        for %%f in ("%TEMPLATES_DIR%\%%d\*.json") do (
            echo     - %%~nf
        )
        echo.
    )
)
goto :eof

:show_current
if not exist "%SETTINGS_FILE%" (
    echo [ERROR] No settings file found at: %SETTINGS_FILE%
    exit /b 1
)
echo Current settings file: %SETTINGS_FILE%
echo.
type "%SETTINGS_FILE%" | more
goto :eof

:show_help
echo Claude Code Permission Switcher
echo.
echo Usage: %~nx0 ^<template^> ^| list ^| current ^| help
echo.
echo Commands:
echo   ^<template^>    Switch to the specified template
echo   list          List all available templates  
echo   current       Show current settings
echo   help          Show this help message
echo.
echo Examples:
echo   %~nx0 dev-full        - Switch to full development template
echo   %~nx0 qa-manual       - Switch to manual QA testing template
echo   %~nx0 prod-readonly   - Switch to production read-only template
goto :eof