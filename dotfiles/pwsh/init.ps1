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

# Load zoxide on the first jump. Its directory tracking starts at that point.
$global:__dotfilesZoxideLoaded = $false
function Initialize-DotfilesZoxide {
    if ($global:__dotfilesZoxideLoaded) { return $true }
    try {
        if (-not (Test-Command 'zoxide')) { throw 'zoxide is not installed.' }
        $init = zoxide init powershell | Out-String
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($init)) {
            throw 'zoxide init failed.'
        }
        Invoke-Expression $init
        $global:__dotfilesZoxideLoaded = $true
        return $true
    }
    catch {
        Write-Warning "Could not initialize zoxide: $_"
        return $false
    }
}
function z {
    if (Initialize-DotfilesZoxide) { __zoxide_z @args }
}
function zi {
    if (Initialize-DotfilesZoxide) { __zoxide_zi @args }
}
if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingZoxideEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

# Atuin must wrap the FIRST ReadLine to record history from the first command.
# This defers initialization beyond the profile, not beyond interactive input.
if ((Test-Command 'atuin') -and -not (Get-Module Atuin)) {
    $null = Get-Command PSConsoleHostReadLine -ErrorAction Stop
    # Do not capture our own wrapper if this profile is sourced again before input.
    if (-not $global:__dotfilesOriginalReadLine) {
        $global:__dotfilesOriginalReadLine = $function:PSConsoleHostReadLine
    }
    function global:PSConsoleHostReadLine {
        $lastNativeExitCode = $global:LASTEXITCODE
        # Restore the original before Atuin captures it, avoiding recursion.
        $function:global:PSConsoleHostReadLine = $global:__dotfilesOriginalReadLine
        try {
            $init = atuin init powershell | Out-String
            if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($init)) {
                throw 'atuin init failed.'
            }
            Invoke-Expression $init
        }
        catch {
            Write-Warning "Could not initialize Atuin; using the standard line reader: $_"
        }
        finally {
            $global:LASTEXITCODE = $lastNativeExitCode
        }
        & $function:PSConsoleHostReadLine
    }
}

if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingAtuinEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

# Environment settings are cheap; defer PSFzf itself until a key or frg is used.
$env:FZF_DEFAULT_OPTS = "--layout=reverse --height 40% --border"
$env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden -I --follow --exclude .git'
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
$env:FZF_ALT_C_COMMAND = 'fd --type d --hidden --follow --exclude .git'
$global:__dotfilesPSFzfLoaded = $false

function Initialize-DotfilesPSFzf {
    if ($global:__dotfilesPSFzfLoaded) { return $true }
    try {
        if (-not (Test-Command 'fzf')) { throw 'fzf is not installed.' }
        # Explicit chords replace the lazy handlers. Leave Ctrl+r to Atuin.
        # Global import keeps commands available after this function returns.
        Import-Module PSFzf -Global -ArgumentList @('Ctrl+t', '', 'Alt+c', 'Alt+a') -ErrorAction Stop
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
        $global:__dotfilesPSFzfLoaded = $true
        return $true
    }
    catch {
        Write-Warning "Could not initialize PSFzf: $_"
        return $false
    }
}
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock {
    if (Initialize-DotfilesPSFzf) { Invoke-FzfTabCompletion }
    else { [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext() }
}
Set-PSReadLineKeyHandler -Key 'Ctrl+t' -ScriptBlock {
    if (Initialize-DotfilesPSFzf) { Invoke-FzfPsReadlineHandlerProvider }
}
Set-PSReadLineKeyHandler -Key 'Alt+c' -ScriptBlock {
    if (Initialize-DotfilesPSFzf) { Invoke-FzfPsReadlineHandlerSetLocation }
}
Set-PSReadLineKeyHandler -Key 'Alt+a' -ScriptBlock {
    if (Initialize-DotfilesPSFzf) { Invoke-FzfPsReadlineHandlerHistoryArgs }
}
if ($EnablePwshLoadingTimeLog) {
    $__pwshLoadingFzfEnd = [System.Diagnostics.Stopwatch]::GetTimestamp()
}

Set-Alias npp notepad++.exe
Set-Alias v nvim

function nv2 {
    $env:NVIM_APPNAME="nvim-chad"
    nvim $args
}

# Git
# alias gca="git commit -a -m"
# alias gp="git push origin HEAD"
# alias gpu="git pull origin"
# alias gst="git status"
# alias gdiff="git diff"
# alias gco="git checkout"
# alias gb='git branch'
# alias gba='git branch -a'
# alias gadd='git add'
# alias ga='git add -p'
# alias gcoall='git checkout -- .'
# alias gre='git reset'

function gc { git commit -m @args }
function gh { git log --pretty='%C(Yellow)%h  %C(reset)%ad %C(Cyan)%<(20,trunc)%an %C(reset)%s' --date=format:'%Y-%m-%d %H:%M' @args }
function glog { git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit @args }
function gco { git checkout @args }
function gr { git remote @args }

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
    $dir = fd -t d | fzf
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
    $file = fd -H -t f | fzf
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
    if (Initialize-DotfilesPSFzf) { Invoke-PsFzfRipgrep @args }
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
            # Stage timings below measure lazy-loader setup, not first-use work.
            loading_mode = 'lazy-zoxide-atuin-fzf-v1'
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
