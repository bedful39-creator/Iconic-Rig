param(
  [string]$Version = '1.21.11',
  [switch]$Extras  # only pull the spare candidates used by the options page
)

# Pulls real Minecraft textures straight out of the installed client jar and
# writes them into images/packs/ under the filenames the site already expects.
# Never writes to .minecraft - the jar is opened read-only.

$root = Split-Path -Parent $PSScriptRoot
$mc = Join-Path $env:APPDATA '.minecraft'
$jar = Join-Path $mc ("versions\" + $Version + "\" + $Version + ".jar")

if (-not (Test-Path $jar)) {
  # fall back to whatever client jar is newest, so this doesn't just fail
  $candidates = Get-ChildItem (Join-Path $mc 'versions') -Directory | ForEach-Object {
    Get-ChildItem $_.FullName -Filter *.jar -ErrorAction SilentlyContinue
  } | Sort-Object Length -Descending
  if (-not $candidates) { throw "No Minecraft client jar found under $mc\versions" }
  $jar = $candidates[0].FullName
  Write-Output ("using newest jar instead: " + $jar)
}
Write-Output ("jar " + $jar)

$rawDir = Join-Path $PSScriptRoot 'vanilla'
$extraDir = Join-Path $rawDir 'extra'
$outDir = Join-Path $root 'images\packs'
New-Item -ItemType Directory -Force -Path $rawDir, $extraDir, $outDir | Out-Null

# vanilla texture -> the file the site loads
$map = @(
  @{ Tex = 'block/green_stained_glass'; Out = 'green-glass-spawner.png' },
  @{ Tex = 'item/shears';               Out = 'shears-elytra.png' },
  @{ Tex = 'item/bundle';               Out = 'lootdrop-megapack.png' },
  @{ Tex = 'item/diamond_chestplate';   Out = 'netherite-megapack.png' },
  @{ Tex = 'block/red_stained_glass';   Out = 'stained-glass-lantern.png' },
  @{ Tex = 'block/deepslate_bricks';    Out = 'deepslate-gilded.png' },
  @{ Tex = 'item/orange_dye';           Out = 'orange-dye-ingot.png' },
  @{ Tex = 'item/totem_of_undying';     Out = 'crystal-optimizer.png' },
  @{ Tex = 'block/netherite_block';     Out = 'anti-block-rotation.png' }
)

$extraTextures = @('block/chiseled_stone_bricks', 'block/iron_block', 'block/observer',
                   'block/piston_side', 'block/polished_deepslate', 'block/smooth_stone')

Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Drawing

$zip = [System.IO.Compression.ZipFile]::OpenRead($jar)
$lookup = @{}
foreach ($e in $zip.Entries) { $lookup[$e.FullName.ToLower()] = $e }

function Save-Texture {
  param([string]$Tex, [string]$Dest, [int]$Px = 192)

  $entryPath = ('assets/minecraft/textures/' + $Tex + '.png').ToLower()
  if (-not $lookup.ContainsKey($entryPath)) {
    Write-Output ("MISSING " + $Tex)
    return $false
  }

  $rawPath = Join-Path $rawDir (($Tex -replace '/', '_') + '.png')
  $srcSize = 0
  $src = $lookup[$entryPath].Open()
  $out = [System.IO.File]::Create($rawPath)
  $src.CopyTo($out)
  $out.Dispose(); $src.Dispose()

  $img = [System.Drawing.Image]::FromFile($rawPath)
  $srcSize = $img.Width
  $factor = [Math]::Max(1, [int][Math]::Floor($Px / $img.Width))
  $size = $img.Width * $factor

  # Blow the 16x16 texture up 2x larger than needed with hard pixels, then
  # shrink it back down smoothly. Keeps the original art exactly, but takes the
  # hard edge off the blocks when the card scales it.
  $bigSize = $size * 2
  $big = New-Object System.Drawing.Bitmap($bigSize, $bigSize)
  $gBig = [System.Drawing.Graphics]::FromImage($big)
  $gBig.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
  $gBig.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
  $gBig.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $bigSize, $bigSize)))
  $gBig.Dispose()

  $bmp = New-Object System.Drawing.Bitmap($size, $size)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $g.DrawImage($big, (New-Object System.Drawing.Rectangle(0, 0, $size, $size)))
  $g.Dispose()
  $big.Dispose()
  $bmp.Save($Dest, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose(); $img.Dispose()

  Write-Output ("ok  " + $Tex.PadRight(30) + " -> " + (Split-Path $Dest -Leaf) + "  (" + $size + "px, from " + $srcSize + "px source)")
  return $true
}

if (-not $Extras) {
  foreach ($m in $map) {
    Save-Texture -Tex $m.Tex -Dest (Join-Path $outDir $m.Out)
  }
}

foreach ($e in $extraTextures) {
  $name = (Split-Path $e -Leaf) + '.png'
  Save-Texture -Tex $e -Dest (Join-Path $extraDir $name)
}

$zip.Dispose()
