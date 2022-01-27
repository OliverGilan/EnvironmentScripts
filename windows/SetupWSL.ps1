# Returns true if wsl is enabled for current machine
function Is-WslInstalled {
    if ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq 'Enabled'){
        return $true
    }else{
        return $false
    }
}

# Returns true if VirtualMachinePlatform is enabled
function Is-VirtualMachinePlatformInstalled {
    if ((Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq 'Enabled'){
        return $true
    }
}

# Installs WSL
# Returns true because restart is required
function Install-Wsl{
    param(
        [string]
        [Parameter(Mandatory = $false)]
        $DistributionName
    )
    if ($DistributionName){
        wsl --install -d $DistributionName
    }else{
        wsl --install
    }
    return $true;
}

# Legacy function
# Enables WSL feature for Windows
# Returns true if restart needed, false otherwise
function Enable-Wsl{
    $wslinstall = Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux
    if ($wslinst.Restartneeded -eq $true){
        return $true
    }
}

# Legacy Function
# Enables Virtual Machine Platform feature for Windows
# Returns true if restart needed, false otherwise
function Enable-Wsl{
    $vmpinstall = Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform
    if ($vmpinst.RestartNeeded -eq $true){
        return $true
    }
}

# Legacy Function
# Updates WSL Kernel
function Update-WslKernel {
    $kernelURI = 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi'
    $kernelUpdate = ((Get-Location).Path) + '\wsl_update_x64.msi'
    (New-Object System.Net.WebClient).DownloadFile($kernelURI, $kernelUpdate)
    msiexec /i $kernelUpdate /qn
    Start-Sleep -Seconds 5
    Remove-Item -Path $kernelUpdate
}