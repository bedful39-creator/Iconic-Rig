# Dumps a jar's fabric.mod.json metadata + entry list so it can be checked
# before being wired up as a site download.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File tools/inspect-jar.ps1 -Jar "C:\path\to.jar"
param([Parameter(Mandatory=$true)][string]$Jar)

Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not (Test-Path $Jar)) { Write-Output "MISSING: $Jar"; exit 1 }
Write-Output ("{0}  ({1} bytes)" -f $Jar, (Get-Item $Jar).Length)

$zip = [System.IO.Compression.ZipFile]::OpenRead($Jar)
try {
  $meta = $zip.Entries | Where-Object { $_.FullName -eq 'fabric.mod.json' }
  if ($meta) {
    $sr = New-Object System.IO.StreamReader($meta.Open())
    $json = $sr.ReadToEnd(); $sr.Close()
    $obj = $json | ConvertFrom-Json
    Write-Output ("  id           : " + $obj.id)
    Write-Output ("  name         : " + $obj.name)
    Write-Output ("  version      : " + $obj.version)
    Write-Output ("  description  : " + $obj.description)
    Write-Output ("  minecraft    : " + ("" + $obj.depends.minecraft))
    Write-Output ("  java         : " + ("" + $obj.depends.java))
  } else {
    Write-Output "  (no fabric.mod.json)"
  }
  Write-Output ("  entries      : " + $zip.Entries.Count)
  Write-Output "  all entries  :"
  $zip.Entries | ForEach-Object { Write-Output ("    " + $_.FullName + "  (" + $_.Length + "b)") }
} finally { $zip.Dispose() }
