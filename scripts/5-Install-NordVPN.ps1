# Install VPN
Set-Location $env:userprofile\downloads
curl.exe https://downloads.nordcdn.com/apps/windows/NordVPN/latest/NordVPNSetup.exe --output vpn.exe
.\vpn.exe /SP- /VERYSILENT /NORESTART /FORCECLOSEAPPLICATIONS

# Connect  and Setup VPN for network isolation
Write-Warning "Wait for installs to complete then hit enter to continue through the pause!"
Pause
. "C:\Program Files\NordVPN\Nordvpn.exe"

Write-Host "Login to the VPN, set network isolation settings, connection > invisible on LAN, vpn killswitch, and disable threat protection!" -ForegroundColor Green

# Confirm Network is isolated
$gateway = Read-Host "Write your default gateway. Once it is not pinging your network should be isolated. ex: 192.168.2.1"
ping.exe $gateway -t