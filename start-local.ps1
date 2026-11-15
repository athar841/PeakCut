$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$ffmpeg = Get-ChildItem "$PSScriptRoot\.tools\ffmpeg" -Recurse -Filter ffmpeg.exe | Select-Object -First 1
if (-not $ffmpeg) { throw 'FFmpeg is not installed in .tools\ffmpeg.' }
$env:PATH = "$($ffmpeg.DirectoryName);$env:PATH"
$env:PEAKCUT_HOST = '127.0.0.1'
$env:PEAKCUT_PORT = '8765'
$env:PEAKCUT_PUBLIC_URL = 'http://127.0.0.1:8765'
$env:PEAKCUT_AUTO_RELOAD = '0'
& "$PSScriptRoot\.venv\Scripts\python.exe" -u -m studio.server
exit $LASTEXITCODE
