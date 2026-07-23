# Helpers
function Test-Command($Name) {
    $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

# Prompt config
# if (Test-Command "starship") {
#     Invoke-Expression (& starship init powershell)
# }
Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"

if (Test-Command "zoxide") {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if (Test-Command "atuin") {
    Invoke-Expression (& { (atuin init powershell | Out-String) })
}

if (Test-Command "fzf") {
    # Import the fzf module
    Import-Module PSFzf

    # Optional: Set default options (like layout, colors, or border)
    $env:FZF_DEFAULT_OPTS = "--layout=reverse --height 40% --border"

    # Tells fzf to use fd by default for files
    $env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'

    # Applies the same lightning-fast fd behavior specifically to Ctrl+T
    $env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND

    # Tells fzf what to use when looking for folders (Alt+C)
    $env:FZF_ALT_C_COMMAND = 'fd --type d --hidden --follow --exclude .git'
}

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

# Git, Lazygit
function g {
    if (-not (Get-Command lazygit -ErrorAction SilentlyContinue)) {
        Write-Error "lazygit is not installed."
        return
    }

    & lazygit @Args
}

# Navigation
function fv {
    $file = fd -t f | fzf
    if ($LASTEXITCODE -eq 0 -and $file) {
        nvim $file
    }
}

function frg {
    Invoke-PsFzfRipgrep
}
