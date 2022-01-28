. $PSScriptRoot\windows\SetupWSL.ps1
. $PSScriptRoot\windows\Chocolatey.ps1
. $PSScriptRoot\windows\SetupWindowsEnv.ps1
. $PSScriptRoot\windows\RefreshEnvPath.ps1

#
# WSL Setup
#

Write-Host "Checking if WSL is installed..."
$rebootRequired = $false
if(Is-WslInstalled){
    Write-Host "WSL is already installed. Skipping this step..."
}else{
    Write-Host "Installing WSL..."
    $rebootRequired = Install-WSL
}

if($rebootRequired){
    Write-Host "Reboot required to finish installation"
    $reboot = Read-Host "Reboot now? (you still need to reboot and rerun later to finish installing WSL2) [y/N]"
    if ($reboot.Length -ne 0){
        if ($reboot.Substring(0,1).ToLower() -eq 'y'){
            shutdown /t 10 /r /c "Restarting"
        }else{
            Write-Host "Shutdown aborted"
            shutdown /a
        }
    }
}


#
# Windows Setup
#

Write-Host "Updating Windows Explorer settings"
Set-WindowsSettings
RefreshEnvPath

Write-Host "Installing Chocolatey"
Install-Chocolatey
RefreshEnvPath

Write-Host "Choco version"
Choco-Version


#
# Tools Setup
#

# git
Install-FromChocolatey 'git'

# dotnet
Install-FromChocolatey 'dotnetcore-sdk'
Install-FromChocolatey 'dotnet-sdk'

Install-FromChocolatey 'vscode-insiders'
Install-FromChocolatey 'visualstudio2022enterprise'

Install-FromChocolatey 'docker-cli'
Install-FromChocolatey 'microsoft-windows-terminal'
Install-FromChocolatey 'fiddler'
Install-FromChocolatey 'postman'
Install-FromChocolatey 'linqpad'
Install-FromChocolatey 'drawio'
Install-FromChocolatey 'firefox'
Install-FromChocolatey 'googlechrome'
Install-FromChocolatey 'powershell-core'

RefreshEnvPath