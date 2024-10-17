Start-Transcript "$env:userprofile\desktop\logs\3-Install-Packages.log"

# Set Execution Policy
Set-ExecutionPolicy Unrestricted -Confirm:$false -Force

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

# Tls settings
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Configure explorer view
Write-Host "[+] Unhiding extensions, files/folders, and protected files so malware can't hide using those methods." -ForegroundColor Green
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden /t REG_DWORD /d 1 /f
taskkill.exe /im explorer.exe /f
explorer.exe

# Install required software for multipile tools.
Write-Host "[+] Installing packages required for other workflows. Chrome, git & python 3.11" -ForegroundColor Green
. "C:\ProgramData\chocolatey\choco.exe" install git -y --limitoutput
. "C:\ProgramData\chocolatey\choco.exe" install python --version 3.11.0 -y --limitoutput
winget install  "Google.Chrome" --accept-package-agreements --accept-source-agreements

# Instructs to set python as default app
Write-Host "[+] Set Default Python App" -ForegroundColor Green
Write-Host "
You must set the file association for python right now.
    In the just opened explorer window right click default.py extension open it's properties.
    Change the default app to open with c:\python311\python.exe, and select always
    Then close that explorer window and continue through the pause
" -ForegroundColor Yellow
cmd /c start %windir%\explorer.exe $env:userprofile\desktop\github\SandboxToolkit\SandboxToolkit-main
Pause

# Install Application Choices
Write-Host "Select the applications you want to install (separate choices with commas):" -ForegroundColor Magenta
Write-Host "    0. All - select this option to install all analysis tools in the sanbox" -ForegroundColor Cyan
Write-Host "    1. Detect It Easy - Provides Mime, Hash, Hex, String, and PE File Analysis" -ForegroundColor Cyan
Write-Host "    2. Retoolkit - Provides many reverse engineering tools" -ForegroundColor Cyan
Write-Host "    3. Floss - FLARE Obfuscated String Solver" -ForegroundColor Cyan
Write-Host "    4. Lockhunter - Unlock files in use by other processes" -ForegroundColor Cyan
Write-Host "    5. Sysinternals - Windows system utilities" -ForegroundColor Cyan
Write-Host "    6. VSCode - Visual Studio Code editor" -ForegroundColor Cyan
Write-Host "    7. Wireshark - Network protocol analyzer" -ForegroundColor Cyan
Write-Host "    8. Mozilla Thunderbird - Email client for safely viewing malicious emails in sandbox" -ForegroundColor Cyan
Write-Host "    9. pyWhat - Identify what obscure strings are. Not just code" -ForegroundColor Cyan
Write-Host "    10. NordVPN - VPN for not leaking your IP address when analyzing malware" -ForegroundColor Cyan
Write-Host "    11. PSPortable - Portable PS7 with useful modules" -ForegroundColor Cyan
Write-Host "    12. Malwoverview - First response hash and behavioral analysis" -ForegroundColor Cyan
Write-Host " "

# Read user input
$userInput = Read-Host "Enter your choices (e.g., 1,3)"

# Split the input into an array
$choices = $userInput -split ','

# Check each choice and perform the corresponding action
switch -Wildcard ($choices) {
    { $_ -contains '1' -or $_ -contains '0' } {
        #Install Detect it Easy (DIE)
        Write-Host "[+] Downloading DIE - Detect it Easy" -ForegroundColor Green
        (New-Object System.Net.WebClient).DownloadFile('https://github.com/horsicq/DIE-engine/releases/download/3.06/die_win64_qt6_portable_3.06.zip', "$env:userprofile\desktop\die_win64_qt6_portable_3.06.zip")
        Invoke-Unzip -zipfile $env:userprofile\desktop\die_win64_qt6_portable_3.06.zip -outpath "$env:userprofile\desktop\Detect it Easy"
        Remove-Item $env:userprofile\desktop\die_win64_qt6_portable_3.06.zip -Force
    }
    { $_ -contains '2' -or $_ -contains '0' } {
        # Install Retoolkit
        Write-Host "[+] Downloading Retoolkit" -ForegroundColor Green
        (New-Object System.Net.WebClient).DownloadFile('https://github.com/mentebinaria/retoolkit/releases/download/2022.10/retoolkit_2022.10_setup.exe', "$env:userprofile\downloads\retoolkit_2022.10_setup.exe")
        Write-Host "[+] Installing Retoolkit" -ForegroundColor Green
        Start-Process $env:userprofile\downloads\retoolkit_2022.10_setup.exe -Wait
        Remove-Item $env:userprofile\Desktop\cmd.lnk -Force
    }
    { $_ -contains '3' -or $_ -contains '0' } {
        # Install Floss
        Write-Host "[+] Downloading Floss" -ForegroundColor Green
        (New-Object System.Net.WebClient).DownloadFile('https://github.com/mandiant/flare-floss/releases/download/v2.1.0/floss-v2.1.0-windows.zip', "$env:userprofile\desktop\floss-v2.1.0-windows.zip")
        Invoke-Unzip -zipfile $env:userprofile\desktop\floss-v2.1.0-windows.zip -outpath "$env:userprofile\desktop\Floss"
        Copy-Item $env:userprofile\desktop\Floss\floss.exe $env:systemroot\system32
        Remove-Item "$env:userprofile\desktop\floss-v2.1.0-windows.zip" -Force
    }
    { $_ -contains '4' -or $_ -contains '0' } {
        Write-Host "[+] Installing Lockhunter" -ForegroundColor Green
        winget install "lockhunter" --accept-package-agreements --accept-source-agreements
    }
    { $_ -contains '5' -or $_ -contains '0' } {
        Write-Host "[+] Installing sysinternals" -ForegroundColor Green
        winget install "Microsoft.Sysinternals" --accept-package-agreements --accept-source-agreements
    }
    { $_ -contains '6' -or $_ -contains '0' } {
        Write-Host "[+] Installing vscode" -ForegroundColor Green
        winget install "vscode" --accept-package-agreements --accept-source-agreements
        Copy-Item "C:\Users\WDAGUtilityAccount\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk" $env:userprofile\desktop\VSCode.lnk
    }
    { $_ -contains '7' -or $_ -contains '0' } {
        Write-Host "[+] Installing wireshark" -ForegroundColor Green
        winget install "npcap" --accept-package-agreements --accept-source-agreements
        . "C:\ProgramData\chocolatey\choco.exe" install  wireshark -y --limitoutput
        Copy-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Wireshark.lnk" $env:userprofile\desktop\Wireshark.lnk
    }
    { $_ -contains '8' -or $_ -contains '0' } {
        Write-Host "[+] Installing Mozilla Thunderbird" -ForegroundColor Green
        winget install "Mozilla Thunderbird (en-US)" --accept-package-agreements --accept-source-agreements -s winget
    }
    { $_ -contains '9' -or $_ -contains '0' } {
        # Install pywhat
        Write-Host "[+] Installing pyWhat" -ForegroundColor Green
        . "C:\Python311\Scripts\pip3.exe" install pywhat
    }
    { $_ -contains '10' -or $_ -contains '0' } {
        Write-Host "[+] Installing nordvpn" -ForegroundColor Green
        Write-Warning "Wait for installs to complete then hit enter to continue through the pause!"
        Set-Location $env:userprofile\downloads
        (New-Object System.Net.WebClient).DownloadFile('https://downloads.nordcdn.com/apps/windows/NordVPN/latest/NordVPNSetup.exe', "$env:userprofile\downloads\vpn.exe")
        .\vpn.exe /SP- /VERYSILENT /NORESTART /FORCECLOSEAPPLICATIONS
        Write-Host "If using Nordvpn follow the below steps post installation" -ForegroundColor Magenta
        Write-Host "Login to the VPN, set network isolation settings, connection > invisible on LAN, vpn killswitch, and disable threat protection!" -ForegroundColor Green
        Write-Host "Continue once vpn is connected" -ForegroundColor Green
        Pause
    }
    { $_ -contains '11' -or $_ -contains '0' } {
        Write-Host "[+] Installing PSPortable" -ForegroundColor Green
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        (Invoke-WebRequest https://raw.githubusercontent.com/TheTaylorLee/PSPortable/main/Deploy-PSPortableLight.ps1 -UseBasicParsing).content | Invoke-Expression
        Copy-Item "C:\ProgramData\PS7x64\PS7-x64\pwsh.exe.lnk" "$env:userprofile\desktop\pwsh.exe.lnk"
        taskkill.exe /im pwsh.exe /f
    }
    { $_ -contains '12' -or $_ -contains '0' } {
        # Clone Repositories (Malwareoverview, ...)
        Write-Host "[+] Cloning malwareoverview" -ForegroundColor Green
        Set-Location "$env:userprofile\desktop\github"
        . "C:\Program Files\Git\bin\git.exe" clone https://github.com/alexandreborges/malwoverview

        Write-Host "
        To use malwoverview, open a new powershell window and run the following. If it doesn't run, then you didn't properly select the default python app to use in previous steps.
        Set-Location $env:userprofile\desktop\github\malwoverview
        .\setup.py build
        .\setup.py install
        Set-Location $env:userprofile\desktop\github\malwoverview\malwoverview
        .\malwoverview.py" -ForegroundColor Green
    }
}

# Closeing Statement
Write-Host "[+] Completed installers and setup is done. All open windows can now be closed and tools used" -ForegroundColor Green
Pause