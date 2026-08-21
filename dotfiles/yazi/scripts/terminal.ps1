param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$App,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Path,

    [Parameter(Position = 2, ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

# WezTerm
if ($env:WEZTERM_PANE) {
    $args = @(
        "cli",
        "spawn",
        "--cwd", $Path,
        "--",
        $App
    ) + $Arguments

    & wezterm @args
    exit $LASTEXITCODE
}

# Windows Terminal
if ($env:WT_SESSION) {
    $args = @(
        "-w", "0",
        "new-tab",
        "-d", $Path,
        $App
    ) + $Arguments

    & wt.exe @args
    exit $LASTEXITCODE
}

Write-Error "Unsupported terminal: neither WezTerm nor Windows Terminal was detected."
exit 1
