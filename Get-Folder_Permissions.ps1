function Get-Folder_Permissions ($Patch) {
    
    if (-not $Patch) {
        $Patch = Read-Host "Please enter the folder path:"
    }

    if ($Patch -eq "") {
        Add-Type -AssemblyName System.Windows.Forms
        
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        
        # Set the initial directory (optional)
        $folderBrowser.SelectedPath = "C:\Path\To\Initial\Folder"
        
        # Show the folder dialog and check if the user clicked OK
        $result = $folderBrowser.ShowDialog()
        
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $Patch = $folderBrowser.SelectedPath
        }
        (Get-Acl $Patch).Access | Select-Object `
        @{Label = "Identity"; Expression = { $_.IdentityReference } }, `
        @{Label = "Right"; Expression = { $_.FileSystemRights } }, `
        @{Label = "Access"; Expression = { $_.AccessControlType } }, `
        @{Label = "Inherited"; Expression = { $_.IsInherited } }, `
        @{Label = "Inheritance Flags"; Expression = { $_.InheritanceFlags } }, `
        @{Label = "Propagation Flags"; Expression = { $_.PropagationFlags } } | Format-Table -AutoSize
        }
    else {
        if (Test-Path -Path $Patch) {
             (Get-Acl $Patch).Access | Select-Object `
             @{Label = "Identity"; Expression = { $_.IdentityReference } }, `
             @{Label = "Right"; Expression = { $_.FileSystemRights } }, `
             @{Label = "Access"; Expression = { $_.AccessControlType } }, `
             @{Label = "Inherited"; Expression = { $_.IsInherited } }, `
             @{Label = "Inheritance Flags"; Expression = { $_.InheritanceFlags } }, `
             @{Label = "Propagation Flags"; Expression = { $_.PropagationFlags } } | Format-Table -AutoSize
        }else {
        write-host "patch is not true"
        }
    }
}

