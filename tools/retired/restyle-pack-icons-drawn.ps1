param([switch]$Revert)

# Restyles the texture pack icons: adds a light-from-above shading pass and an
# anti-aliased upscale so they stop reading as hard pixel blocks.
# The current pixels are copied to tools/old-icons/packs once, so -Revert
# puts the originals back.

$root = Split-Path -Parent $PSScriptRoot
$specDir = Join-Path $PSScriptRoot 'icons\packs'
$outDir = Join-Path $root 'images\packs'
$backupDir = Join-Path $PSScriptRoot 'old-icons\packs'
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

if ($Revert) {
  Get-ChildItem $backupDir -Filter *.png | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $outDir $_.Name) -Force
    Write-Output ("restored " + $_.Name)
  }
  return
}

Get-ChildItem $specDir -Filter *.json | Sort-Object Name | ForEach-Object {
  $png = Join-Path $outDir ($_.BaseName + '.png')
  $backup = Join-Path $backupDir ($_.BaseName + '.png')
  if ((Test-Path $png) -and -not (Test-Path $backup)) {
    Copy-Item $png $backup   # keep the very first version we ever had
  }
  & (Join-Path $PSScriptRoot 'make-icon.ps1') -Spec $_.FullName -Out $png -Shade -Soft
}
