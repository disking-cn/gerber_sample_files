@echo off

cd /d "%~dp0"

copy "D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.exe" ./redcli.exe /y
copy "D:\Projects\ezdi\papers\encoder-rle4k-cpu\build\redcli.json" ./redcli.json /y
copy "D:\Projects\ezdi\papers\encoder-rle4k-cpu\docs\redcli.md" ./redcli.help.md /y

copy "D:\Projects\ezdi\parsers\parser-gbr\gbrcli\gbrcli.help.md" ./gbrcli.help.md /y
