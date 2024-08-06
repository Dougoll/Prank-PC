# Get the drive letter where the script is located
$driveLetter = (Get-Item -Path $PSScriptRoot).PSDrive.Name

# Check if the USB drive with the specific label exists
$driveOK = Get-Volume | Where-Object {$_.DriveLetter -eq $driveLetter -and $_.FileSystemLabel -eq "BADASS_USB" -and $_.DriveType -eq 'Removable' }

# Get the drive type of the drive where the script is located
$driveType = (Get-Volume -DriveLetter $driveLetter).DriveType

if ($driveOK) {
    Write-Host "Ta clé USB est OK!"
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Ta cle USB est ok! Tu peux utiliser fun.bat! ;)", 0, "Tiguidou!!", 0x0)
} else {
    if ($driveType -ne 'Removable') {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Les fichiers ne sont pas sur une cle USB. Transfere les sur une cle USB!!", 0, "Attention!", 0x0)
        exit
    }

    Write-Host "Ta clé USB est mal nommée!"
    $newName = "BADASS_USB"
    Set-Volume -DriveLetter $driveLetter -NewFileSystemLabel $newName
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("Ta cle USB est maintenant prete! Tu peux utiliser fun.bat! ;)", 0, "Tiguidou!!", 0x0)
}