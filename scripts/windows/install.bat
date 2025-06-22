@echo off

echo Installing Claude Code Permission Templates...
echo.

:: Copy example local settings
if not exist "%~dp0..\..\\.claude\settings.local.json" (
    copy "%~dp0..\..\\.claude\settings.local.json.example" "%~dp0..\..\\.claude\settings.local.json" >nul
    echo [OK] Created local settings file
)

:: Add to PATH (optional)
echo.
set /p ADD_PATH="Add scripts directory to PATH for easy access? (y/n): "
if /i "%ADD_PATH%"=="y" (
    setx PATH "%PATH%;%~dp0" >nul
    echo [OK] Added to PATH. Restart your terminal to use 'switch-env' command globally.
)

echo.
echo Installation complete!
echo.
echo Usage:
echo   %~dp0switch-env.bat list
echo   %~dp0switch-env.bat dev-full
pause