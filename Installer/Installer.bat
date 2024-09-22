@echo off
:: Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Git is not installed. Opening download page...
    start https://gitforwindows.org/
    exit /b
)

:: Git is installed, proceeding to create directories and clone the repo
echo Git is installed.

:: Define the target directory
set "target_dir=%appdata%\Roaming\.Server"

:: Create the directory structure
if not exist "%target_dir%" (
    echo Creating directory %target_dir%...
    mkdir "%target_dir%"
) else (
    echo Directory already exists: %target_dir%
)

:: Change to the .Server directory
cd /d "%target_dir%"

:: Clone the GitHub repository into the .Server folder
if not exist ".Server" (
    echo Cloning the GitHub repository...
    git clone https://github.com/Pink-WME/.Server .
) else (
    echo The repository has already been cloned.
)

:: Print "Shockwave" in cyan and "Is Installed" in green using basic color formatting
color 3F
echo Shockwave | color 2F & echo Is Installed

:: Wait for 5 seconds
timeout /t 5 >nul

:: Reset the color to default and exit the script
color 07
exit
