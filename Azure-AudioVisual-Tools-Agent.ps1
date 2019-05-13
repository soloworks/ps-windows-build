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
#   - Crestron Simpl+
#   - Crestron Simpl+ Cross Compiler 1.3
#
# Todo:
#   -  C:\Program Files (x86)\Crestron\Downloads\simpl_windows_4.11.06.01.exe /MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR="C:\Program Files (x86)\Crestron\Simpl" /LOG="C:\Program Files (x86)\Crestron\Downloads\InnoSetup.log" 
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
    $Version = '_4_4_1626'
    $FileEXE = "$($WorkDir)NetLinxStudioSetup$($Version).exe"
    Write-Output $FileEXE
    Write-Output "AMX NetLinxStudio$($Version) Downloading"
    Invoke-WebRequest -Uri "https://files.soloworks.co.uk/amx/NetLinxStudioSetup$($Version).exe" -OutFile $FileEXE
    Write-Output "AMX NetLinxStudio Installing"
    Start-Process -FilePath $FileEXE -ArgumentList "/quiet" -Wait
    Write-Output "AMX NetlinxStudio Installed"

    # Crestron SIMPL Windows
    $Version = '_4.11.06.01'
    $FileEXE = "$($WorkDir)simpl_windows$($Version).exe"
    Write-Output "Crestron SimplWindows$($Version) Downloading"
    Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_windows$($Version).exe" -OutFile $FileEXE
    Write-Output "Crestron Simpl Windows Installing"
    Start-Process -FilePath $FileEXE -ArgumentList "/quiet" -Wait
    Write-Output "Crestron Simpl Windows Installed"

    # Crestron Simpl+ Cross Compiler 1.3
    $Version = '_1.3'
    $FileEXE = "$($WorkDir)simpl_plus_cross_compiler$($Version).exe"
    $FileISS = "$($WorkDir)simpl_plus_cross_compiler$($Version).iss"
    Write-Output "Crestron Simpl+CC$($Version) Downloading"
    Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_plus_cross_compiler$($Version).exe" -OutFile $FileEXE
    Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_plus_cross_compiler$($Version).iss" -OutFile $FileISS
    
    Write-Output "Crestron Simpl+CC Installing"
    Start-Process -FilePath $FileEXE -ArgumentList "/a /s /f1`"$($FileISS)`"" -Wait
    Write-Output "Crestron Simpl+CC Installed"

}
# Clean Up
finally{
    # Remove Temp folder and contents
    Remove-Item -Path $WorkDir -Force -Recurse
    Write-Output 'Script Finished'
}
# EoF
