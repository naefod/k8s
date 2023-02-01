﻿(Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Version # get the Microsoft .NET Framework 


function devpack-installed ($version) {
  if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where {$_.DisplayName -eq "Microsoft .NET Framework $($version) Developer Pack"}) {
    return $true
  }
}

#needed for 4.5.2 which has different naming convention
function multitargetingpack-installed ($version) {
  if (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where {$_.DisplayName -eq "Microsoft .NET Framework $($version) Multi-Targeting Pack"}) {
    return $true
  }
}



function install-devpack ($version, $location) {
  if (devpack-installed -version $version) {
    Write-Host ".NET Framework $($version) Developer Pack already installed." -ForegroundColor Cyan
  }
  elseif (multitargetingpack-installed -version $version) {
    Write-Host ".NET Framework $($version) Multi-Targeting Pack already installed." -ForegroundColor Cyan
  }
  else {
    Write-Host ".NET Framework $($version) Developer Pack..." -ForegroundColor Cyan
    Write-Host "Downloading..."
    $exePath = "$env:TEMP\$($version)-devpack.exe"
    (New-Object Net.WebClient).DownloadFile($location, $exePath)
    Write-Host "Installing..."
    cmd /c start /wait "$exePath" /quiet /norestart
    Remove-Item $exePath -Force -ErrorAction Ignore
    Write-Host "Installed" -ForegroundColor Green
  }
}

install-devpack -version "4.8" -location "https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/c8c829444416e811be84c5765ede6148/ndp48-devpack-enu.exe"
