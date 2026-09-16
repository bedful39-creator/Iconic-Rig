param(
  [string]$Source = (Join-Path $env:USERPROFILE 'Downloads\RAT\RigMod\Rig Mod Dsmp\IconicRig.jar'),
  [string]$DestName = 'IconicRig.jar',
  [switch]$InspectOnly
)

# Installs a finished mod jar into downloads/ so its card button goes live,
# after reporting what's actually inside the jar.
$root = Split-Path -Parent $PSScriptRoot
$destDir = Join-Path $root 'downloads'
New-Item -ItemType Directory -Force -Path $destDir | Out-Null

if (-not (Test-Path $Source)) { Write-Output ("NO SUCH FILE: " + $Source); return }
$src = Get-Item $Source
Write-Output ("source  " + $src.FullName)
Write-Output ("size    " + [Math]::Round($src.Length / 1KB, 1) + " KB")

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($src.FullName)
$entries = @($zip.Entries)

$fabric = $entries | Where-Object { $_.FullName -eq 'fabric.mod.json' } | Select-Object -First 1
$forge  = $entries | Where-Object { $_.FullName -eq 'META-INF/mods.toml' } | Select-Object -First 1
$neoforge = $entries | Where-Object { $_.FullName -eq 'META-INF/neoforge.mods.toml' } | Select-Object -First 1
$classes = @($entries | Where-Object { $_.FullName -like '*.class' }).Count
$nested  = @($entries | Where-Object { $_.FullName -like 'META-INF/jars/*' }).Count

Write-Output ("entries " + $entries.Count + "  classes=" + $classes + " nestedJars=" + $nested)
Write-Output ("loader  " + $(if ($fabric) { 'Fabric' } elseif ($neoforge) { 'NeoForge' } elseif ($forge) { 'Forge' } else { 'unknown - no loader metadata found' }))

if ($fabric) {
  $sr = New-Object System.IO.StreamReader($fabric.Open())
  $text = $sr.ReadToEnd()
  $sr.Dispose()
  try {
    $j = $text | ConvertFrom-Json
    Write-Output ("mod id  " + $j.id + "  version " + $j.version)
    Write-Output ("name    " + $j.name + "  env " + $j.environment)
    if ($j.depends) {
      $deps = $j.depends.PSObject.Properties | ForEach-Object { $_.Name + '=' + ($_.Value -join ',') }
      Write-Output ("depends " + ($deps -join '  '))
    }
  } catch {
    Write-Output "fabric.mod.json (raw):"
    Write-Output $text
  }
}

$zip.Dispose()

if (-not $InspectOnly) {
  Copy-Item $src.FullName (Join-Path $destDir $DestName) -Force
  $out = Get-Item (Join-Path $destDir $DestName)
  Write-Output ("installed downloads/" + $DestName + "  " + [Math]::Round($out.Length / 1KB, 1) + " KB")
}
