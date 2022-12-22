# Set Execution Policy
Set-ExecutionPolicy Unrestricted -Confirm:$false -Force

# Install PSPortable
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(Invoke-WebRequest https://raw.githubusercontent.com/TheTaylorLee/PSPortable/master/Deploy-PSPortableLight.ps1 -UseBasicParsing).content | Invoke-Expression
install-psportable
exit