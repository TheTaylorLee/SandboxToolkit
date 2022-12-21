# 1.
# RUN IN POWERSHELL
function install-psportable {
    # Set Execution Policy
    Set-ExecutionPolicy Unrestricted -Confirm:$false -Force

    # Install PSPortable
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    (Invoke-WebRequest https://raw.githubusercontent.com/TheTaylorLee/PSPortable/master/Deploy-PSPortable.ps1 -UseBasicParsing).content | Invoke-Expression
}; install-psportable

# 2.
# RUN IN POWERSHELL 5 - Allow to complete prior to next steps
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'Silent'
(New-Object System.Net.WebClient).DownloadFile('https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle', "$env:userprofile\downloads\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle")
(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', "$env:userprofile\downloads\Microsoft.VCLibs.x64.14.00.Desktop.appx")
Set-Location $env:userprofile\downloads
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle

# 3.
# RUN IN POWERSHELL 5 or deal with psreadline issues. Can use same window as step 2
Start-Transcript "$env:userprofile\desktop\ENV Setup Log.Log"
function Invoke-WindowsSandboxInstalls {

    function Invoke-Unzip {
        <#
    .DESCRIPTION
    Provides robust zip file extraction by attempting 3 possible methods.

    .Parameter zipfile
    Specify the zipfile location and name

    .Parameter outpath
    Specify the extract path for extracted files

    .EXAMPLE
    Extracts folder.zip to c:\folder

    Invoke-Unzip -zipfile c:\folder.zip -outpath c:\folder

    .Link
    https://github.com/TheTaylorLee/AdminToolbox
    #>

        [cmdletbinding()]
        param(
            [string]$zipfile,
            [string]$outpath
        )

        if (Get-Command expand-archive -ErrorAction silentlycontinue) {
            $ErrorActionPreference = 'SilentlyContinue'
            Expand-Archive -Path $zipfile -DestinationPath $outpath
            $ErrorActionPreference = 'Continue'
        }



        else {
            try {
                #Allows for unzipping folders in older versions of powershell if .net 4.5 or newer exists
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
            }

            catch {
                #If .net 4.5 or newer not present, com classes are used. This process is slower.
                [void] (New-Item -Path $outpath -ItemType Directory -Force)
                $Shell = New-Object -com Shell.Application
                $Shell.Namespace($outpath).copyhere($Shell.NameSpace($zipfile).Items(), 4)
            }
        }
    }

    # Instructions
    Write-Host "READ THESE INSTRUCTIONS" -ForegroundColor Magenta
    Write-Host "1. After font install, set meslo font as the default font for the shell" -ForegroundColor Green
    Write-Host "2. When the function finishes running, it's best to restart close powershell, open ps7x64, and to have all installed software loaded in path" -ForegroundColor yellow
    Write-Host "3. When prompted to select a Python app be sure to select the app located at c:\python<X>\python.exe" -ForegroundColor Yellow
    Write-Host "4. When asked to pick a default browser choose Chrome. Useful if using Nordvpn." -ForegroundColor Cyan
    Pause

    # Set Execution Policy and TLS version
    Set-ExecutionPolicy Unrestricted -Confirm:$false -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # OH-MY-PWSH FONT INSTALL
    . "C:\ProgramData\PS7x64\PS7-x64\profile_snippets\font\Meslo LG M Regular Nerd Font Complete Mono.ttf"

    # Install Chocolatey
    $downloadUrl = 'https://chocolatey.org/install.ps1'
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($downloadUrl))

    #Install Detect it Easy (DIE)
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/horsicq/DIE-engine/releases/download/3.06/die_win64_qt6_portable_3.06.zip', "$env:userprofile\desktop\die_win64_qt6_portable_3.06.zip")
    Invoke-Unzip -zipfile $env:userprofile\desktop\die_win64_qt6_portable_3.06.zip -outpath "$env:userprofile\desktop\Detect it Easy"
    Remove-Item $env:userprofile\desktop\die_win64_qt6_portable_3.06.zip -Force

    # Install Retoolkit
    ##Using .net method to download file because it's quicker and works with github
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/mentebinaria/retoolkit/releases/download/2022.10/retoolkit_2022.10_setup.exe', "$env:userprofile\downloads\retoolkit_2022.10_setup.exe")
    Start-Process $env:userprofile\downloads\retoolkit_2022.10_setup.exe -Wait
    Remove-Item $env:userprofile\Desktop\cmd.lnk -Force

    # Install Floss
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/mandiant/flare-floss/releases/download/v2.1.0/floss-v2.1.0-windows.zip', "$env:userprofile\desktop\floss-v2.1.0-windows.zip")
    Invoke-Unzip -zipfile $env:userprofile\desktop\floss-v2.1.0-windows.zip -outpath "$env:userprofile\desktop\Floss"
    Copy-Item $env:userprofile\desktop\Floss\floss.exe $env:systemroot\system32
    Remove-Item "$env:userprofile\desktop\floss-v2.1.0-windows.zip" -Force

    #Install Tools
    [string[]]$wingetlist = "lockhunter", "Google Chrome", "wireshark", "vscode", "JanDeDobbeleer.OhMyPosh"
    foreach ($install in $wingetlist) {
        winget install $install --accept-package-agreements --accept-source-agreements
    }
    choco install winpcap, sysinternals, git, tor-browser -y
    choco install python --version 3.11.0 -y
    Copy-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Wireshark.lnk" $env:userprofile\desktop\Wireshark.lnk
    Copy-Item "C:\Users\WDAGUtilityAccount\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk" $env:userprofile\desktop\VSCode.lnk

    # Install pywhat
    . "C:\Python311\Scripts\pip3.exe" install pywhat

    # Clone Repositories (Malwareoverview, ...)
    # Important if changing directories to run py scripts to then change back to the github root folder
    New-Item $env:userprofile\desktop\github -ItemType Directory
    Set-Location "$env:userprofile\desktop\github"
    . "C:\Program Files\Git\bin\git.exe" clone https://github.com/alexandreborges/malwoverview
    Set-Location $env:userprofile\desktop\github\malwoverview
    .\setup.py build
    .\setup.py install
    Set-Location "$env:userprofile\desktop\github"
    Write-Host "To use malwareoverview check out the website. The build is already been completed, so it's just a matter of using the $env:userprofile\desktop\github\malwoverview\malwareoverview\malwareoverview.py script now!" -ForegroundColor Green
    Pause

    # Install VPN
    Set-Location $env:userprofile\desktop
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
}; Clear-Host; Invoke-WindowsSandboxInstalls; Stop-Transcript