. $PSScriptRoot\windows\SetupWSL.ps1
. $PSScriptRoot\windows\Chocolatey.ps1


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

Choco-Version

#
# Functions
#

function RefreshEnvPath
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") `
        + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Push-User-Path($userPath) {
    $path = [Environment]::GetEnvironmentVariable('Path', 'User')
    $newpath = "$userPath;$path"
    [Environment]::SetEnvironmentVariable("Path", $newpath, 'User')
    Update-Environment-Path
}

function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Install-FromChocolatey {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $PackageName
    )

    choco install $PackageName --yes
}


#
# Setup
#

# choco
Install-Chocolatey
RefreshEnvPath

# git
Install-FromChocolatey 'git'
