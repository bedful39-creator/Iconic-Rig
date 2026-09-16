param([int]$Port = 8478)

# Hits every file the site links to, so a broken button shows up before a
# visitor finds it.
$base = "http://127.0.0.1:" + $Port + "/"

$files = @(
  'downloads/green-glass-spawner.zip',
  'downloads/shears-to-elytra.zip',
  'downloads/lootdrop-megapack.zip',
  'downloads/netherite-mega-pack.zip',
  'downloads/stained-glass-to-lantern-and-beacon.zip',
  'downloads/deepslate-bricks-to-gilded-blackstone.zip',
  'downloads/orange-dye-to-netherite-ingot.zip',
  'downloads/crystal-optimizer.zip',
  'downloads/anti-block-rotation.zip',
  'downloads/IconicRig.jar'
)

$bad = 0
foreach ($f in $files) {
  $url = $base + $f
  try {
    $r = Invoke-WebRequest -UseBasicParsing -Method Head $url -TimeoutSec 8
    Write-Output ($r.StatusCode.ToString() + "  " + $f)
  } catch {
    $code = 'ERR'
    if ($_.Exception.Response) { $code = [int]$_.Exception.Response.StatusCode }
    Write-Output ($code.ToString() + "  " + $f)
    $bad++
  }
}
Write-Output ("missing/unreachable: " + $bad + " of " + $files.Count)
