Start-Transcript $env:userprofile\desktop\logs\1-invoke-deploy.log

function Invoke-Deploy {

    # Opening Statement
    Write-Host "    READ THESE NOTES" -ForegroundColor Yellow
    Write-Host "
    1. When all scripts finish running, it's best to close powershell, and use pwsh or shell of choice. This ensures all installed exe's are in path.
    2. Be patient some steps take longer than others. Allow for the script to finish running.
    3. When presented install wizards or install choices interaction is required.
    " -ForegroundColor Green
    Pause

    # This is legacy code from switching to using wsb sandbox config files on date 20251016. consider delting in the future.
    # Clone repo and scripts for running
    # Set-ExecutionPolicy Unrestricted -Confirm:$false -Force
    # [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # New-Item $env:userprofile\desktop\Github -ItemType directory | Out-Null
    # (New-Object System.Net.WebClient).DownloadFile('https://github.com/TheTaylorLee/SandboxToolkit/archive/refs/heads/main.zip', "$env:userprofile\desktop\github\SandboxToolkit.zip")
    # Expand-Archive -Path $env:userprofile\desktop\github\SandboxToolkit.zip $env:userprofile\desktop\github\SandboxToolkit
    # Remove-Item $env:userprofile\desktop\github\SandboxToolkit.zip -Force | Out-Null

    #Runs scripts
    Start-Process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File C:\temp\SandboxToolkit\scripts\2-Install-PackageManagers.ps1"
    Write-Warning "Don't close this window until you have completed the instructions or you have read and understood them."
    Start-Sleep -Seconds 60
    Pause
}; Clear-Host; Invoke-Deploy