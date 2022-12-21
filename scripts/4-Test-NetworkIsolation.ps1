Write-Host "Login to the VPN, set network isolation settings, connection > invisible on LAN, vpn killswitch, and disable threat protection!" -ForegroundColor Green

# Confirm Network is isolated
$gateway = Read-Host "Write your default gateway. Once it is not pinging your network should be isolated. ex: 192.168.2.1"
ping.exe $gateway -t