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
Write-Host "[+] Installing packages required for other workflows. git & python 3.13.3" -ForegroundColor Green
. "C:\ProgramData\chocolatey\choco.exe" install git -y --limitoutput
#. "C:\ProgramData\chocolatey\choco.exe" install python --version 3.13.3 -y --limitoutput
# Download and install Python 3.13.3 directly
$pythonUrl = "https://www.python.org/ftp/python/3.13.3/python-3.13.3-amd64.exe"
$pythonInstaller = "$env:TEMP\python-3.13.3-amd64.exe"
Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller
Write-Warning "Python is super slow to install!!! Gotta be patient."
. $pythonInstaller /passive InstallAllUsers=1 PrependPath=1 TargetDir="C:\Python313"

Write-Host "Installing Optional Packages" -ForegroundColor Green
Start-Process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File C:\temp\SandboxToolkit\scripts\4-Install-Optional-Packages.ps1"