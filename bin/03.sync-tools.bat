@echo off
setlocal

cd /d "%~dp0"

:: --- Required binaries ---
set "dRedCliSrc=D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe"
set "dGbrCliSrc=D:\Projects\ezdi\parsers\parser-gbr\build\out\bin\x64\Release\gbrcli.exe"
set "dRedttSrc=D:\Projects\ezdi\build\bin\x64\Release\redtt.exe"

:: --- Optional files ---
set "dRedCliJs=D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.json"
set "dGbrCliJs=D:\Projects\ezdi\parsers\parser-gbr\build\out\bin\x64\Release\gbrcli.json"
set "dRedttJs=D:\Projects\ezdi\build\bin\x64\Release\redtt.json"

set "dRedCliMd=D:\Projects\ezdi\papers\encoder-rle4k-cpu\docs\redcli.help.md"
set "dGbrCliMd=D:\Projects\ezdi\parsers\parser-gbr\gbrcli\gbrcli.help.md"
set "dRedttMd=D:\Projects\ezdi\encoders\encoder-redtt\docs\helps\en.md"

:: --- Check required binaries (.exe only) ---
set "err=0"

for %%F in ("%dRedCliSrc%" "%dGbrCliSrc%" "%dRedttSrc%") do (
    if not exist %%F (
        echo Error: %%F not found
        set "err=1"
    )
)

if "%err%"=="1" (
    echo Aborted. Missing required files listed above.
    exit /b 1
)

:: Copy binaries (always) ---
copy /Y "%dRedCliSrc%"   "redcli.exe" >nul
copy /Y "%dGbrCliSrc%"   "gbrcli.exe" >nul
copy /Y "%dRedttSrc%"    "redtt.exe" >nul

:: --- Copy JSON files (if present) ---
if exist "%dRedCliJs%"  copy /Y "%dRedCliJs%"  "redcli.json" >nul
if exist "%dGbrCliJs%"  copy /Y "%dGbrCliJs%"  "gbrcli.json" >nul
if exist "%dRedttJs%"   copy /Y "%dRedttJs%"   "redtt.json" >nul

:: --- Copy help files (if present) ---
if exist "%dRedCliMd%" copy /Y "%dRedCliMd%"  "redcli.help.md" >nul
if exist "%dGbrCliMd%" copy /Y "%dGbrCliMd%" "gbrcli.help.md" >nul
if exist "%dRedttMd%"  copy /Y "%dRedttMd%"  "redtt.help.md" >nul

echo Sync complete.