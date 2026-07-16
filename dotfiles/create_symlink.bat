@echo off

if not exist "%USERPROFILE%\.config" (
    mkdir "%USERPROFILE%\.config"
)

mklink /d "%LOCALAPPDATA%\nvim" "%~dp0nvim"

mklink /d "%USERPROFILE%\.config\starship" "%~dp0starship"

mklink /d "%USERPROFILE%\.config\wezterm" "%~dp0wezterm"

REM Yazi setup
mklink /d "%APPDATA%\yazi\config" "%~dp0yazi"

if not defined YAZI_FILE_ONE (
    setx YAZI_FILE_ONE "C:\Git\usr\bin\file.exe"
    REM set YAZI_FILE_ONE="C:\Git\usr\bin\file.exe"
    echo Variable YAZI_FILE_ONE has been set.
) else (
    echo Variable YAZI_FILE_ONE is already set to: %YAZI_FILE_ONE%
)

pause