# Déclaration des variables
$soundLocation = "C:\Windows\Media\" # Chemin par défaut des son windows
$originalSound1 = "Windows Hardware Insert.wav" # son connection d'appareils
$originalSound2 = "Windows Hardware Remove.wav" # son déconnection d'appareils
$driveLetter = get-volume | where { $_.FileSystemLabel -match "badass_usb" } | select driveletter # lettre de la clé USB
$drivePath = $driveLetter.driveletter + ":\" # Lettre de la clé USB avec :\

# Definir le chemin vers le fichiers wav
$wavFilePath3 = "$soundLocation$originalSound1"
$wavFilePath4 = "$soundLocation$originalSound2"

# Chemins des clés de registre pour configuration du son
$regPath1 = "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current"
$regPath2 = "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current"

# Application des nouvelles valeurs des clés de registre 
Set-ItemProperty -Path $regPath1 -Name "(Default)" -Value $wavFilePath3
Set-ItemProperty -Path $regPath2 -Name "(Default)" -Value $wavFilePath4

# Fermer toutes les fenêtre windows explorer
(New-Object -ComObject Shell.Application).Windows() | %{$_.quit()}


if ($driveLetter) {
# Pause de 1 seconde
Start-Sleep 1
$driveEject = New-Object -comObject Shell.Application
$driveEject.Namespace(17).ParseName("$drivePath").InvokeVerb("Eject")
# Pause de 1 seconde
Start-Sleep 1
}




######Par Sébastien Langevin august 2024######