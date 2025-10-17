Start-Transcript "$env:userprofile\desktop\logs\2-Install-PackageManagers.log"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Winget
$ProgressPreference = 'Silent'
(New-Object System.Net.WebClient).DownloadFile('https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3', "$env:userprofile\downloads\microsoft.ui.xaml.2.7.3.zip")
(New-Object System.Net.WebClient).DownloadFile('https://github.com/microsoft/winget-cli/releases/download/v1.6.3482/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle', "$env:userprofile\downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle")
(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', "$env:userprofile\downloads\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Set-Location $env:userprofile\downloads
Expand-Archive -Path "$env:userprofile\downloads\microsoft.ui.xaml.2.7.3.zip" -DestinationPath "$env:userprofile\downloads\microsoft.ui.xaml.2.7.3"
Add-AppxPackage -Path "$env:userprofile\downloads\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle

#Chocolately
$downloadUrl = 'https://chocolatey.org/install.ps1'
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($downloadUrl))

Write-Host "[+] Installing Required Packages" -ForegroundColor Green
Start-Process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File C:\temp\SandboxToolkit\scripts\3-setup-required-changes.ps1"