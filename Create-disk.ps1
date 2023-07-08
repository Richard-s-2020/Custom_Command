function Create-Disk {
    param (
        [string]$Disk
    )
    
    $reload_Functions = "C:\Users\Richa\OneDrive\Documenten\WindowsPowerShell\Scripts\functions"

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
        $command = @"
        Import-Module "$reload_Functions\load_Function.ps1";
        write-host 'Import model Create-Disk';
        Create-Disk -Disk $Disk;
"@
        $argument = "-NoProfile -ExecutionPolicy Bypass -NoExit -Command `"$command`""

        Start-Process -FilePath "powershell.exe" -ArgumentList $argument -Verb RunAs
        return
    }
    # Continue with the rest of your script
    Start-Process -FilePath "diskpart.exe" -ArgumentList "list disk" -Verb RunAs
    $tets = Read-Host "e"
}
