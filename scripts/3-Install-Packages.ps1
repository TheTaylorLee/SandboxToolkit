Start-Transcript "$env:userprofile\desktop\logs\3-Install-Packages.log"

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
Write-Host "[+] Unhiding extensions, files/folders, and protected files" -ForegroundColor Green
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Hidden /t REG_DWORD /d 1 /f
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSuperHidden /t REG_DWORD /d 1 /f
taskkill.exe /im explorer.exe /f
explorer.exe

# Install Fonts
Write-Host "[+] Installing Fonts" -ForegroundColor Green
. "C:\ProgramData\PS7x64\PS7-x64\profile_snippets\font\MesloLGMNerdFontMono-Regular.ttf"

#Install Detect it Easy (DIE)
Write-Host "[+] Downloading DIE - Detect it Easy" -ForegroundColor Green
(New-Object System.Net.WebClient).DownloadFile('https://github.com/horsicq/DIE-engine/releases/download/3.06/die_win64_qt6_portable_3.06.zip', "$env:userprofile\desktop\die_win64_qt6_portable_3.06.zip")
Invoke-Unzip -zipfile $env:userprofile\desktop\die_win64_qt6_portable_3.06.zip -outpath "$env:userprofile\desktop\Detect it Easy"
Remove-Item $env:userprofile\desktop\die_win64_qt6_portable_3.06.zip -Force

# Install Retoolkit
##Using .net method to download file because it's quicker and works with github
Write-Host "[+] Downloading Retoolkit" -ForegroundColor Green
(New-Object System.Net.WebClient).DownloadFile('https://github.com/mentebinaria/retoolkit/releases/download/2022.10/retoolkit_2022.10_setup.exe', "$env:userprofile\downloads\retoolkit_2022.10_setup.exe")
Write-Host "[+] Installing Retoolkit" -ForegroundColor Green
Start-Process $env:userprofile\downloads\retoolkit_2022.10_setup.exe -Wait
Remove-Item $env:userprofile\Desktop\cmd.lnk -Force

# Install Floss
Write-Host "[+] Downloading Floss" -ForegroundColor Green
(New-Object System.Net.WebClient).DownloadFile('https://github.com/mandiant/flare-floss/releases/download/v2.1.0/floss-v2.1.0-windows.zip', "$env:userprofile\desktop\floss-v2.1.0-windows.zip")
Invoke-Unzip -zipfile $env:userprofile\desktop\floss-v2.1.0-windows.zip -outpath "$env:userprofile\desktop\Floss"
Copy-Item $env:userprofile\desktop\Floss\floss.exe $env:systemroot\system32
Remove-Item "$env:userprofile\desktop\floss-v2.1.0-windows.zip" -Force

#Install Tools
Write-Host "[+] Installing git, Google Chrome, Oh-My-Posh, Lockhunter, python, sysinternals, vscode, and wireshark" -ForegroundColor Green
[string[]]$wingetlist = "Google Chrome", "JanDeDobbeleer.OhMyPosh", "lockhunter", "npcap", "sysinternals", "vscode"
foreach ($install in $wingetlist) {
    winget install $install --accept-package-agreements --accept-source-agreements
}
winget install thunderbird --accept-package-agreements --accept-source-agreements -s winget
. "C:\ProgramData\chocolatey\choco.exe" install  wireshark, git -y --limitoutput
. "C:\ProgramData\chocolatey\choco.exe" install python --version 3.11.0 -y --limitoutput
Copy-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Wireshark.lnk" $env:userprofile\desktop\Wireshark.lnk
Copy-Item "C:\Users\WDAGUtilityAccount\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk" $env:userprofile\desktop\VSCode.lnk

# Clone Repositories (Malwareoverview, ...)
# Important if changing directories to run py scripts to then change back to the github root folder
Write-Host "[+] Cloning malwareoverview" -ForegroundColor Green
Set-Location "$env:userprofile\desktop\github"
. "C:\Program Files\Git\bin\git.exe" clone https://github.com/alexandreborges/malwoverview

# Instructs to set python as default app
Write-Host "[+] Set Default Python App" -ForegroundColor Green
Write-Host "
You must set the file association for python right now.
    In the just opened explorer window right click a file with a .py extension and open it's properties.
    Change the default app to open with c:\python<X>\python.exe, and select always
    Then close that explorer window and continue through the pause
" -ForegroundColor Yellow
cmd /c start %windir%\explorer.exe $env:userprofile\desktop\github\malwoverview
Pause

# Install pywhat
Write-Host "[+] Installing pyWhat" -ForegroundColor Green
. "C:\Python311\Scripts\pip3.exe" install pywhat

# Install VPN
Write-Host "[+] Installing nordvpn" -ForegroundColor Green
Write-Warning "Wait for installs to complete then hit enter to continue through the pause!"
Set-Location $env:userprofile\downloads
curl.exe https://downloads.nordcdn.com/apps/windows/NordVPN/latest/NordVPNSetup.exe --output vpn.exe
.\vpn.exe /SP- /VERYSILENT /NORESTART /FORCECLOSEAPPLICATIONS
Write-Host "If using Nordvpn follow the below steps post instalation" -ForegroundColor Magenta
Write-Host "Login to the VPN, set network isolation settings, connection > invisible on LAN, vpn killswitch, and disable threat protection!" -ForegroundColor Green
Write-Host "Continue once vpn is connected" -ForegroundColor Green
Pause

# Closeing Statement
Write-Host "[+] Completed after the Nordvpn installer and setup is done. All open windows can now be closed and tools used" -ForegroundColor Green
Write-Host "
    To use malwoverview, open a new powershell window and run the following. If it doesn't run, then you didn't properly select the default python app to use in previous steps.
        Set-Location $env:userprofile\desktop\github\malwoverview
        .\setup.py build
        .\setup.py install
        Set-Location $env:userprofile\desktop\github\malwoverview\malwoverview
        .\malwoverview.py" -ForegroundColor Green
Pause
