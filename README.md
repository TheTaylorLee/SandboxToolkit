 # SandboxToolkit

- This is a sandbox vm prep script to be run within windows sandbox vm. Will use 10-20 GB of Free Space and clear when completed.
- Read written shell messages for any manual setup steps requiring interaction. These will be presented during pauses in the script.
- Scripts are ordered in such a way as to avoid issues with any dependencies.
- THE PROCESS WILL AT TIMES SEEMS STUCK, BUT IT'S NOT.

## Installed Tools

- DIE - Detect it Easy (File analysis tool)
- Floss (A string deobfuscation and extraction tool)
- git (for cloning repos)
- Google Chrome (Alternative to edge which doesn't seem to work while the vpn is running in sandbox)
- lockhunter (force close running files)
- Nordvpn (vpn for network isolation)
- Oh-My-Posh (For the pwsh terminal)
- Python
    - What.exe https://github.com/bee-san/pyWhat (Can identity anything. Give it a pcap and let it find stuff)
    - Malware overview https://github.com/alexandreborges/malwoverview (A python tool that does a large overview of a file or set of files)
- Retoolkit https://github.com/mentebinaria/retoolkit/releases/tag/2022.10 (Malware Analysis tools)
- SysInternals (Large suite of microsoft tools)
- torbrowser (For security research of tor sites) IF FAILING PACKAGE INSTALL LINK MIGHT BE OUTDATED. NO GOOD FIX FOR THIS.
- Wireshark - winpcap (Packet Capturing)
- vscode (IDE)

# How to Use
- Run this in an Admin Powershell Window

```Powershell
Function Invoke-Deploy {
    # Opening Statement
    Write-Host "    READ THESE NOTES" -ForegroundColor Yellow
    Write-Host "
    1. After font install, set meslo font as the default font for the shell
    2. When all scripts finish running, it's best to close powershell, and use pwsh or shell of choice. This ensures all installed exe's are in path.
    3. When asked to pick a default browser choose Chrome. Useful if using Nordvpn.
    4. Be patient some steps take longer than others.
    5. When presented install wizards, click through
    " -ForegroundColor Green
    Pause

    # Clone repo and scripts for running
    Set-ExecutionPolicy Unrestricted -Confirm:$false -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    New-Item $env:userprofile\desktop\Github -itemtype directory | out-null
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/TheTaylorLee/SandboxToolkit/archive/refs/heads/master.zip', "$env:userprofile\desktop\github\SandboxToolkit.zip")
    Expand-Archive -Path $env:userprofile\desktop\github\SandboxToolkit.zip $env:userprofile\desktop\github\SandboxToolkit
    Remove-Item $env:userprofile\desktop\github\SandboxToolkit.zip -force | out-null

    #Runs scripts
    Write-Host "Running Install Scripts" -foregroundcolor Green
    start-process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File $env:userprofile\desktop\github\SandboxToolkit\SandboxToolkit-master\scripts\1-Install-PSPortable.ps1" -wait
    start-process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File $env:userprofile\desktop\github\SandboxToolkit\SandboxToolkit-master\scripts\2-Install-PackageManagers.ps1" -wait
    start-process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File $env:userprofile\desktop\github\SandboxToolkit\SandboxToolkit-master\scripts\3-Install-Packages.ps1"
    exit
}; Clear-Host; Invoke-Deploy
```