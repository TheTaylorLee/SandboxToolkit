[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Winget
$ProgressPreference = 'Silent'
(New-Object System.Net.WebClient).DownloadFile('https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle', "$env:userprofile\downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle")
(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', "$env:userprofile\downloads\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Set-Location $env:userprofile\downloads
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle

#Chocolately
$downloadUrl = 'https://chocolatey.org/install.ps1'
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($downloadUrl))
Exit