@echo off

cd /d "%~dp0"

if not exist "D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe" (
    echo Error: D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe not found
)

if not exist "D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe" (
    echo Error: D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe not found
)

if not exist "D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe" (
    echo Error: D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe not found
)

copy /Y "D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe" "redcli.exe"

copy /Y "D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.json" "redcli.json"

copy /Y "D:\Projects\ezdi\papers\encoder-rle4k-cpu\docs\redcli.help.md" "redcli.help.md"

copy /Y "D:\Projects\ezdi\parsers\parser-gbr\build\out\bin\x64\Release\gbrcli.exe"  "gbrcli.exe"

copy /Y "D:\Projects\ezdi\parsers\parser-gbr\build\out\bin\x64\Release\gbrcli.json"  "gbrcli.json"

copy /Y "D:\Projects\ezdi\parsers\parser-gbr\gbrcli\gbrcli.help.md" "gbrcli.help.md"

copy /Y "D:\Projects\ezdi\build\bin\x64\Release\redtt.exe"  "redtt.exe"

copy /Y "D:\Projects\ezdi\build\bin\x64\Release\redtt.json"  "redtt.json"

copy /Y "D:\Projects\ezdi\encoders\encoder-redtt\docs\helps\en.md" "redtt.help.md"

