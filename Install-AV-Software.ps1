####################################################################################################
# Powershell Script to Pull and Install tools to a Windows system to act as an agent for Azure CI/CD
#
# Some useful notes from here: http://unattended.sourceforge.net/installers.php
#
# Run script as Admin to prevent UAC prompts
#
# May need to run command: "Set-ExecutionPolicy RemoteSigned"
#
# Currently supports:
#
#   - AMX Netlinx Studio 4.4.1626
#   - Crestron Simpl+
#   - Crestron Simpl+ Cross Compiler 1.3
#
# Todo:
#   - Change Write-Host to Write-Progress
#   - C:\Program Files (x86)\Crestron\Downloads\simpl_windows_4.11.06.01.exe /MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR="C:\Program Files (x86)\Crestron\Simpl" /LOG="C:\Program Files (x86)\Crestron\Downloads\InnoSetup.log" 
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
    [switch]$Lightware    = $false,

    [switch]$DevOps       = $false,
    [switch]$Tools       = $false
)
# Setup Script Variables
$progressPreference = 'silentlyContinue'  # Stop downloads showing progress - speeds things up a LOT
$WorkDir = $env:TEMP+'\Install-AV-Software\' # Temp Working Directory
$FileHost = "https://files.soloworks.co.uk"

# Setup Try/Finally block to allow clean exit
try{

    # Make temp directory
    New-Item -Path $WorkDir -ItemType Directory -Force | Out-Null

    # Misc Software
    if(($DevOps -eq $true) -or ($Tools -eq $true)){

        # Visual Studio Code
        $Version = '-x64-1.34.0'
        $FileEXE = "VSCodeUserSetup$($Version).exe"
        Write-Host -NoNewLine "Visual Studio Code  ($($FileEXE))..."
        Invoke-WebRequest -Uri "$($FileHost)/Microsoft/$($FileEXE)" -OutFile "$($WorkDir)$($FileEXE)"
        Write-Host -NoNewLine "Installing..."
        Start-Process -FilePath "$($WorkDir)$($FileEXE)" -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode" -Wait
        Write-Host "Done!"

        # Git for Windows 
        $Version     = '-2.21.0-64-bit'
        $FileEXE     = "Git$($Version).exe"
        Write-Host -NoNewLine "Git for Windows Downloading ($($FileEXE))..."
        Invoke-WebRequest -Uri "$($FileHost)/git/$($FileEXE)" -OutFile "$($WorkDir)$($FileEXE)"
        Write-Host -NoNewLine "Installing..."
        Start-Process -FilePath "$($WorkDir)$($FileEXE)" -ArgumentList "/VERYSILENT" -Wait
        Write-Host "Done!"

        # Atlassian Sourcetree
        $Version     = '_3.1.3'
        $FileEXE     = "SourcetreeEnterpriseSetup$($Version).msi"
        Write-Host -NoNewline "Sourcetree Downloading ($($FileEXE))..."
        Invoke-WebRequest -Uri "$($FileHost)/Atlassian/$($FileEXE)" -OutFile "$($WorkDir)$($FileEXE)"
        Write-Host -NoNewLine "Installing..."
        Start-Process -FilePath "$($WorkDir)$($FileEXE)" -ArgumentList "/quiet ACCEPTEULA=1" -Wait
        Write-Host "Done!"

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
        Write-Host "AMX Netlinx Studio Downloading (NetLinxStudio$($Version).exe)"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/amx/NetLinxStudioSetup$($Version).exe" -OutFile $FileEXE
        Write-Host "AMX NetLinx Studio Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/quiet" -Wait
        Write-Host "AMX NetLinx Studio Installed"
    }
    if($AMX -eq $true){
        # TPDesign 5
    }

    # Crestron Software
    if(($Crestron -eq $true) -or ($DevOps -eq $true)){
        # SIMPL Windows
        # From Master Installer Log:

        # C:\Program Files (x86)\Crestron\Downloads\crestron_database_77.00.003.00.exe /MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR="C:\Program Files (x86)\Crestron\Cresdb" /LOG="C:\Program Files (x86)\Crestron\Downloads\InnoSetup.log" 
        $Version = '_77.05.001.00'
        $FileEXE = "$($WorkDir)crestron_database$($Version).exe"
        Write-Host "Crestron Database Downloading (crestron_database$($Version).exe)"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/crestron_database$($Version).exe" -OutFile $FileEXE
        Write-Host "Crestron Crestron Database Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR=`"C:\Program Files (x86)\Crestron\Cresdb`"" -Wait
        Write-Host "Crestron Cretron Database Installed"
        
        # C:\Program Files (x86)\Crestron\Downloads\device_database_102.05.001.00.exe /MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR="C:\Program Files (x86)\Crestron\Cresdb" /LOG="C:\Program Files (x86)\Crestron\Downloads\InnoSetup.log"
        $Version = '_103.05.001.00'
        $FileEXE = "$($WorkDir)device_database$($Version).exe"
        Write-Host "Crestron device_database$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/device_database$($Version).exe" -OutFile $FileEXE
        Write-Host "Crestron Device Database Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR=`"C:\Program Files (x86)\Crestron\Cresdb`"" -Wait
        Write-Host "Crestron Device Database Installed"

        # C:\Program Files (x86)\Crestron\Downloads\simpl_windows_4.11.06.01.exe /MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR="C:\Program Files (x86)\Crestron\Simpl" /LOG="C:\Program Files (x86)\Crestron\Downloads\InnoSetup.log" 
        $Version = '_4.11.06.01'
        $FileEXE = "$($WorkDir)simpl_windows$($Version).exe"
        Write-Host "Crestron SimplWindows$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_windows$($Version).exe" -OutFile $FileEXE
        Write-Host "Crestron Simpl Windows Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/MASTERINSTALLER=TRUE /VERYSILENT /NORESTART /DIR=`"C:\Program Files (x86)\Crestron\Simpl`"" -Wait
        Write-Host "Crestron Simpl Windows Installed"
    
        # Simpl+ Cross Compiler 1.3
        $Version = '_1.3'
        $FileEXE = "$($WorkDir)simpl_plus_cross_compiler$($Version).exe"
        $FileISS = "$($WorkDir)simpl_plus_cross_compiler$($Version).iss"
        Write-Host "Crestron Simpl+CC$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_plus_cross_compiler$($Version).exe" -OutFile $FileEXE
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/crestron/simpl_plus_cross_compiler$($Version).iss" -OutFile $FileISS
        
        Write-Host "Crestron Simpl+CC Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/a /s /f1`"$($FileISS)`"" -Wait
        Write-Host "Crestron Simpl+CC Installed"
    }
    if($Crestron -eq $true){
        #TODO: VTPro
        #TODO: TOOLBOX
        #TODO: Crestron Database
        #TODO: Device Database
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
        Write-Host "Extron PCS$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/extron/PCS$($Version).exe" -OutFile $FileEXE
         
        Write-Host "Extron PCS$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Host "Extron PCS$($Version) Installed"
        
        # DSP Configurator 2.21.0
        $Version = '_2_21_0'
        $FileEXE = "$($WorkDir)DSP_Configurator$($Version).exe"
        Write-Host "Extron DSP_Configurator$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/extron/DSP_Configurator$($Version).exe" -OutFile $FileEXE
         
        Write-Host "Extron DSP_Configurator$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Host "Extron DSP_Configurator$($Version) Installed"
        
    }
    if(($Extron -eq $true) -or ($DevOpsOnly -eq $true)){
        # DevOps Only Options Here
    }
    
    # QSC Software
    if($QSC -eq $true){
        # Set Version for all
        $Version = ' 8.0.0'
        # Q-SYS Administrator Installer
        $FileEXE = "$($WorkDir)Q-SYS Administrator Installer$($Version).exe"
        Write-Host "QSC Q-SYS Administrator Installer$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/qsc/Q-SYS Administrator Installer$($Version).exe" -OutFile $FileEXE
        Write-Host "QSC Q-SYS Administrator Installer$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Host "QSC Q-SYS Administrator Installer$($Version) Installed"
        # Q-SYS Designer Installer
        $FileEXE = "$($WorkDir)Q-SYS Designer Installer$($Version).exe"
        Write-Host "QSC Q-SYS Designer Installer$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/qsc/Q-SYS Designer Installer$($Version).exe" -OutFile $FileEXE
        Write-Host "QSC Q-SYS Designer Installer$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Host "QSC Q-SYS Designer Installer$($Version) Installed"
        # Q-SYS UCI Viewer Installer
        $FileEXE = "$($WorkDir)Q-SYS UCI Viewer Installer$($Version).exe"
        Write-Host "QSC Q-SYS UCI Viewer Installer$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/qsc/Q-SYS UCI Viewer Installer$($Version).exe" -OutFile $FileEXE
        Write-Host "QSC Q-SYS UCI Viewer Installer$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Host "QSC Q-SYS UCI Viewer Installer$($Version) Installed"
    }
    if(($QSC -eq $true) -or ($DevOpsOnly -eq $true)){
        # DevOps Options Here
    }
    
    # Lightware Software
    if(($Lightware -eq $true) -or ($DevOpsOnly -eq $true)){
        # DevOps Only Options Here
    }
    
    # QSC Software
    if($Lightware -eq $true){
        # Lightware Device Updater
        $Version = '_v1.5.3b4'
        $FileEXE = "$($WorkDir)install_LDU$($Version).exe"
        Write-Output "Lightware install_LDU$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/lightware/install_LDU$($Version).exe" -OutFile $FileEXE
        Write-Output "Lightware install_LDU$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Lightware install_LDU$($Version) Installed"

        # Lightware Device Updater 2
        $Version = '_v1.2.3b3'
        $FileEXE = "$($WorkDir)install_LDU2$($Version).exe"
        Write-Output "Lightware install_LDU2$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/lightware/install_LDU2$($Version).exe" -OutFile $FileEXE
        Write-Output "Lightware install_LDU2$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Lightware install_LDU2$($Version) Installed"

        # Lightware Device Controller
        $Version = '_v1.29.0b1'
        $FileEXE = "$($WorkDir)install_LDC$($Version).exe"
        Write-Output "Lightware install_LDC$($Version) Downloading"
        Invoke-WebRequest -Uri "https://files.soloworks.co.uk/lightware/install_LDC$($Version).exe" -OutFile $FileEXE
        Write-Output "Lightware install_LDC$($Version) Installing"
        Start-Process -FilePath $FileEXE -ArgumentList "/s" -Wait
        Write-Output "Lightware install_LDC$($Version) Installed"

    }
}
# Clean Up
finally{
    # Remove Temp folder and contents
    Remove-Item -Path $WorkDir -Force -Recurse
    Write-Host ''
    Write-Host 'Finished and cleaned up - All Done!'
}
# EoF
