# Run after `dart run flutter_native_splash:create` to avoid ~4MB of duplicate splash PNGs.
# Keeps one copy in drawable-nodpi; Android scales it for all densities.
$ErrorActionPreference = 'Stop'
$res = Join-Path $PSScriptRoot '..\android\app\src\main\res'
$nodpi = Join-Path $res 'drawable-nodpi'
New-Item -ItemType Directory -Force -Path $nodpi | Out-Null

$src = Join-Path $res 'drawable-xxxhdpi'
foreach ($name in @('splash.png', 'android12splash.png')) {
  $from = Join-Path $src $name
  if (Test-Path $from) {
    Copy-Item $from (Join-Path $nodpi $name) -Force
  }
}

$bg = Join-Path $res 'drawable\background.png'
if (Test-Path $bg) {
  Copy-Item $bg (Join-Path $nodpi 'background.png') -Force
}

Get-ChildItem $res -Recurse -Include 'splash.png', 'android12splash.png' |
  Where-Object { $_.DirectoryName -notlike "*\drawable-nodpi" } |
  Remove-Item -Force

Write-Host 'Splash drawables trimmed to drawable-nodpi only.'
