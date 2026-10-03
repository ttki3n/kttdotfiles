# Helpers
function Test-Command($Name) {
    $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}
# $sw = [System.Diagnostics.Stopwatch]::StartNew()
# Prompt config
# if (Test-Command "starship") {
#     Invoke-Expression (& starship init powershell)
# }
Invoke-Expression (&starship init powershell)
# PS does not support right prompt (T_T), therefore using session variable
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship_ps.toml"
# Write-Host ": $($sw.ElapsedMilliseconds)ms - starship"
# $sw.Restart()

if (Test-Command "zoxide") {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if (Test-Command "atuin") {
    Invoke-Expression (& { (atuin init powershell | Out-String) })
}

# Write-Host ": $($sw.ElapsedMilliseconds)ms - atuin"
# $sw.Restart()

if (Test-Command "fzf") {
    # Import the fzf module
    Import-Module PSFzf

    # Optional: Set default options (like layout, colors, or border)
    $env:FZF_DEFAULT_OPTS = "--layout=reverse --height 40% --border"

    # Tells fzf to use fd by default for files
    $env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden -I --follow --exclude .git'

    # Applies the same lightning-fast fd behavior specifically to Ctrl+T
    $env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND

    # Tells fzf what to use when looking for folders (Alt+C)
    $env:FZF_ALT_C_COMMAND = 'fd --type d --hidden --follow --exclude .git'

    # Set-PsFzfOption -TabExpansion $true
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}
# Write-Host ": $($sw.ElapsedMilliseconds)ms - fzf"
# $sw.Restart()

Set-Alias npp notepad++.exe
Set-Alias v nvim
function er { explorer.exe @args }
function ll { Get-ChildItem @args }
function la { Get-ChildItem -Force @args }
function l { eza -l --icons --git -a @args }
function lt { eza --tree --level=2 --long --icons --git @args }
function ltree { eza --tree --level=2  --icons --git @args }

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }
function ...... { Set-Location ../../../../.. }

# Git, Lazygit
function g {
    if (-not (Get-Command lazygit -ErrorAction SilentlyContinue)) {
        Write-Error "lazygit is not installed."
        return
    }

    & lazygit @Args
}

# Yazi
function y {
	$tmp = (New-TemporaryFile).FullName
	yazi.exe @args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}

# Navigation
function fcd {
    $dir = fd -t d . | fzf
    if ($dir) {
        Set-Location $dir
        Get-ChildItem
    }
}

function fcf {
    $file = fd -t f | fzf 
    if ($file) {
        Set-Location (Split-Path -Parent $file)
    }
}

function fv {
    $file = fd -t f | fzf
    if ($LASTEXITCODE -eq 0 -and $file) {
        nvim $file
    }
}

function fnpp {
    $file = fd -t f | fzf
    if ($LASTEXITCODE -eq 0 -and $file) {
        npp $file
    }
}

function frg {
    Invoke-PsFzfRipgrep
}
# Write-Host ": $($sw.ElapsedMilliseconds)ms - alias, fucntion, etc."
# $sw.Restart()
