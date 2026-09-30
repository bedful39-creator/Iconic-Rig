# Installs the free "Elytra Mod" download: copies the user's jar into
# downloads/ under the site's filename and removes the retired IconicRig.jar.
# Safe to re-run. Usage: powershell -NoProfile -ExecutionPolicy Bypass -File tools/install-elytra-jar.ps1
param(
  [string]$Source = "C:\Users\bdful\Downloads\Fake Elytra.jar",
  [string]$Dest   = "downloads\fake-elytra.jar"
)

$root = Split-Path -Parent $PSScriptRoot
$src = if ([System.IO.Path]::IsPathRooted($Source)) { $Source } else { Join-Path $root $Source }
$dst = Join-Path $root $Dest

if (-not (Test-Path $src)) { Write-Output "MISSING-SOURCE: $src"; exit 1 }

# Validate it is a real zip/jar before it touches downloads/.
Add-Type -AssemblyName System.IO.Compression.FileSystem
try {
  $z = [System.IO.Compression.ZipFile]::OpenRead($src)
  $count = $z.Entries.Count
  $z.Dispose()
} catch { Write-Output "NOT-A-JAR: $src"; exit 1 }

Copy-Item $src $dst -Force
$retired = Join-Path $root 'downloads\IconicRig.jar'
if (Test-Path $retired) { Remove-Item $retired -Force; Write-Output "RETIRED: downloads/IconicRig.jar" }

Write-Output ("INSTALLED: {0}  ({1} bytes, {2} entries)" -f $Dest, (Get-Item $dst).Length, $count)
Get-ChildItem (Join-Path $root 'downloads') -File | ForEach-Object { Write-Output ("  " + $_.Name + "  " + $_.Length + "b") }
