@echo off

if not exist "%USERPROFILE%\.config" (
    mkdir "%USERPROFILE%\.config"
)

mklink /d "%LOCALAPPDATA%\nvim" "%~dp0nvim"

mklink /d "%USERPROFILE%\.config\starship" "%~dp0starship"

mklink /d "%USERPROFILE%\.config\wezterm" "%~dp0wezterm"

mklink /d "%APPDATA%\yazi\config" "%~dp0yazi"


pause