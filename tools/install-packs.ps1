param(
  [string]$Source = (Join-Path $env:USERPROFILE 'Downloads\RAT'),
  [switch]$WhatIf
)

# Installs the finished texture pack zips into downloads/ under the exact
# filenames the pack cards look for, so the greyed Download pills go live.
# Source zips are only read, never changed.

$root = Split-Path -Parent $PSScriptRoot
$destDir = Join-Path $root 'downloads'
New-Item -ItemType Directory -Force -Path $destDir | Out-Null

$map = @(
  @{ Zip = 'Green.Stained.Glass.to.Spawner.zip';  Out = 'green-glass-spawner.zip' },
  @{ Zip = 'Pink.Version.-.Shears.to.Elytra.zip'; Out = 'shears-to-elytra.zip' },
  @{ Zip = 'Lootdrop.Megapack.v2.zip';            Out = 'lootdrop-megapack.zip' },
  @{ Zip = 'Diamond.to.Netherite.zip';            Out = 'netherite-mega-pack.zip' },
  @{ Zip = 'Stained.to.Beacon.Lantern.zip';       Out = 'stained-glass-to-lantern-and-beacon.zip' },
  @{ Zip = 'Bricks.to.Blackstone.zip';            Out = 'deepslate-bricks-to-gilded-blackstone.zip' },
  @{ Zip = 'Orange.to.Ingot.zip';                 Out = 'orange-dye-to-netherite-ingot.zip' },
  @{ Zip = "Ryzen.s.Crystal.Optimizer.zip";       Out = 'crystal-optimizer.zip' },
  @{ Zip = 'Anti.Block.Rotation.zip';             Out = 'anti-block-rotation.zip' }
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

$problems = 0
foreach ($m in $map) {
  $src = Join-Path $Source $m.Zip
  if (-not (Test-Path $src)) { Write-Output ("MISSING SOURCE  " + $m.Zip); $problems++; continue }

  # peek inside: a real Java pack has pack.mcmeta and a textures folder
  $names = @()
  try {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($src)
    $names = @($zip.Entries | ForEach-Object { $_.FullName })
    $zip.Dispose()
  } catch {
    Write-Output ("NOT A ZIP       " + $m.Zip); $problems++; continue
  }

  $mcmeta = @($names | Where-Object { $_ -eq 'pack.mcmeta' }).Count -gt 0
  $packPng = @($names | Where-Object { $_ -eq 'pack.png' }).Count -gt 0
  $textures = @($names | Where-Object { $_ -like 'assets/*textures/*.png' }).Count
  if (-not $mcmeta) { Write-Output ("WARNING missing pack.mcmeta: " + $m.Zip) }

  $dest = Join-Path $destDir $m.Out
  if (-not $WhatIf) { Copy-Item $src $dest -Force }

  $kb = [Math]::Round((Get-Item $src).Length / 1KB, 1)
  Write-Output ("installed  " + $m.Out.PadRight(44) + " " + $kb.ToString().PadLeft(7) + "KB  mcmeta=" + $mcmeta + " pack.png=" + $packPng + " textures=" + $textures)
}

Write-Output ""
Write-Output ("problems: " + $problems)
Write-Output ("downloads/ now holds:")
Get-ChildItem $destDir -File | Sort-Object Name | ForEach-Object {
  Write-Output ("  " + $_.Name.PadRight(46) + ([Math]::Round($_.Length / 1KB, 1)).ToString().PadLeft(7) + "KB")
}
