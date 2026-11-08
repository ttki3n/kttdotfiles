# Toggle startup timing and append one JSON record per load to ~/log_pwsh_loading_time.log.
$EnablePwshLoadingTimeLog = $true

if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingStartedAt = [DateTimeOffset]::UtcNow
    $__pwshLoadingStart = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

# Helpers
function Test-Command($Name) {
    $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}
if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingHelpersEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

# Prompt config
# if (Test-Command "starship") {
#     Invoke-Expression (& starship init powershell)
# }
Invoke-Expression (&starship init powershell)
# PS does not support right prompt (T_T), therefore using session variable
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship_ps.toml"
if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingStarshipEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

if (Test-Command "zoxide") {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingZoxideEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

if (Test-Command "atuin") {
    Invoke-Expression (& { (atuin init powershell | Out-String) })
}

if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingAtuinEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

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
if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingFzfEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

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
if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()

    # All allocation, formatting and disk I/O happens AFTER the final timestamp.
    # Measurements include the tiny checkpoint overhead, but exclude log writing
    # and prompt rendering. No per-stage console output or module autoload for timing.
    try {
        $__pwshLoadingMsPerTick = 1000.0 / [System.Diagnostics.Stopwatch]::Frequency
        $__pwshLoadingRecord = [ordered]@{
            schema_version = 1
            started_at_utc = $__pwshLoadingStartedAt.ToString('o')
            pid = $PID
            powershell_version = $PSVersionTable.PSVersion.ToString()
            host_name = $Host.Name
            cwd = $PWD.Path
            total_ms = [math]::Round(($__pwshLoadingEnd - $__pwshLoadingStart) * $__pwshLoadingMsPerTick, 3)
            stages_ms = [ordered]@{
                helpers = [math]::Round(($__pwshLoadingHelpersEnd - $__pwshLoadingStart) * $__pwshLoadingMsPerTick, 3)
                starship = [math]::Round(($__pwshLoadingStarshipEnd - $__pwshLoadingHelpersEnd) * $__pwshLoadingMsPerTick, 3)
                zoxide = [math]::Round(($__pwshLoadingZoxideEnd - $__pwshLoadingStarshipEnd) * $__pwshLoadingMsPerTick, 3)
                atuin = [math]::Round(($__pwshLoadingAtuinEnd - $__pwshLoadingZoxideEnd) * $__pwshLoadingMsPerTick, 3)
                fzf = [math]::Round(($__pwshLoadingFzfEnd - $__pwshLoadingAtuinEnd) * $__pwshLoadingMsPerTick, 3)
                aliases_functions = [math]::Round(($__pwshLoadingEnd - $__pwshLoadingFzfEnd) * $__pwshLoadingMsPerTick, 3)
            }
        }
        $__pwshLoadingJson = ConvertTo-Json -InputObject $__pwshLoadingRecord -Depth 3 -Compress
        Add-Content -LiteralPath (Join-Path $HOME 'log_pwsh_loading_time.log') -Value $__pwshLoadingJson -Encoding utf8 -ErrorAction Stop
    }
    catch {
        Write-Warning "Could not write PowerShell startup timing log: $_"
    }
    finally {
        Remove-Variable -Name '__pwshLoading*' -ErrorAction SilentlyContinue
    }
}
