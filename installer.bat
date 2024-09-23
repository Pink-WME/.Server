@echo off
setlocal

:: Check for administrator rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Restarting with elevated privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Define variables
set "JAVA_INSTALLER=OpenJDK11U-jdk_x64_windows_hotspot_11.0.16.9_1.msi"
set "FABRIC_URL=https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar"
set "FABRIC_OUTPUT=fabric-installer-1.0.1.jar"

:: Check if Java is installed
echo Checking if Java is installed...
java -version > nul 2>&1
if %errorlevel% neq 0 (
    echo Java is not installed. Installing OpenJDK...
    
    :: Download OpenJDK installer
    echo Downloading OpenJDK installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.16+9/OpenJDK11U-jdk_x64_windows_hotspot_11.0.16.9_1.msi' -OutFile '%JAVA_INSTALLER%'"
    
    echo Java Installer Download Error Level: %errorlevel%
    if %errorlevel% neq 0 (
        echo Failed to download OpenJDK installer. Exiting...
        pause
        exit /b 1
    )

    :: Install Java
    echo Installing OpenJDK...
    start /wait msiexec /i "%JAVA_INSTALLER%" /quiet /norestart
    
    echo Java Installation Error Level: %errorlevel%
    if %errorlevel% neq 0 (
        echo Failed to install OpenJDK. Exiting...
        pause
        exit /b 1
    )
    echo Java installation complete.
) else (
    echo Java is already installed.
)

:: Pause for a moment to ensure installation is complete
timeout /t 5

:: Download the Fabric installer
echo Downloading Fabric Installer...
powershell -Command "Invoke-WebRequest -Uri '%FABRIC_URL%' -OutFile '%FABRIC_OUTPUT%'"
echo Fabric Installer Download Error Level: %errorlevel%
if %errorlevel% neq 0 (
    echo Failed to download Fabric installer. Exiting...
    pause
    exit /b 1
)

:: Navigate to the Downloads folder
cd "%USERPROFILE%\Downloads"
echo Navigating to Downloads directory... Error Level: %errorlevel%
if %errorlevel% neq 0 (
    echo Failed to navigate to Downloads directory. Exiting...
    pause
    exit /b 1
)

:: Start the Fabric Installer GUI and wait for it to finish
echo Running Fabric Installer...
java -jar "%FABRIC_OUTPUT%" client -mcversion 1.20.1 -loader 0.16.5

:: Check the error level after running the installer
if %errorlevel% neq 0 (
    echo Fabric Installer Run Error Level: %errorlevel%
    echo Failed to run Fabric installer. Exiting...
    pause
    exit /b 1
) else (
    echo Fabric Installer completed successfully.
)

:: Check if Git is installed
echo Checking if Git is installed...
where git >nul 2>&1
echo Git Check Error Level: %errorlevel%
if %errorlevel%==0 (
    echo Git is installed.
    rem Check if the directory exists
    if exist "%appdata%\.Server" (
        echo Deleting existing .Server directory...
        rmdir /S /Q "%appdata%\.Server"
        echo .Server directory deleted.
    )
    
    echo Cloning the repository...
    git clone https://github.com/Pink-WME/.Server "%appdata%\.Server"
    
    echo Git Clone Error Level: %errorlevel%
    if %errorlevel% neq 0 (
        echo Failed to clone the repository. Exiting...
        pause
        exit /b 1
    ) else (
        echo Repository cloned successfully.
    )
) else (
    echo Git is not installed. Please install Git to continue.
    start https://git-scm.com/downloads
)

echo Script completed successfully.
pause
endlocal
