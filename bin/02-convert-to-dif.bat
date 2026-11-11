@echo off
cd /d "%~dp0"

if not exist "..\..\gerbers\*.gbr" (
    echo Error: ..\..\gerbers has no .gbr files. Run 01-unzip-and-convert-to-dif.bat first.
    pause
    exit /b 1
)

mkdir "..\..\geoms\samples\m0" 2>nul

echo Converting to DIF...
gbrcli --mode batch --input-dir "..\..\gerbers" --output-dir "..\..\geoms\samples\m0"

echo Done. Outputs: ..\\..\\geoms
pause
