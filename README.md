 # SandboxToolkit

- ONLY RUN THIS IN A VOLATILE VM
- These deployment scripts offers no added security against malware escaping the environment. Use at your own risk and understand what you are executing prior to triggering a payload.
- This is a sandbox vm prep script to be run within Windows Sandbox vm. Will use 10-20 GB of Free Space and clear when completed.
- The intended purpose is for malware analysis
- Written shell messages will be shown for any manual setup steps requiring interaction. These will be presented during pauses in the script.
- Scripts are ordered in such a way as to avoid issues with any dependencies.
- The process may seems stuck at times, but it's not. Look for other windows requiring steps. Read the shell it might offer a clue.

## Installed Tools

- [DIE - Detect it Easy](https://github.com/horsicq/Detect-It-Easy)
- [Floss - FLARE Obfuscated String Solver](https://github.com/mandiant/flare-floss)
- [git](https://git-scm.com/)
- [Google Chrome](https://www.google.com/chrome/)
- [Lockhunter](https://lockhunter.com/)
- [Nordvpn](https://nordvpn.com/nord-deal-site/)
- [Oh-My-Posh](https://ohmyposh.dev/)
- [Python](https://www.python.org/)
    - [pyWhat](https://github.com/bee-san/pyWhat)
    - [Malwareoverview](https://github.com/alexandreborges/malwoverview)
- [Retoolkit](https://github.com/mentebinaria/retoolkit)
- [SysInternals](https://learn.microsoft.com/en-us/sysinternals/)
- [Wireshark - winpcap](https://www.wireshark.org/)
- [vscode](https://code.visualstudio.com/)

# How to Use
- Run this in an Admin Powershell Window

```Powershell
New-Item $env:userprofile\desktop\logs -itemtype Directory
Start-Transcript $env:userprofile\desktop\logs\0-DeployFunction.log
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
