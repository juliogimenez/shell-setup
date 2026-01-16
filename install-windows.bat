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

REM Get WSL user home
echo.
echo Installing in WSL...
for /f "delims=" %%u in ('wsl bash -c "echo $HOME"') do set WSL_HOME=%%u
echo WSL home directory: %WSL_HOME%

REM Create WSL directory and copy only necessary files
wsl bash -c "mkdir -p %WSL_HOME%/.shell-setup"
echo Copying files to WSL...

REM Convert Windows path to WSL path for copying
set WSL_SCRIPT_DIR=%SHELL_SETUP_DIR:\=/%
set WSL_SCRIPT_DIR=%WSL_SCRIPT_DIR: =\ %
set WSL_SCRIPT_DIR=%WSL_SCRIPT_DIR:C:=/mnt/c%

REM Copy files using wsl cp
wsl cp -f !WSL_SCRIPT_DIR!alacritty.toml %WSL_HOME%/.shell-setup/
wsl cp -f !WSL_SCRIPT_DIR!starship.toml %WSL_HOME%/.shell-setup/
wsl cp -f !WSL_SCRIPT_DIR!zellij.kdl %WSL_HOME%/.shell-setup/
wsl cp -f !WSL_SCRIPT_DIR!install-wsl.sh %WSL_HOME%/.shell-setup/

if exist "%SHELL_SETUP_DIR%layouts\" (
    wsl cp -rf !WSL_SCRIPT_DIR!layouts %WSL_HOME%/.shell-setup/
)

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
    echo Installing Alacritty Windows config...
    if exist "%APPDATA%\Alacritty\alacritty.toml" (
        echo [!] Alacritty config exists, backing up...
        set BACKUP_FILE=%APPDATA%\Alacritty\alacritty.toml.backup.%random%
        copy "%APPDATA%\Alacritty\alacritty.toml" "!BACKUP_FILE!" >nul 2>&1
        if exist "!BACKUP_FILE!" (
            echo [OK] Backup created: alacritty.toml.backup.%random%
        ) else (
            echo [!] Backup failed
        )
    )
    copy "%ALACRITTY_CONFIG%" "%APPDATA%\Alacritty\alacritty.toml" >nul 2>&1
    echo [OK] Alacritty Windows config installed
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
