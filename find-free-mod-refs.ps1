# Lists every mention of the free mod / its download across the project, so a
# title swap can be checked for leftover references.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File tools/find-free-mod-refs.ps1

$root = (Get-Location).Path
$hits = Get-ChildItem -Path $root -Recurse -File -Include *.html,*.js,*.css,*.ps1,*.txt,*.md -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '\\(old-icons|node_modules|\.git|options)\\' } |
  Select-String -Pattern 'Gambling Rig|gambling-rig|IconicRig|Elytra Mod|free mod'

foreach ($h in $hits) {
  $rel = $h.Path.Substring($root.Length).TrimStart('\')
  Write-Output ("{0}:{1}: {2}" -f $rel, $h.LineNumber, $h.Line.Trim())
}
Write-Output ("--- {0} hit(s) ---" -f @($hits).Count)
