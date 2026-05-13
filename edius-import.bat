@echo off
rem =========================================================
rem  edius-import.bat  -  Drax-TXT in Video importieren
rem  Setzt Drax (Standard-Installation) voraus.
rem
rem  Verwendung:
rem    TXT-Datei auf dieses Skript ziehen (Drag und Drop)
rem    Oder starten ohne Argument: alle TXT im Ordner werden verarbeitet
rem
rem  Das Video (MP4) muss im gleichen Ordner liegen und den
rem  gleichen Basisnamen wie die TXT-Datei enthalten.
rem  Beispiel: "Konzert-2024.txt" + "Konzert-2024-export.mp4" = Match
rem
rem  Autor: https://github.com/HunterDxD
rem =========================================================
setlocal enabledelayedexpansion

rem ----------------------------------------------------------
rem  Drax-Pfad pruefen (bei anderer Installation hier anpassen)
rem ----------------------------------------------------------
set "drax=C:\Program Files (x86)\Drax\Drax\Drax.exe"
if not exist "!drax!" set "drax=C:\Program Files\Drax\Drax\Drax.exe"
if not exist "!drax!" (
    echo [FEHLER] Drax nicht gefunden.
    echo Bitte den Pfad in Zeile 20 dieser Datei anpassen.
    echo Aktuell gesucht: !drax!
    pause
    exit /b 1
)

if not "%~1"=="" goto :argloop
set "found=0"
for %%f in ("%~dp0*.txt") do (
    set "found=1"
    call :importMarker "%%f"
)
if "!found!"=="0" echo Keine TXT-Dateien im Ordner gefunden.
goto :main_done

:argloop
if "%~1"=="" goto :main_done
call :importMarker "%~1"
shift
goto :argloop

:main_done

echo.
echo Fertig. Beliebige Taste druecken.
pause > nul
exit /b


:importMarker
set "markerFile=%~1"
set "markerDir=%~dp1"
set "baseName=%~n1"

rem Passendes MP4 im gleichen Ordner suchen
rem MP4-Dateiname muss den Basisnamen der TXT-Datei enthalten
set "videoFile="
set "videoName="
for %%v in ("!markerDir!*.mp4") do (
    echo %%~nv | findstr /i /l "!baseName!" > nul
    if !errorlevel!==0 (
        set "videoFile=%%v"
        set "videoName=%%~nxv"
    )
)

if "!videoFile!"=="" (
    echo [FEHLER] Kein passendes MP4 fuer "%~nx1" gefunden
    echo          Erwartet: MP4 im Ordner !markerDir! mit "!baseName!" im Namen
    goto :eof
)

echo Importiere: %~nx1 -^> !videoName!
"!drax!" /import:"!markerFile!" /file:"!videoFile!"
goto :eof
