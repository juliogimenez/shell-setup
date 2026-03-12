@echo off
setlocal enabledelayedexpansion
REM Windows Installation Script for Shell Setup
REM Run this script in PowerShell Administrator or Command Prompt as Admin

echo Installing Shell Setup for Windows + WSL...
echo ===============================================

REM Get script directory
set SCRIPT_DIR=%~dp0
set SHELL_SETUP_DIR=%SCRIPT_DIR%

echo Shell setup directory: %SHELL_SETUP_DIR%

REM Check if WSL is available
echo.
echo Checking WSL availability...
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] WSL is not installed or not available
    echo     Install with: wsl --install
    echo     Skipping WSL installation...
    goto SKIP_WSL
)
echo [OK] WSL is available

REM Get WSL user home and distro
echo.
echo Detecting WSL environment...
for /f "delims=" %%u in ('wsl bash -c "echo $HOME"') do set WSL_HOME=%%u
for /f "delims=" %%d in ('wsl bash -c "echo $WSL_DISTRO_NAME"') do set WSL_DISTRO=%%d
echo WSL distro: %WSL_DISTRO%
echo WSL home: %WSL_HOME%

REM Create WSL directory
wsl bash -c "mkdir -p '%WSL_HOME%/.shell-setup'"
echo Copying files to WSL...

REM Convert Windows path to WSL path safely
for /f "delims=" %%i in ('wsl wslpath "%SHELL_SETUP_DIR%"') do set WSL_SCRIPT_DIR=%%i

REM Copy files using wsl cp with quoted paths
wsl cp -f "%WSL_SCRIPT_DIR%alacritty.toml" "%WSL_HOME%/.shell-setup/"
wsl cp -f "%WSL_SCRIPT_DIR%starship.toml" "%WSL_HOME%/.shell-setup/"
wsl cp -f "%WSL_SCRIPT_DIR%zellij.kdl" "%WSL_HOME%/.shell-setup/"
wsl cp -f "%WSL_SCRIPT_DIR%install-wsl.sh" "%WSL_HOME%/.shell-setup/"

wsl bash -c "if [ -d '%WSL_SCRIPT_DIR%layouts' ]; then cp -rf '%WSL_SCRIPT_DIR%layouts' '%WSL_HOME%/.shell-setup/'; fi"

echo [OK] Configuration files copied to WSL

REM Ask for confirmation before running WSL script
echo.
echo [!] About to execute installation script in WSL
echo     This will modify: ~/.config/starship.toml, ~/.config/zellij/config.kdl, ~/.bashrc
echo.
set /p CONFIRM="Continue? (y/N): "
if /i not "%CONFIRM%"=="y" (
    echo [!] WSL installation cancelled
    goto SKIP_WSL_INSTALL
)

REM Run WSL installation script
echo.
echo Running WSL installation script...
wsl bash -c "cd %WSL_HOME%/.shell-setup && chmod +x install-wsl.sh && ./install-wsl.sh"
echo [OK] WSL installation completed

:SKIP_WSL_INSTALL

REM Create necessary directories
echo.
if not exist "%APPDATA%\Alacritty" mkdir "%APPDATA%\Alacritty"

REM Install Alacritty config
set ALACRITTY_CONFIG=%SHELL_SETUP_DIR%alacritty.toml
if exist "%ALACRITTY_CONFIG%" (
    echo Installing Alacritty Windows config for distro: %WSL_DISTRO%...
    if exist "%APPDATA%\Alacritty\alacritty.toml" (
        echo [!] Alacritty config exists, backing up...
        set BACKUP_FILE=%APPDATA%\Alacritty\alacritty.toml.backup.%random%
        copy "%APPDATA%\Alacritty\alacritty.toml" "!BACKUP_FILE!" >nul 2>&1
        if exist "!BACKUP_FILE!" (
            echo [OK] Backup created: !BACKUP_FILE!
        )
    )
    
    REM Update distro name in config and save to APPDATA
    powershell -Command "(gc '%ALACRITTY_CONFIG%') -replace '\"-d\", \"Ubuntu\"', '\"-d\", \"%WSL_DISTRO%\"' | Out-File -Encoding utf8 '%APPDATA%\Alacritty\alacritty.toml'"
    echo [OK] Alacritty Windows config installed with distro: %WSL_DISTRO%
) else (
    echo [!] alacritty.toml not found
)

echo.
REM Check if software requirements are met
set SOFTWARE_MISSING=0

where alacritty >nul 2>&1
if %errorlevel% neq 0 (
    set SOFTWARE_MISSING=1
)

REM Only show requirements if something is missing
if %SOFTWARE_MISSING% equ 1 (
    echo Software Requirements for Windows:
    echo =====================================
    echo.

    where alacritty >nul 2>&1
    if %errorlevel% neq 0 (
        echo [!] Alacritty Terminal not found
        echo     Install with: winget install Alacritty.Alacritty
        echo     OR download from: https://github.com/alacritty/alacritty/releases
        echo.
    )
)

echo.
echo Installation completed!
echo ==========================
echo.
echo [OK] Windows config installed
echo [OK] WSL config installed
echo.
echo To apply WSL changes: source ~/.bashrc
echo Restart Alacritty to apply Windows changes
echo Your environment is ready!

if %SOFTWARE_MISSING% equ 1 (
    echo.
    echo [!] Some software requirements are not met. See above.
)
echo.

pause
