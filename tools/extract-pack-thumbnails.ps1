$root = Split-Path -Parent $PSScriptRoot
$zipDir = Join-Path $root 'downloads'
$outDir = Join-Path $PSScriptRoot 'pack-thumbnails'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Drawing

Get-ChildItem $zipDir -Filter *.zip | Sort-Object Name | ForEach-Object {
  $zip = [System.IO.Compression.ZipFile]::OpenRead($_.FullName)
  $entry = $zip.Entries | Where-Object { $_.FullName -eq 'pack.png' } | Select-Object -First 1
  if (-not $entry) { Write-Output ("no pack.png in " + $_.Name); $zip.Dispose(); return }

  $out = Join-Path $outDir $_.BaseName
  $raw = $out + '.png'
  $s = $entry.Open()
  $f = [System.IO.File]::Create($raw)
  $s.CopyTo($f); $f.Dispose(); $s.Dispose()
  $zip.Dispose()

  $img = [System.Drawing.Image]::FromFile($raw)
  $size = $img.Width.ToString() + 'x' + $img.Height
  $img.Dispose()
  Write-Output ($_.BaseName.PadRight(44) + "pack.png " + $size)
}
