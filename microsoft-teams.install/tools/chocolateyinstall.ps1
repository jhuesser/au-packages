﻿$ErrorActionPreference = 'Stop';

$packageName= 'microsoft-teams.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32      = 'https://statics.teams.cdn.office.net/production-windows/1.7.00.27757/Teams_windows.msi'
$url64      = 'https://statics.teams.cdn.office.net/production-windows-x64/1.7.00.27757/Teams_windows_x64.msi'
$checksum32 = '76f211a4daa79d86905955e0bee2b06b2fc4f201221d4c36f26d3bf4c1d4331a'
$checksum64 = '7707396641c0db052f4917552cfefc1b4127f6fc9323c9f9f1ec67b89526fda8'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url32
  url64bit      = $url64

  softwareName  = 'Teams Machine-Wide Installer'

  checksum      = $checksum32
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

$pp = Get-PackageParameters

if ($pp['NoAutoStart']) {
  $packageArgs.silentArgs += ' OPTIONS="noAutoStart=true"'
}

if ($pp['AllUsers']) {
  $packageArgs.silentArgs += ' ALLUSERS=1'
}

#Machine Wide installaer VDI/WVD
if ($pp['AllUser']) {
  $packageArgs.silentArgs += ' ALLUSER=1'
  reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f
}

Install-ChocolateyPackage @packageArgs
