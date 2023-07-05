function Create-Disk {
    param (
        [string]$Disk
    )

    # Check if running as administrator
    # This will self elevate the script with a UAC prompt since it needs to be run as an Administrator to function properly.
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "You didn't run this script as an Administrator. This script will self-elevate to run as an Administrator and continue."
        Start-Sleep -Seconds 1
        Write-Host "                                               3"
        Start-Sleep -Seconds 1
        Write-Host "                                               2"
        Start-Sleep -Seconds 1
        Write-Host "                                               1"
        Start-Sleep -Seconds 1

        # Build the argument list for self-elevation
        $command = "Import-Module C:\Users\Richa\OneDrive\Documenten\WindowsPowerShell\Scripts\functions\load_Function.ps1; Create-CSV_User -disk $disk"
        $argument = "-NoProfile -ExecutionPolicy Bypass -Command `"$command`""

        Start-Process -FilePath "powershell.exe" -ArgumentList $argument -Verb RunAs

    }
    else {
        # Continue with the rest of your script
        Start-Process -FilePath "diskpart.exe" -Verb RunAsAdmin
    }
}
