Add-Type -AssemblyName System.Drawing

Get-ChildItem 'images\mods' -Filter *.png | Where-Object { $_.Name -ne 'skeleton-spawner.png' } | ForEach-Object {
  $bmp = New-Object System.Drawing.Bitmap($_.FullName)
  $w = $bmp.Width; $h = $bmp.Height
  $minX = $w; $maxX = -1; $minY = $h; $maxY = -1

  for ($y = 0; $y -lt $h; $y++) {
    for ($x = 0; $x -lt $w; $x++) {
      if ($bmp.GetPixel($x, $y).A -gt 0) {
        if ($x -lt $minX) { $minX = $x }
        if ($x -gt $maxX) { $maxX = $x }
        if ($y -lt $minY) { $minY = $y }
        if ($y -gt $maxY) { $maxY = $y }
      }
    }
  }

  $left = $minX
  $right = $w - 1 - $maxX
  $top = $minY
  $bottom = $h - 1 - $maxY
  $verdict = if ([Math]::Abs($left - $right) -le 2 -and [Math]::Abs($top - $bottom) -le 2) { 'CENTRED' } else { 'OFF' }

  Write-Output ("{0,-28} art {1}x{2}  margins L{3} R{4} T{5} B{6}  -> {7}" -f $_.Name, ($maxX - $minX + 1), ($maxY - $minY + 1), $left, $right, $top, $bottom, $verdict)
  $bmp.Dispose()
}
