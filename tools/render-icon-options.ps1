$root = Split-Path -Parent $PSScriptRoot
$specDir = Join-Path $PSScriptRoot 'icons\options'
$outDir = Join-Path $root 'images\options'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$softDir = Join-Path $outDir 'soft'
New-Item -ItemType Directory -Force -Path $softDir | Out-Null

# Spawner candidates: each one rendered twice - crisp (matches the current mod
# icons) and in the new shaded + soft style - so design and finish can be
# picked together.
Get-ChildItem $specDir -Filter *.json | Sort-Object Name | ForEach-Object {
  & (Join-Path $PSScriptRoot 'make-icon.ps1') -Spec $_.FullName -Out (Join-Path $outDir ($_.BaseName + '.png'))
  & (Join-Path $PSScriptRoot 'make-icon.ps1') -Spec $_.FullName -Out (Join-Path $softDir ($_.BaseName + '.png')) -Shade -Soft
}

# One existing mod icon redrawn in the new shaded + soft style, for comparison.
$modSpec = Join-Path $PSScriptRoot 'icons\gambling-rig.json'
if (Test-Path $modSpec) {
  & (Join-Path $PSScriptRoot 'make-icon.ps1') -Spec $modSpec -Out (Join-Path $outDir 'gambling-rig-modern.png') -Shade -Soft
}
