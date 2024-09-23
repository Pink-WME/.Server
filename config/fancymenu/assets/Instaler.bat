@echo off

@echo off
rem Check if Git is installed
where git >nul 2>&1

if %errorlevel%==0 (
git clone https://github.com/Pink-WME/.Server %appdata%/.Server

) else (
    echo Please install git to continue
    https://git-scm.com/downloads
)

pause