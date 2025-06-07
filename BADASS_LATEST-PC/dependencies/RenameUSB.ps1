# Get the drive letter where the script is located
$driveLetter = (Get-Item -Path $PSScriptRoot).PSDrive.Name

# Check if the USB drive with the specific label exists
$driveOK = Get-Volume | Where-Object {$_.DriveLetter -eq $driveLetter -and $_.FileSystemLabel -eq "BADASS_USB" -and $_.DriveType -eq 'Removable' }

# Get the drive type of the drive where the script is located
$driveType = (Get-Volume -DriveLetter $driveLetter).DriveType

$parentdir = (Get-Item -Path $PSScriptRoot).Parent.FullName

# Liste des fichiers requis pour le prank
    $files = @(
        "$PSScriptRoot\_INSTALL.bat",
        "$PSScriptRoot\_UNINSTALL.bat",
        "$PSScriptRoot\data1.ps1",
        "$PSScriptRoot\data2.ps1",
        "$PSScriptRoot\nircmd.exe",
        "$PSScriptRoot\yamete-kudasai-1.wav",
        "$PSScriptRoot\yamete-kudasai-2.wav",
        "$parentdir\2-Fun.bat"
        
    )

Function get-integrity {       
    param (
        [string[]]$paths
    )

    $failedPaths = @()

    foreach ($path in $paths) {
        if (-not (Test-Path -Path $path)) {
            $failedPaths += $path
        }
    }
    if ($failedPaths.count -gt 0){
        $failedPathsString = $failedPaths -join "`n"

        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Il manque des fichiers!:`n`n$failedPathsString", 0, "Fichiers Manquants!!", 0x0)
        exit
    }
}


if ($drivetype -ne 'Removable') {
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Les fichiers ne sont pas sur une cle USB. Transfere les sur une cle USB!!", 0, "Attention!", 0x0)
    exit
}

get-integrity -paths $files

if ($driveOK) {
    Write-Host "Ta clé USB est OK!"
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Ta cle USB est ok! Tu peux utiliser fun.bat! ;)", 0, "Tiguidou!!", 0x0)

} else {
    Write-Host "Ta clé USB est mal nommée!"
    $newName = "BADASS_USB"
    Set-Volume -DriveLetter $driveLetter -NewFileSystemLabel $newName
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Ta cle USB est maintenant prete! Tu peux utiliser fun.bat! ;)", 0, "Tiguidou!!", 0x0)

}

