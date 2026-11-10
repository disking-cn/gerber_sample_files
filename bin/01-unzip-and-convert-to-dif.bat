@echo off
cd /d "%~dp0"

if not exist "..\files\*.zip" (
    echo Error: ..\files has no zip files.
    echo Download from: https://github.com/disking-cn/gerber_sample_files.git
    pause
    exit /b 1
)

mkdir "..\gerbers" 2>nul
mkdir "..\results" 2>nul

echo Extracting zip files...
for %%f in ("..\files\*.zip") do (
    echo   %%~nxf
    7z x "%%f" -o"..\gerbers\" -aos -y >nul
)

echo Converting to DIF...
gbrcli --mode batch --input-dir "..\gerbers" --output-dir "..\results"

echo Done.
pause
