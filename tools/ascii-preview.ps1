param(
  [Parameter(Mandatory = $true)][string[]]$Path,
  [int]$Cols = 34
)

# Crude eyes for icon files: downsamples each PNG to a luminance grid and prints
# it as characters, so shapes can be sanity-checked without opening the image.
Add-Type -AssemblyName System.Drawing
$ramp = ' .:-=+*#%@'

# A folder can be given instead of a list of files, and when this is called
# through -File a single comma separated string arrives instead of an array.
$files = @()
$flat = @()
foreach ($p in $Path) { $flat += ($p -split ',') }
foreach ($p in $flat) {
  if (Test-Path $p -PathType Container) { $files += (Get-ChildItem $p -Filter *.png | Sort-Object Name).FullName }
  else { $files += $p }
}

foreach ($p in $files) {
  if (-not (Test-Path $p)) { Write-Output ("MISSING " + $p); continue }

  $img = [System.Drawing.Image]::FromFile((Resolve-Path $p))
  # crop to the transparent margin so the art fills the readout
  $bmp = New-Object System.Drawing.Bitmap($img)
  $minX = $bmp.Width; $maxX = -1; $minY = $bmp.Height; $maxY = -1
  for ($y = 0; $y -lt $bmp.Height; $y += 2) {
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
      if ($bmp.GetPixel($x, $y).A -gt 12) {
        if ($x -lt $minX) { $minX = $x }
        if ($x -gt $maxX) { $maxX = $x }
        if ($y -lt $minY) { $minY = $y }
        if ($y -gt $maxY) { $maxY = $y }
      }
    }
  }
  if ($maxX -lt 0) { Write-Output ("EMPTY " + $p); continue }

  $artW = $maxX - $minX + 1
  $artH = $maxY - $minY + 1
  $rows = [Math]::Max(8, [int][Math]::Round($Cols * $artH / $artW / 2.1))

  Write-Output ("=== " + (Split-Path $p -Leaf) + "  (art " + $artW + "x" + $artH + ") ===")
  for ($ry = 0; $ry -lt $rows; $ry++) {
    $line = ''
    for ($rx = 0; $rx -lt $Cols; $rx++) {
      $x0 = $minX + [int][Math]::Floor($rx * $artW / $Cols)
      $x1 = $minX + [int][Math]::Floor(($rx + 1) * $artW / $Cols)
      $y0 = $minY + [int][Math]::Floor($ry * $artH / $rows)
      $y1 = $minY + [int][Math]::Floor(($ry + 1) * $artH / $rows)
      if ($x1 -le $x0) { $x1 = $x0 + 1 }
      if ($y1 -le $y0) { $y1 = $y0 + 1 }

      $sum = 0.0; $n = 0
      for ($y = $y0; $y -lt $y1; $y++) {
        for ($x = $x0; $x -lt $x1; $x++) {
          $c = $bmp.GetPixel($x, $y)
          $r = [int]$c.R; $g = [int]$c.G; $b = [int]$c.B
          $sum += (0.2126 * $r + 0.7152 * $g + 0.0722 * $b) * ($c.A / 255.0)
          $n++
        }
      }
      $lum = if ($n -gt 0) { $sum / $n } else { 0 }
      $idx = [int][Math]::Round($lum / 255 * ($ramp.Length - 1))
      if ($idx -lt 0) { $idx = 0 }
      if ($idx -ge $ramp.Length) { $idx = $ramp.Length - 1 }
      $line += $ramp[$idx]
    }
    Write-Output $line
  }
  Write-Output ''
  $bmp.Dispose(); $img.Dispose()
}
