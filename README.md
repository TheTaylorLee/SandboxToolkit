# Sandbox-Toolkit

- This is a sandbox vm prep script to be run within windows sandbox vm. Will use 10-20 GB of Free Space and clear when completed.
- Read host written shell messages for any manual setup steps requiring interaction. These will be presented during pauses in the script.
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
- torbrowser (For security research of tor sites)
- Wireshark - winpcap (Packet Capturing)
- vscode (IDE)

# How to Use
- PUT IN A SECTION HERE THAT DOWNLOADS THE FILES

- Run this in an Admin Powershell Window
```Powershell
start-process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File $env:userprofile\Desktop\github\Sandbox-Toolkit\script\1-Install-PSPortable.ps1"
```