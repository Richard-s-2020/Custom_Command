function Create-Disk {
    param (
        [string]$CSV,
        [string]$Letter,
        [string]$disk,        
        [ValidateSet("False", "True", "y", "t")]
        [string]$Debug
    )

        # Check if running as administrator
        $isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        if (-not $isElevated) {
            # Restart the script with administrative privileges
            $arguments = "-ExecutionPolicy Bypass -Command `"$function:Create-Disk -CSV `"C:\path\to\file.csv`" -Letter `"D`" -disk `"1`" -Debug `"True`"`""
            Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs
            return
        }
        
    if ($CSV -eq "") {
        Write-Host "Hello"
    }
}
