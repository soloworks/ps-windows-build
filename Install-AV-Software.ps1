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

# Get Parameters
param(
    [switch]$Crestron     = $false,
    [switch]$AMX          = $false,
    [switch]$Extron       = $false,
    [switch]$QSC          = $false,

    [switch]$DevOps       = $false
)
# Setup Script Variables
$progressPreference = 'silentlyContinue'  # Stop downloads showing progress - speeds things up a LOT
$WorkDir = $env:TEMP+'\Install-AV-Software\' # Temp Working Directory

# Setup Try/Finally block to allow clean exit
try{

    # Make temp directory
    New-Item -Path $WorkDir -ItemType Directory -Force | Out-Null

    # Misc Software
    if($DevOps -eq $true){
        # Git for Windows 
        $Version = '-2.21.0-64-bit'
        $FileEXE = "$($WorkDir)Git$($Version).exe"
        Write-Output "Git$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/git/Git$($Version).exe" -OutFile $FileEXE
        Write-Output "Git$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/VERYSILENT" -Wait
        Write-Output "Git$($Version) Installed"

    }

    # AMX Software
    if($AMX -eq $true){
        #TODO: TPDesign 4
        #TODO: TPDesign 5
    }
    if(($AMX -eq $true) -or ($DevOps -eq $true)){
        # Netlinx Studio 4.4.1626 - NS.exe /help for options
        $Version = '_4_4_1626'
        $FileEXE = "$($WorkDir)NetLinxStudioSetup$($Version).exe"
        Write-Output "AMX NetLinxStudio$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/amx/NetLinxStudioSetup$($Version).exe" -OutFile $FileEXE
        Write-Output "AMX NetLinxStudio$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/quiet" -Wait
        Write-Output "AMX NetLinxStudio$($Version) Installed"
    }
    if($AMX -eq $true){
        # TPDesign 5
    }

    # Crestron Software
    if(($Crestron -eq $true) -or ($DevOps -eq $true)){
        # SIMPL Windows
        # From Master Installer Log:
        # C:\Program Files (x86)\Crestron\Downloads\simpl_windows_4.11.06.01.exe /MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR="C:\Program Files (x86)\Crestron\Simpl" /LOG="C:\Program Files (x86)\Crestron\Downloads\InnoSetup.log" 
        $Version = '_4.11.06.01'
        $FileEXE = "$($WorkDir)simpl_windows$($Version).exe"
        Write-Output "Crestron SimplWindows$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_windows$($Version).exe" -OutFile $FileEXE
        Write-Output "Crestron Simpl Windows Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR=`"C:\Program Files (x86)\Crestron\Simpl`"" -Wait
        Write-Output "Crestron Simpl Windows Installed"
    
        # Simpl+ Cross Compiler 1.3
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
    if($Crestron -eq $true){
        #TODO: VTPro
        #TODO: TOOLBOX
        #TODO: CrestronDatabase
    }
    
    # Extron Software
    if($Extron -eq $true){
        #TODO: Toolbelt                  Toolbelt_v2x3x0
        #TODO: Global Scripter -         GlobalScripter_v2x3x0
        #TODO: Global Configurator -     GC3x5x2
        #TODO: Global Configurator Pro - GCPro_v3x3x0.exe
        #TODO: GUI Configurator -        GUICSW1x4x1
        #TODO: GUI Designer -            GUIDesigner_v1x10x0
        
        # PCS 4.4.3
        $Version = '_v4x4x3'
        $FileEXE = "$($WorkDir)PCS$($Version).exe"
        Write-Output "Extron PCS$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/extron/PCS$($Version).exe" -OutFile $FileEXE
         
        Write-Output "Extron PCS$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Extron PCS$($Version) Installed"
        
        # DSP Configurator 2.21.0
        $Version = '_2_21_0'
        $FileEXE = "$($WorkDir)DSP_Configurator$($Version).exe"
        Write-Output "Extron DSP_Configurator$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/extron/DSP_Configurator$($Version).exe" -OutFile $FileEXE
         
        Write-Output "Extron DSP_Configurator$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Extron DSP_Configurator$($Version) Installed"
        
    }
    if(($Extron -eq $true) -or ($DevOpsOnly -eq $true)){
        # DevOps Only Options Here
    }
    
    # QSC Software
    if($QSC -eq $true){
        # Set Version for all
        $Version = '8.0.0'
        # Q-SYS Administrator Installer
        $FileEXE = "$($WorkDir)Q-SYS Administrator Installer$($Version).exe"
        Write-Output "Extron Q-SYS Administrator Installer$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/qsc/Q-SYS Administrator Installer$($Version).exe" -OutFile $FileEXE
        Write-Output "Extron Q-SYS Administrator Installer$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Extron Q-SYS Administrator Installer$($Version) Installed"
        # Q-SYS Designer Installer
        $FileEXE = "$($WorkDir)Q-SYS Designer Installer$($Version).exe"
        Write-Output "Extron Q-SYS Designer Installer$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/qsc/Q-SYS Designer Installer$($Version).exe" -OutFile $FileEXE
        Write-Output "Extron Q-SYS Designer Installer$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Extron Q-SYS Designer Installer$($Version) Installed"
        # Q-SYS UCI Viewer Installer
        $FileEXE = "$($WorkDir)Q-SYS UCI Viewer Installer$($Version).exe"
        Write-Output "Extron Q-SYS UCI Viewer Installer$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/qsc/Q-SYS UCI Viewer Installer$($Version).exe" -OutFile $FileEXE
        Write-Output "Extron Q-SYS UCI Viewer Installer$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Extron Q-SYS UCI Viewer Installer$($Version) Installed"
    }
    if(($QSC -eq $true) -or ($DevOpsOnly -eq $true)){
        # DevOps Options Here
    }
}
# Clean Up
finally{
    # Remove Temp folder and contents
    Remove-Item -Path $WorkDir -Force -Recurse
    Write-Output 'Script Finished'
}
# EoF
