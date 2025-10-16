New-Item $env:userprofile\desktop\logs -ItemType Directory
Start-Transcript $env:userprofile\desktop\logs\0-DeployFunction.log
function Invoke-Deploy {

    # Opening Statement
    Write-Host "    READ THESE NOTES" -ForegroundColor Yellow
    Write-Host "
    1. When all scripts finish running, it's best to close powershell, and use pwsh or shell of choice. This ensures all installed exe's are in path.
    2. If asked to pick a default browser choose Chrome. Useful if using Nordvpn.
    3. Be patient some steps take longer than others. If you hit enter after pasting in the launch windows, you risk skipping required steps by inserting null responses.
    4. When presented install wizards or install choices interaction is required.
    " -ForegroundColor Green
    Pause

    # Clone repo and scripts for running
    Set-ExecutionPolicy Unrestricted -Confirm:$false -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    New-Item $env:userprofile\desktop\Github -ItemType directory | Out-Null
    (New-Object System.Net.WebClient).DownloadFile('https://github.com/TheTaylorLee/SandboxToolkit/archive/refs/heads/main.zip', "$env:userprofile\desktop\github\SandboxToolkit.zip")
    Expand-Archive -Path $env:userprofile\desktop\github\SandboxToolkit.zip $env:userprofile\desktop\github\SandboxToolkit
    Remove-Item $env:userprofile\desktop\github\SandboxToolkit.zip -Force | Out-Null

    #Runs scripts
    Write-Host "Running Install Scripts" -ForegroundColor Green
    Start-Process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File $env:userprofile\desktop\github\SandboxToolkit\SandboxToolkit-main\scripts\1-Install-PackageManagers.ps1" -Wait
    Start-Process "powershell.exe" -ArgumentList "-executionpolicy unrestricted", "-File $env:userprofile\desktop\github\SandboxToolkit\SandboxToolkit-main\scripts\2-Install-Packages.ps1"
    Write-Warning "Don't close this window until you have completed the instructions or you have read and remebered them."
}; Clear-Host; Invoke-Deploy