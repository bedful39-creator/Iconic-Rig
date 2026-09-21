# Compares the two IconicRig jar builds on disk by reading the metadata
# Fabric ships inside them (fabric.mod.json) — no extraction to disk.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File tools/inspect-jars.ps1

Add-Type -AssemblyName System.IO.Compression.FileSystem

$jars = @(
  "C:\Users\bdful\Downloads\RAT\RigMod\Rig Mod Dsmp\IconicRig.jar",
  "C:\Users\bdful\Downloads\RAT\RigMod\Rig Mod Dsmp RAT\IconicRig.jar",
  "C:\Users\bdful\Downloads\Website\downloads\IconicRig.jar"
)

foreach ($jar in $jars) {
  Write-Output "=============================================================="
  if (-not (Test-Path $jar)) { Write-Output "MISSING: $jar"; continue }
  $len = (Get-Item $jar).Length
  Write-Output "$jar  ($len bytes)"

  $zip = [System.IO.Compression.ZipFile]::OpenRead($jar)
  try {
    $meta = $zip.Entries | Where-Object { $_.FullName -eq 'fabric.mod.json' }
    if ($meta) {
      $sr = New-Object System.IO.StreamReader($meta.Open())
      $json = $sr.ReadToEnd()
      $sr.Close()
      $obj = $json | ConvertFrom-Json
      Write-Output ("  id           : " + $obj.id)
      Write-Output ("  name         : " + $obj.name)
      Write-Output ("  version      : " + $obj.version)
      Write-Output ("  description  : " + $obj.description)
      Write-Output ("  minecraft    : " + ("" + $obj.depends.minecraft))
      Write-Output ("  java         : " + ("" + $obj.depends.java))
      Write-Output ("  fabricloader : " + ("" + $obj.depends.fabricloader))
    } else {
      Write-Output "  (no fabric.mod.json)"
    }
    # Does it look like a Fabric/Forge mod at all?
    $names = ($zip.Entries | Select-Object -First 40 | ForEach-Object { $_.FullName }) -join " "
    Write-Output ("  entries      : " + $zip.Entries.Count)
    Write-Output ("  head         : " + $names)
  } finally {
    $zip.Dispose()
  }
}
