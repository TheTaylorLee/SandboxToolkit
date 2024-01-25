Start-Transcript "$env:userprofile\desktop\logs\1-Install-PSPortable.log"

# Set Execution Policy
Set-ExecutionPolicy Unrestricted -Confirm:$false -Force

# Install PSPortable
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(Invoke-WebRequest https://raw.githubusercontent.com/TheTaylorLee/PSPortable/main/Deploy-PSPortableLight.ps1 -UseBasicParsing).content | Invoke-Expression
Copy-Item "C:\ProgramData\PS7x64\PS7-x64\pwsh.exe.lnk" "$env:userprofile\desktop\pwsh.exe.lnk"
taskkill.exe /im pwsh.exe /f
exit