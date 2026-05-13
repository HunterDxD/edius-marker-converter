@echo off
rem =========================================================
rem  edius-convert.bat  -  EDIUS Markerliste -> Drax-Format
rem  Unterstuetzt: Format Version 2 und 3 (CSV)
rem
rem  Verwendung:
rem    CSV-Datei auf dieses Skript ziehen (Drag und Drop)
rem    Oder starten ohne Argument: alle CSV im Ordner werden verarbeitet
rem
rem  Autor: https://github.com/HunterDxD
rem =========================================================
setlocal enabledelayedexpansion

if not "%~1"=="" goto :argloop
set "found=0"
for %%f in ("%~dp0*.csv") do (
    set "found=1"
    call :convert "%%f"
)
if "!found!"=="0" echo Keine CSV-Dateien im Ordner gefunden.
goto :main_done

:argloop
if "%~1"=="" goto :main_done
call :convert "%~1"
shift
goto :argloop

:main_done

echo.
echo Fertig. Beliebige Taste druecken.
pause > nul
exit /b


:convert
if /i "%~x1"==".xml" (
    echo [FEHLER] %~nx1: XML-Format -Version 4- wird nicht unterstuetzt
    goto :eof
)
if /i not "%~x1"==".csv" (
    echo [FEHLER] %~nx1: Keine CSV-Datei
    goto :eof
)
if not exist "%~1" (
    echo [FEHLER] Datei nicht gefunden: %~1
    goto :eof
)

rem Format-Version aus Zeile 2 des Headers lesen
set "formatVersion=0"
set "lineNum=0"
for /f "usebackq tokens=*" %%l in ("%~1") do (
    set /a lineNum+=1
    if !lineNum!==2 (
        set "vline=%%l"
        set "formatVersion=!vline:~17,1!"
    )
)

if "!formatVersion!"=="4" (
    echo [FEHLER] %~nx1: Format Version 4 -XML- wird nicht unterstuetzt
    goto :eof
)
if not "!formatVersion!"=="2" if not "!formatVersion!"=="3" (
    echo [FEHLER] %~nx1: Unbekannte Format-Version ^(!formatVersion!^)
    goto :eof
)

echo Verarbeite: %~nx1  (Format Version !formatVersion!)

set "outputFile=%~dpn1.txt"
set "tempFile=%~dpn1.tmp"
set "af=""

if exist "!tempFile!" del "!tempFile!"

for /f "usebackq tokens=*" %%l in ("%~1") do (
    set "line=%%l"

    rem Kommentarzeilen ueberspringen
    if not "!line:~0,1!"=="#" (

        rem Nur Datenzeilen verarbeiten - enden mit Anfuehrungszeichen
        if "!line:~-1!"=="!af!" (

            rem Laufende Nummer und fuehrendes Anfuehrungszeichen entfernen
            set "line=!line:*"=!"

            rem Bei Var3: Anchor-Feld ON/OFF entfernen
            rem Var3 nach Sub 1: ON","00:00:00:000", ,"X"
            rem Sub 2 -> ,"00:00:00:000", ,"X"
            rem Sub 3 -> 00:00:00:000", ,"X"  - gleiche Struktur wie Var2
            if "!formatVersion!"=="3" (
                set "line=!line:*"=!"
                set "line=!line:*"=!"
            )

            rem Position HH:MM:SS:mmm = erste 12 Zeichen
            set "firstPart=!line:~0,12!"

            rem Kommentar = ab Zeichen 17
            set "secondPart=!line:~17!"

            rem Zusammensetzen und abschliessendes Anfuehrungszeichen entfernen
            set "line=!firstPart! !secondPart!"
            set "line=!line:~0,-1!"

            echo !line!>>"!tempFile!"
        )
    )
)

if exist "!tempFile!" (
    move /y "!tempFile!" "!outputFile!" > nul
    echo    OK: %~n1.txt erstellt
) else (
    echo [WARNUNG] Keine Daten gefunden in: %~nx1
)
goto :eof
