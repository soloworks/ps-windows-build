param(
    [switch]$Crestron = $false,
    [switch]$AMX      = $false,
    [switch]$Extron   = $false,
    [switch]$QSC      = $false,
    [switch]$DevOps   = $false
)
Write-Output $Crestron
if ($Crestron) {
    Write-Output "YES!!"
}else{
    Write-Output "NOO!!"
}
