 # SandboxToolkit

- ONLY RUN THIS IN A VOLATILE VM
- These deployment scripts offers no added security against malware escaping the environment. Use at your own risk and understand what you are executing prior to triggering a payload.
- This is a sandbox vm prep script to be run within Windows Sandbox vm. Will use 10-20 GB of Free Space and clear when completed.
- The intended purpose is for malware analysis
- Written shell messages will be shown for any manual setup steps requiring interaction. These will be presented during pauses in the script.
- The process may seems stuck at times, but it's not. Look for other windows requiring steps. Read the shell it might offer a clue.

## Installed Tools

- [DIE - Detect it Easy](https://github.com/horsicq/Detect-It-Easy)
- [Floss - FLARE Obfuscated String Solver](https://github.com/mandiant/flare-floss)
- [git](https://git-scm.com/)
- [Google Chrome](https://www.google.com/chrome/)
- [Lockhunter](https://lockhunter.com/)
- [PSPortable](https://github.com/TheTaylorLee/PSPortable)
- [Python](https://www.python.org/)
    - [pyWhat](https://github.com/bee-san/pyWhat)
- [Retoolkit](https://github.com/mentebinaria/retoolkit)
- [SysInternals](https://learn.microsoft.com/en-us/sysinternals/)
- [Thunderbird](https://www.thunderbird.net/)
- [Wireshark - winpcap](https://www.wireshark.org/)
- [vscode](https://code.visualstudio.com/)

# UnigetUI for installing minimal tools
If needing only a couple tools to examine a file, [UnigetUI](https://github.com/marticliment/UnigetUI) can be used to quickly install those.

```pwsh
$url = "https://github.com/marticliment/WingetUI/releases/latest/download/WingetUI.Installer.exe"
$outputPath = "$env:userprofile\downloads\WingetUI.Installer.exe"
Start-BitsTransfer -Source $url -Destination $outputPath
. $outputPath /silent
```

# How to Use SandboxToolkit as intended
- [Git Required](https://git-scm.com/downloads)
- Clone the Repository to the root of your c:\ and run the windows sandbox config file to launch windows sandbox configured.
- Optionally modify c:\SandboxToolkit\sandboxtoolkit.wsb with desired [parameters.](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-configure-using-wsb-file)

``` pwsh
set-location c:\
git clone https://github.com/TheTaylorLee/SandboxToolkit
```

### Update SanboxToolkit
```pwsh
set-location c:\Sandboxtoolkit
git pull
```