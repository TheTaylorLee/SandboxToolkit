Start-Transcript "$env:userprofile\desktop\logs\4-Install-Optional-Packages.log"

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

# Instructs to set python as default app
Write-Host "[+] Set Default Python App" -ForegroundColor Green
Write-Host "
You must set the file association for python right now.
    In the just opened explorer window right click default.py extension open it's properties.
    Change the default app to open with c:\python313\python.exe, and select always
    Then close that explorer window and continue through the pause
" -ForegroundColor Yellow
cmd /c start %windir%\explorer.exe C:\temp\SandboxToolkit\
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
Write-Host "    10. PSPortable - Portable PS7 with useful modules" -ForegroundColor Cyan
Write-Host "    11. Google Chrome - Some People Prefer it." -ForegroundColor Cyan
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
        #winget install "lockhunter" --accept-package-agreements --accept-source-agreements
        . "C:\ProgramData\chocolatey\choco.exe" install lockhunter -y --limitoutput --ignore-checksums
    }
    { $_ -contains '5' -or $_ -contains '0' } {
        Write-Host "[+] Installing sysinternals" -ForegroundColor Green
        #winget install "Microsoft.Sysinternals" --accept-package-agreements --accept-source-agreements
        . "C:\ProgramData\chocolatey\choco.exe" install Sysinternals -y --limitoutput --ignore-checksums
    }
    { $_ -contains '6' -or $_ -contains '0' } {
        Write-Host "[+] Installing vscode" -ForegroundColor Green
        #winget install "vscode" --accept-package-agreements --accept-source-agreements
        . "C:\ProgramData\chocolatey\choco.exe" install vscode -y --limitoutput --ignore-checksums
        Copy-Item "C:\Users\WDAGUtilityAccount\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Visual Studio Code\Visual Studio Code.lnk" $env:userprofile\desktop\VSCode.lnk
    }
    { $_ -contains '7' -or $_ -contains '0' } {
        Write-Host "[+] Installing wireshark" -ForegroundColor Green
        winget install "npcap" --accept-package-agreements --accept-source-agreements -s winget
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
        . "C:\Python313\Scripts\pip3.exe" install pywhat
    }
    { $_ -contains '10' -or $_ -contains '0' } {
        Write-Host "[+] Installing PSPortable" -ForegroundColor Green
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        (Invoke-WebRequest https://raw.githubusercontent.com/TheTaylorLee/PSPortable/main/Deploy-PSPortableLight.ps1 -UseBasicParsing).content | Invoke-Expression
        Copy-Item "C:\ProgramData\PS7x64\PS7-x64\pwsh.exe.lnk" "$env:userprofile\desktop\pwsh.exe.lnk"
        taskkill.exe /im pwsh.exe /f
    }
    { $_ -contains '11' -or $_ -contains '0' } {
        Write-Host "[+] Installing Google Chrome" -ForegroundColor Green
        winget install  "Google.Chrome" --accept-package-agreements --accept-source-agreements -s winget
    }
    { $_ -contains '12' -or $_ -contains '0' } {
        # Clone Repositories (Malwareoverview, ...)
        Write-Host "[+] Cloning malwareoverview" -ForegroundColor Green
        Set-Location "$env:userprofile\desktop"
        . "C:\Program Files\Git\bin\git.exe" clone https://github.com/alexandreborges/malwoverview

        Write-Host "
        To use malwoverview, open a new powershell window and run the following. If it doesn't run, then you didn't properly select the default python app to use in previous steps.
        Set-Location $env:userprofile\desktop\malwoverview
        .\setup.py build
        .\setup.py install
        Set-Location $env:userprofile\desktop\malwoverview\malwoverview
        .\malwoverview.py" -ForegroundColor Green
    }
}

# Closeing Statement
Write-Warning "If desired this script can be launched agains from PowerShell by dotsourcing. eg. . C:\temp\SandboxToolkit\scripts\4-Install-Optional-Packages.ps1"
Write-Host "[+] Completed installers and setup is done. All open windows can now be closed and tools used" -ForegroundColor Green
Pause
