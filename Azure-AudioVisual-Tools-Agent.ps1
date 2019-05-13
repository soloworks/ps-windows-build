####################################################################################################
# Powershell Script to Pull and Install tools to a Windows system to act as an agent for Azure CI/CD
#
# Some useful notes from here: http://unattended.sourceforge.net/installers.php
#
# Run script as Admin to prevent UAC prompts
#
# Currently supports:
#
#   - AMX Netlinx Studio 4.4.1626
#   - Crestron Simpl+ Cross Compiler 1.3
#
# Todo:
#   -  Find correct flags for S+CC silent install
#
# Created by and for Solo Works London
#
####################################################################################################

# Setup Script Variables
$progressPreference = 'silentlyContinue'  # Stop downloads showing progress - speeds things up a LOT
$WorkDir = $env:TEMP+'\Azure-AudioVisual-Tools-Agent\' # Temp Working Directory

# Setup Try/Finally block to allow clean exit
try{

    # Make temp directory
    New-Item -Path $WorkDir -ItemType Directory -Force

    # AMX Netlinx Studio 4.4.1626 - NS.exe /help for options
    $NetlinxVersion = '_4_4_1626'
    Write-Output "AMX NetLinxStudio$NetlinxVersion Downloading"
    Invoke-WebRequest -Uri "https://files.soloworks.co.uk/amx/NetLinxStudioSetup$NetlinxVersion.exe" -OutFile $WorkDir"NetLinxStudioSetup"$NetlinxVersion".exe"
    Write-Output "AMX NetLinxStudio Installing"
    Start-Process -FilePath $WorkDir"NetLinxStudioSetup"$NetlinxVersion".exe" -ArgumentList "/quiet" -Wait
    Write-Output "AMX NetlinxStudio Installed"

    # Crestron Simpl+ Cross Compiler 1.3
    $CrossCompilerVersion = '_1.3'
    Write-Output "Crestron Simpl+CC$CrossCompilerVersion Downloading"
    Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_plus_cross_compiler$CrossCompilerVersion.exe" -OutFile $WorkDir"simpl_plus_cross_compiler"$CrossCompilerVersion".exe"
    Write-Output "Crestron Simpl+CC Installing"
    Start-Process -FilePath $WorkDir"simpl_plus_cross_compiler$CrossCompilerVersion.exe" -Wait #-ArgumentList "/S /v`"qn`""
    Write-Output "Crestron Simpl+CC Installed"

}
# Clean Up
finally{
    # Remove Temp folder and contents
    Remove-Item -Path $WorkDir -Force -Recurse
    Write-Output 'Script Finished'
}
# EoF
