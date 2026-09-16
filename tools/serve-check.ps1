param([int]$Port = 8477)

try {
  $r = Invoke-WebRequest -UseBasicParsing ("http://127.0.0.1:" + $Port + "/index.html") -TimeoutSec 5
  Write-Output ("UP " + $r.StatusCode)
} catch {
  Write-Output "DOWN"
}

try {
  $p = (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction Stop | Select-Object -First 1).OwningProcess
  Write-Output ("PID=" + $p)
} catch {
  Write-Output "PID=none"
}
