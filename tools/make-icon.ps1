param(
  [Parameter(Mandatory = $true)][string]$Spec,
  [Parameter(Mandatory = $true)][string]$Out,
  [int]$Canvas = 512,
  [double]$Fill = 0.82,
  [switch]$Shade,           # top-lit bevel so flat sprites read like shaded textures
  [switch]$Soft,            # anti-aliased upscale instead of hard pixel blocks
  [double]$Light = 0.18
)

$json = Get-Content $Spec -Raw | ConvertFrom-Json
$palette = @{}
foreach ($p in $json.palette.PSObject.Properties) { $palette[$p.Name] = $p.Value }
$grid = @($json.grid)

# --- every row must be the same width, or the sprite comes out lopsided --
$gh = $grid.Count
$gw = $grid[0].Length
for ($i = 0; $i -lt $gh; $i++) {
  if ($grid[$i].Length -ne $gw) {
    throw "Row $i in $Spec is $($grid[$i].Length) chars, expected $gw. Pad it with '.' to line up."
  }
}

# --- collect the drawn pixels --------------------------------------------
$px = @()
for ($y = 0; $y -lt $gh; $y++) {
  $row = @()
  $line = [string]$grid[$y]
  for ($x = 0; $x -lt $gw; $x++) {
    $ch = $line.Substring($x, 1)
    if (($ch -eq '.' -or $ch -eq ' ') -or (-not $palette.ContainsKey($ch))) { $row += $null }
    else { $row += [string]$palette[$ch] }
  }
  $px += ,$row
}

# --- crop to the pixels that were actually drawn -------------------------
$minX = 9999; $maxX = -1; $minY = 9999; $maxY = -1
for ($y = 0; $y -lt $gh; $y++) {
  for ($x = 0; $x -lt $gw; $x++) {
    if ($null -eq $px[$y][$x]) { continue }
    if ($x -lt $minX) { $minX = $x }
    if ($x -gt $maxX) { $maxX = $x }
    if ($y -lt $minY) { $minY = $y }
    if ($y -gt $maxY) { $maxY = $y }
  }
}
if ($maxX -lt 0) { throw "No pixels drawn in $Spec" }

$w = $maxX - $minX + 1
$h = $maxY - $minY + 1

function Get-Scaled([string]$hex, [double]$factor) {
  $b = ([string]$hex).TrimStart('#')
  $vals = @()
  for ($i = 0; $i -lt 3; $i++) {
    $c = [Convert]::ToInt32($b.Substring($i * 2, 2), 16)
    $c = [int][Math]::Round($c * $factor)
    if ($c -lt 0) { $c = 0 }
    if ($c -gt 255) { $c = 255 }
    $vals += $c
  }
  return ('#{0:x2}{1:x2}{2:x2}' -f $vals[0], $vals[1], $vals[2])
}

# --- optional lighting pass: light comes from above, edges catch it ------
$flat = @{}
for ($y = 0; $y -lt $h; $y++) {
  $gy = $y + $minY
  $row = @()
  for ($x = 0; $x -lt $w; $x++) {
    $gx = $x + $minX
    $hex = $px[$gy][$gx]
    if ($null -eq $hex) { $row += $null; continue }
    if (-not $Shade) { $row += $hex; continue }

    $t = $y / [Math]::Max(1, ($h - 1))          # 0 = top of sprite, 1 = bottom
    $f = 1 + $Light * 0.55 * (1 - 2 * $t)       # whole sprite lit from above

    $above = if ($gy - 1 -ge $minY) { $px[$gy - 1][$gx] } else { $null }
    $below = if ($gy + 1 -le $maxY) { $px[$gy + 1][$gx] } else { $null }
    $left  = if ($gx - 1 -ge $minX) { $px[$gy][$gx - 1] } else { $null }
    $right = if ($gx + 1 -le $maxX) { $px[$gy][$gx + 1] } else { $null }

    if ($null -eq $above)      { $f += $Light * 0.75 }   # top edge catches the light
    elseif ($null -eq $below)  { $f -= $Light * 0.75 }   # bottom edge falls away
    if ($null -eq $left)       { $f += $Light * 0.30 }
    elseif ($null -eq $right)  { $f -= $Light * 0.30 }

    $row += (Get-Scaled $hex $f)
  }
  $flat[$y] = $row
}

# --- integer scale so art stays crisp, then centre in the canvas ---------
$target = [int]($Canvas * $Fill)
$scale = [int][Math]::Min([Math]::Floor($target / $w), [Math]::Floor($target / $h))
if ($scale -lt 1) { $scale = 1 }

$offX = [int][Math]::Floor(($Canvas - ($w * $scale)) / 2)
$offY = [int][Math]::Floor(($Canvas - ($h * $scale)) / 2)

Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap($Canvas, $Canvas)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)

# Sprite is always drawn at (scale x supersample) then blitted down, so the
# soft path gets real anti-aliasing and the crisp path stays pixel-exact.
$ss = 1
if ($Soft) { $ss = 4 }
$tile = $scale * $ss
$srcW = $w * $tile
$srcH = $h * $tile

$tmp = New-Object System.Drawing.Bitmap($srcW, $srcH)
$gt = [System.Drawing.Graphics]::FromImage($tmp)
$gt.Clear([System.Drawing.Color]::Transparent)

for ($y = 0; $y -lt $h; $y++) {
  for ($x = 0; $x -lt $w; $x++) {
    $hex = $flat[$y][$x]
    if ($null -eq $hex) { continue }
    $b = ([string]$hex).TrimStart('#')
    $rr = [Convert]::ToInt32($b.Substring(0, 2), 16)
    $gg = [Convert]::ToInt32($b.Substring(2, 2), 16)
    $bb = [Convert]::ToInt32($b.Substring(4, 2), 16)
    $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, $rr, $gg, $bb))
    $gt.FillRectangle($brush, ($x * $tile), ($y * $tile), $tile, $tile)
    $brush.Dispose()
  }
}
$gt.Dispose()

if ($Soft) {
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
  $dest = New-Object System.Drawing.Rectangle($offX, $offY, ($w * $scale), ($h * $scale))
  $g.DrawImage($tmp, $dest, 0, 0, $srcW, $srcH, [System.Drawing.GraphicsUnit]::Pixel)
} else {
  $g.DrawImage($tmp, $offX, $offY, $srcW, $srcH)
}

$g.Dispose()
$tmp.Dispose()
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

$mode = @()
if ($Shade) { $mode += 'shaded' }
if ($Soft) { $mode += 'soft' }
if ($mode.Count -eq 0) { $mode += 'crisp' }
Write-Output ("Wrote $Out  (sprite ${w}x${h}, ${scale}x, " + ($mode -join '+') + ")")
