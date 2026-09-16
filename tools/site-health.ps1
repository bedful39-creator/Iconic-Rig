param([int]$StrayPort = 8477, [int]$LivePort = 8478)

# Kill the stray duplicate server (if it's still running) and confirm the
# live preview server is serving this site's packs page.
try {
  $stray = (Get-NetTCPConnection -LocalPort $StrayPort -State Listen -ErrorAction Stop | Select-Object -First 1).OwningProcess
  if ($stray) { Stop-Process -Id $stray -Force -ErrorAction SilentlyContinue; Write-Output ("KILLED-STRAY PID=" + $stray) }
} catch { Write-Output "NO-STRAY" }

try {
  $r = Invoke-WebRequest -UseBasicParsing ("http://127.0.0.1:" + $LivePort + "/packs.html") -TimeoutSec 5
  Write-Output ("PACKS " + $r.StatusCode + " iconic-rig=" + ($r.Content -match 'Iconic Rig'))

  $j = Invoke-WebRequest -UseBasicParsing ("http://127.0.0.1:" + $LivePort + "/main.js") -TimeoutSec 5
  Write-Output ("MAINJS packs-listed=" + ([regex]::Matches($j.Content, 'Green Glass to Spawner').Count))
} catch {
  Write-Output "LIVE-SERVER-DOWN"
}
