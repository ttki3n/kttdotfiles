
# --- Resolve absolute path to init.ps1, relative to this script's folder ---
$dotfilesProfile = Join-Path -Path $PSScriptRoot -ChildPath 'dotfiles\pwsh\init.ps1'
$dotfilesProfile = [System.IO.Path]::GetFullPath($dotfilesProfile)

if (-not (Test-Path -Path $dotfilesProfile))
{
  Write-Warning "init.ps1 not found at expected path: $dotfilesProfile"
  return
}

# --- Markers used to identify the bootstrap block for idempotent updates ---
$markerStart = '# >>> bootstrap: init.ps1 >>>'
$markerEnd   = '# <<< bootstrap: init.ps1 <<<'

$bootstrapBlock = @"
$markerStart
if (Test-Path '$dotfilesProfile') {
    . '$dotfilesProfile'
}
$markerEnd
"@

# --- Step 1: check the profile, create it (and its folder) if missing ---
if (-not (Test-Path -Path $PROFILE))
{
  Write-Host "Profile not found. Creating: $PROFILE"
  New-Item -ItemType File -Path $PROFILE -Force | Out-Null
} else
{
  Write-Host "Profile found: $PROFILE"
}

# --- Step 2: read existing content ---
$content = Get-Content -Path $PROFILE -Raw -ErrorAction SilentlyContinue
if ($null -eq $content)
{ $content = '' 
}

# --- Step 2.3: if bootstrap block already exists, only update the path ---
if ($content -match [regex]::Escape($markerStart))
{
  Write-Host "Existing bootstrap block found. Updating path only."
  $pattern = '(?s)' + [regex]::Escape($markerStart) + '.*?' + [regex]::Escape($markerEnd)
  # Use the MatchEvaluator overload so the replacement text (which may
  # contain backslashes) is inserted literally, not interpreted as a
  # regex replacement pattern.
  $newContent = [regex]::Replace(
    $content,
    $pattern,
    [System.Text.RegularExpressions.MatchEvaluator] { param($m) $bootstrapBlock }
  )
  Set-Content -Path $PROFILE -Value $newContent -NoNewline
} else
{
  Write-Host "No existing bootstrap block found. Inserting at the beginning."
  $separator = if ($content.Length -gt 0)
  { "`r`n" 
  } else
  { '' 
  }
  $newContent = $bootstrapBlock + $separator + $content
  Set-Content -Path $PROFILE -Value $newContent -NoNewline
}

Write-Host "Done. Bootstrap now points to: $dotfilesProfile"
