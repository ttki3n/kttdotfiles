$file = Join-Path $PSScriptRoot "settings.json"
$temp = "$file.tmp"

Write-Host "Sorting settings.json..." -ForegroundColor Cyan

jq -S '.keybindings |= sort_by(.id)' $file > $temp

if ($LASTEXITCODE -eq 0) {
    Move-Item -Force $temp $file
    Write-Host "Done! settings.json has been updated successfully." -ForegroundColor Green
} else {
    Remove-Item $temp -ErrorAction SilentlyContinue
    throw "jq failed"
}
