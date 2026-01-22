@echo off
REM Stay Script - Windows CMD Version
REM Description: Opens a new CMD window and runs a command, keeping the window open
REM Author: snowcatman
REM Version: 1.0

setlocal enabledelayedexpansion

REM Check if no arguments provided
if "%~1"=="" (
    echo Stay - Windows CMD Version
    echo Usage: Stay.bat ^<command^>
    echo.
    echo Examples:
    echo   Stay.bat echo Hello World
    echo   Stay.bat dir
    echo   Stay.bat python script.py
    echo.
    echo This will open a new CMD window, run your command,
    echo and keep the window open for you to view the results.
    goto :eof
)

REM Check for help flags
if "%~1"=="-h" goto :show_help
if "%~1"=="--help" goto :show_help
if "%~1"=="help" goto :show_help
if "%~1"=="/?" goto :show_help
if "%~1"=="/help" goto :show_help

goto :run_command

:show_help
echo Stay - Windows CMD Version
echo Usage: Stay.bat ^<command^>
echo.
echo Examples:
echo   Stay.bat echo Hello World
echo   Stay.bat dir
echo   Stay.bat python script.py
echo.
echo This will open a new CMD window, run your command,
echo and keep the window open for you to view the results.
goto :eof

:run_command
REM Create temporary batch file
set "temp_file=%TEMP%\stay_temp_%RANDOM%.bat"

REM Build the command string
set "full_command=%*"

REM Create the temporary batch script
(
echo @echo off
echo echo Running command: %full_command%
echo echo ----------------------------------------
echo %full_command%
echo if !errorlevel! equ 0 (
echo     echo.
echo     echo ----------------------------------------
echo     echo Command completed successfully!
echo ) else (
echo     echo.
echo     echo ----------------------------------------
echo     echo Command failed with error level !errorlevel!
echo )
echo echo.
echo echo Press any key to exit...
echo pause ^> nul
) > "%temp_file%"

REM Start new CMD window with the temporary script
echo Stay: Opening new CMD window...
start "Stay Command" cmd /k "%temp_file%"

REM Clean up the temp file after a delay (to allow the new window to start)
timeout /t 2 /nobreak > nul
del "%temp_file%" 2>nul

goto :eof
