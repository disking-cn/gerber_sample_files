@echo off
cd /d "%~dp0"

if not exist "..\gerbers\*.gbr" (
    echo Error: ..\gerbers has no .gbr files. Run 01_unzip-and-convert-to-dif.bat first.
    pause
    exit /b 1
)

mkdir "..\results" 2>nul

echo Converting to DIF...
gbrcli --mode batch --input-dir "..\gerbers" --output-dir "..\results"

echo Done.
pause
