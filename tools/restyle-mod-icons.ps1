param([switch]$Revert)

# Mod icons: rendered with the light-from-above shading pass and an
# anti-aliased upscale so all five match the texture pack icons.
#   tools\restyle-mod-icons.ps1 -Revert   -> back to hard-edged pixel art

$root = Split-Path -Parent $PSScriptRoot
$specDir = Join-Path $PSScriptRoot 'icons'
$outDir = Join-Path $root 'images\mods'
$backupDir = Join-Path $PSScriptRoot 'old-icons\mods'
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

# spec -> the file the site actually loads
$map = @(
  @{ Spec = 'gambling-rig.json';     Out = 'gambling-rig.png' },
  @{ Spec = 'skeleton-spawner.json'; Out = 'skeleton-spawner.png' },
  @{ Spec = 'pay.json';              Out = 'paymod.png' },
  @{ Spec = 'media.json';            Out = 'media-mod.png' },
  @{ Spec = 'elytra.json';           Out = 'elytra-mod.png' }
)

# The pre-skull spawner sprite, kept so -Revert can restore exactly what was there.
$retiredSpawner = Join-Path $specDir 'retired\skeleton-spawner-grille.json'

foreach ($m in $map) {
  $spec = Join-Path $specDir $m.Spec
  if ($Revert -and $m.Spec -eq 'skeleton-spawner.json' -and (Test-Path $retiredSpawner)) {
    $spec = $retiredSpawner
  }
  $out = Join-Path $outDir $m.Out
  $backup = Join-Path $backupDir $m.Out

  if ($Revert) {
    & (Join-Path $PSScriptRoot 'make-icon.ps1') -Spec $spec -Out $out
    continue
  }

  if ((Test-Path $out) -and -not (Test-Path $backup)) { Copy-Item $out $backup }
  & (Join-Path $PSScriptRoot 'make-icon.ps1') -Spec $spec -Out $out -Shade -Soft
}
