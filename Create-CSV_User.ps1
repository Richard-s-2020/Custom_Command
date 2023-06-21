function Create-CSV_User {
    #create a private Function:
    #Custom command : Create-CSV_User -Patch 
    param (
        [string]$Patch,
        [ValidateSet("False", "True")]
        [string]$Debug
    )
    function Create_CSV {
        $data = @(
            [PSCustomObject]@{
                General               = "x"
                name                  = ""
                Givenname             = ""
                User                  = ""
                DisplayName           = ""
                Office                = ""
                EmailAddress          = ""
                Address               = "x"
                Street                = ""
                City                  = ""
                State                 = ""
                PostalCode            = ""
                Profile               = "x"
                ProfilePath           = ""
                ScriptPath            = ""
                Telephones            = "x"
                HomePhone             = ""
                MobilePhone           = ""
                fax                   = ""
                Organization          = "x"
                Title                 = ""
                Department            = ""
                Company               = ""
                Member                = ""
                Password              = ""
                AccountPassword       = ""
                ChangePasswordAtLogon = ""
            },
            [PSCustomObject]@{
                General               = "x"
                name                  = ""
                Givenname             = ""
                User                  = ""
                DisplayName           = ""
                Office                = ""
                EmailAddress          = ""
                Address               = "x"
                Street                = ""
                City                  = ""
                State                 = ""
                PostalCode            = ""
                Profile               = "x"
                ProfilePath           = ""
                ScriptPath            = ""
                Telephones            = "x"
                HomePhone             = ""
                MobilePhone           = ""
                fax                   = ""
                Organization          = "x"
                Title                 = ""
                Department            = ""
                Company               = ""
                Member                = ""
                Password              = ""
                AccountPassword       = ""
                ChangePasswordAtLogon = ""
            }
        )
        
        # Specify the path for the output CSV file
        $csvFilePath = $Patch
        
        # E""port the data to a CSV file with semicolon as the delimiter
        $data | Export-Csv -Path $csvFilePath -Delimiter ";" -NoTypeInformation
         if ($Debug -eq "True") {Write-Host "The CSV Will Save at $scpFilePath"}
    }
    if (-not $Patch) {
        #if the Patch is not true.
        # create a read-host
        
        
        Write-Host "Were do you whant to save it ?"
        Write-Host ""
        Write-Host "D is for Download"
        Write-Host "C is for custom Locatie" 
        Write-Host ""
        $Antwere = Read-Host "Selec the locatie"

        If ($Antwere -eq "D" -or $Antwere -eq "d") {
            # set in the download folder
            $Patch = $home + "\Downloads\Add-User.csv"

            if (Test-Path -Path $Patch) {
                $removeFile = Read-Host "'Add-User.csv' is a preexisting file. Do you wish to get rid of it? (Y/N)"
                if ($removeFile -eq "Y" -or $removeFile -eq "y") {
                    Create_CSV
                }
                else {
                    Write-Host "File not removed."
                    return
                }

            }
            else {
                Create_CSV
            }
        }
        elseif ($Antwere -eq "C" -or $Antwere -eq "c") {
            #else if the patch is setten say yes
            Add-Type -AssemblyName System.Windows.Forms

            $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
            $folderBrowser.TopMost = $true
            # Set the initial directory (optional)
            $folderBrowser.SelectedPath = "C:\Path\To\Initial\Folder"
        
            # Show the folder dialog and check if the user clicked OK
            $result = $folderBrowser.ShowDialog()
        
            if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                $folder = $folderBrowser.SelectedPath
        
                # Get the parent folder path
                $parentFolder = (Get-Item -Path $folder).Parent.FullName
        
                $patch = $parentFolder + "\Add-User.csv"
        
                $patch
            }
            else {
                return
            }

        }
    }else {
        $patch = $Patch + "\Add-User.csv"
        Create_CSV

    }
}