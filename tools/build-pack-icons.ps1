$specDir = Join-Path $PSScriptRoot 'icons\packs'
$outDir = Join-Path (Get-Location) 'images\packs'

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

Get-ChildItem $specDir -Filter *.json | Sort-Object Name | ForEach-Object {
  $out = Join-Path $outDir ($_.BaseName + '.png')
  & (Join-Path $PSScriptRoot 'make-icon.ps1') -Spec $_.FullName -Out $out
}
