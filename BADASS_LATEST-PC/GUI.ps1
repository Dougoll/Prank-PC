Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$depsDir = Join-Path $scriptDir 'dependencies'
$installBat = Join-Path $depsDir '_INSTALL.bat'
$uninstallBat = Join-Path $depsDir '_UNINSTALL.bat'

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Yamete Kudasai Prank'
$form.Size = New-Object System.Drawing.Size(500,400)
$form.StartPosition = 'CenterScreen'

# Log box
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = 'Vertical'
$logBox.Size = New-Object System.Drawing.Size(460,200)
$logBox.Location = New-Object System.Drawing.Point(10,150)
$logBox.ReadOnly = $true
$form.Controls.Add($logBox)

function Write-Log {
    param([string]$Text)
    $logBox.AppendText($Text + "`r`n")
}

# Install button
$installBtn = New-Object System.Windows.Forms.Button
$installBtn.Text = 'Install Prank'
$installBtn.Size = New-Object System.Drawing.Size(120,40)
$installBtn.Location = New-Object System.Drawing.Point(50,40)
$form.Controls.Add($installBtn)

# Uninstall button
$uninstallBtn = New-Object System.Windows.Forms.Button
$uninstallBtn.Text = 'Uninstall Prank'
$uninstallBtn.Size = New-Object System.Drawing.Size(120,40)
$uninstallBtn.Location = New-Object System.Drawing.Point(200,40)
$form.Controls.Add($uninstallBtn)

# Hidden fix button for missing admin rights
$fixAdminBtn = New-Object System.Windows.Forms.Button
$fixAdminBtn.Text = 'Restart as Admin'
$fixAdminBtn.Size = New-Object System.Drawing.Size(120,40)
$fixAdminBtn.Location = New-Object System.Drawing.Point(350,40)
$fixAdminBtn.Visible = $false
$form.Controls.Add($fixAdminBtn)

function Run-Batch {
    param([string]$file)
    try {
        Write-Log "Running $file"
        $process = Start-Process -FilePath $file -NoNewWindow -Wait -PassThru -RedirectStandardOutput temp_out.txt -RedirectStandardError temp_err.txt
        if ($process.ExitCode -eq 0) {
            $out = Get-Content temp_out.txt
            if ($out) { Write-Log $out }
            Write-Log "$file finished successfully."    
        } else {
            $err = Get-Content temp_err.txt
            Write-Log "Error running $file: Exit $($process.ExitCode)"
            if ($err) { Write-Log $err }
        }
    } catch {
        Write-Log "Exception: $_"
    } finally {
        if (Test-Path temp_out.txt) { Remove-Item temp_out.txt -Force }
        if (Test-Path temp_err.txt) { Remove-Item temp_err.txt -Force }
    }
}

$installBtn.Add_Click({ Run-Batch $installBat })
$uninstallBtn.Add_Click({ Run-Batch $uninstallBat })

# Admin check
$currUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Log 'This prank requires administrator rights.'
    $fixAdminBtn.Visible = $true
}

$fixAdminBtn.Add_Click({
    Start-Process -Verb runas -FilePath 'powershell' -ArgumentList "-ExecutionPolicy Bypass -File `\"$($MyInvocation.MyCommand.Definition)`\""
    $form.Close()
})

# Dependency check
$needed = @('nircmd.exe','yamete-kudasai-1.wav','yamete-kudasai-2.wav')
foreach ($file in $needed) {
    if (-not (Test-Path (Join-Path $depsDir $file))) {
        Write-Log "Missing dependency: $file"
    }
}

[System.Windows.Forms.Application]::EnableVisualStyles()
$form.Add_Shown({$form.Activate()})
[System.Windows.Forms.Application]::Run($form)
