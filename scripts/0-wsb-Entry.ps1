New-Item $env:userprofile\desktop\logs -ItemType Directory
Start-Transcript $env:userprofile\desktop\logs\0-wsb-entry.log
Start-Process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File C:\temp\SandboxToolkit\scripts\1-invoke-deploy.ps1" -Wait