param([int]$Port = 8477)

# Starts the local static server for previewing the site, detached, and prints the PID.
$root = Split-Path -Parent $PSScriptRoot
$logDir = Join-Path $root '.freebuff'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$p = Start-Process -WindowStyle Hidden -PassThru -FilePath python `
  -ArgumentList '-m', 'http.server', $Port, '--bind', '127.0.0.1' `
  -WorkingDirectory $root `
  -RedirectStandardOutput (Join-Path $logDir 'server.out.log') `
  -RedirectStandardError  (Join-Path $logDir 'server.err.log')

Start-Sleep -Milliseconds 1200

try {
  $r = Invoke-WebRequest -UseBasicParsing ("http://127.0.0.1:" + $Port + "/index.html") -TimeoutSec 5
  Write-Output ("UP " + $r.StatusCode + " PID=" + $p.Id)
} catch {
  Write-Output ("STARTED-BUT-NO-RESPONSE PID=" + $p.Id)
}
