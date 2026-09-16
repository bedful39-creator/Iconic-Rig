$mc = Join-Path $env:APPDATA '.minecraft'
Write-Output ("MC-DIR " + $mc + " exists=" + (Test-Path $mc))

$versions = Join-Path $mc 'versions'
if (Test-Path $versions) {
  Write-Output '--- versions ---'
  Get-ChildItem $versions -Directory | Sort-Object Name | ForEach-Object {
    $jar = Get-ChildItem $_.FullName -Filter *.jar -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($jar) { Write-Output ("  " + $_.Name + "  jar=" + [Math]::Round($jar.Length / 1MB, 1) + "MB") }
    else { Write-Output ("  " + $_.Name + "  (no jar)") }
  }
} else {
  Write-Output 'no versions folder'
}

$rp = Join-Path $mc 'resourcepacks'
if (Test-Path $rp) {
  Write-Output '--- resourcepacks ---'
  Get-ChildItem $rp | Select-Object -ExpandProperty Name
}

$assets = Join-Path $mc 'assets\indexes'
if (Test-Path $assets) {
  Write-Output '--- asset indexes ---'
  Get-ChildItem $assets | Select-Object -ExpandProperty Name
}
