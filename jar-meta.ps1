# Prints the RAW fabric.mod.json of a jar, plus its MANIFEST.MF, so the
# entrypoints/loader wiring can be judged exactly.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File tools/jar-meta.ps1 -Jar "C:\path\to.jar"
param([Parameter(Mandatory=$true)][string]$Jar)

Add-Type -AssemblyName System.IO.Compression.FileSystem
if (-not (Test-Path $Jar)) { Write-Output "MISSING: $Jar"; exit 1 }

$zip = [System.IO.Compression.ZipFile]::OpenRead($Jar)
try {
  foreach ($name in @('fabric.mod.json', 'META-INF/MANIFEST.MF')) {
    $e = $zip.Entries | Where-Object { $_.FullName -eq $name }
    Write-Output "===== $name ====="
    if ($e) {
      $sr = New-Object System.IO.StreamReader($e.Open())
      Write-Output $sr.ReadToEnd()
      $sr.Close()
    } else { Write-Output "(absent)" }
  }
} finally { $zip.Dispose() }
