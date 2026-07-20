# Prompt config
Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"

Set-Alias npp notepad++.exe
Set-Alias v nvim

function ll { Get-ChildItem }
function la { Get-ChildItem -Force }
function l { eza -l --icons --git -a }
function lt { eza --tree --level=2 --long --icons --git }
function ltree { eza --tree --level=2  --icons --git }

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }

Invoke-Expression (& { (zoxide init powershell | Out-String) })
