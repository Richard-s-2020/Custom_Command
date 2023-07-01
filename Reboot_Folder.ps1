function RE-Create-Folder {
    param (
        # Import CSV/Automatically
        [string]$CSV,
        
        # Import Path 
        [string]$Path,

        # The name of the Folder
        [string]$Name,

        # Local Group                    | doen
        [string]$Permissions,

        # Local Group 
        [ValidateSet("Yes", "NO", "y", "n")]
        [string]$Overdelen,
                
        # Share folder                   | doen
        [ValidateSet("False", "True")]
        [string]$Share,
        
        
        [string]$Permissions_Account,    
        
        #antwere for if you ate on server core
        [ValidateSet("Yes", "NO", "y", "n")]
        [string]$Windows_Server_Answer,

        #antwere for if you ate on server core
        [ValidateSet("Yes", "NO", "y", "n")]
        [string]$Permissions_Answer,

        # Want to debug                  | doen
        [ValidateSet("False", "True", "y", "t")]
        [string]$Debug,

        # Want to debug in CSV           | doen
        [string]$Debug_CSV
    )
    
    function Output {
        # Export the string to a text file
        $Debug_CSV_Output = $Debug_CSV + "\test.csv"
        $string | Out-File -FilePath $Debug_CSV_Output -Append
        return
    }

    function Permissions_Account {
        #user
        $userExists = Get-ADUser -Filter {SamAccountName -eq $Permissions_Account}
        if ($userExists) {
            if ($Overdelen -ieq "") {
            $Overdelen =  Read-Host "DO you whant to turn on the Overdelen? (Yes/NO)"
            }
            
        }else {
            Write-Host "The user don't exxits"
        }
    }

    if (!($CSV -eq "")) {
        Write-Host $CSV
    }
    else {
        # Check where path is
        if ($Path -ieq "") {
            $Windows_Server_Answer = Read-Host "are you on widnows core (Yes/No) ?"
            if ($Windows_Server_Answer -ieq "Yes" -or $Windows_Server_Answer -ieq "Y") {
                $Path = Read-Host "What location would you like to save the folder?"
            }
            else {
                Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
            
                public static class Win32 {
                    [DllImport("user32.dll")]
                    [return: MarshalAs(UnmanagedType.Bool)]
                    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
            
                    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
                    public const uint SWP_NOSIZE = 0x0001;
                    public const uint SWP_NOMOVE = 0x0002;
                }
"@

                Add-Type -AssemblyName System.Windows.Forms

                $openFileDialog = New-Object System.Windows.Forms.FolderBrowserDialog
                $openFileDialog.Description = "Select a folder"

                $form = New-Object System.Windows.Forms.Form
                $form.TopMost = $true

                $result = $openFileDialog.ShowDialog($form)
                if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                    $Path = $openFileDialog.SelectedPath
                }

            }

        }

        if ($Name -eq "") {
            $Name = Read-Host "What is the folder's name?"
        }
        
        $Folder = Join-Path -Path $Path -ChildPath $Name

        if (!($Path -eq "")) {
            if (Test-Path $Path) { 
                if (!(Test-Path $Folder)) {
                    try {
                        New-Item $Folder -ItemType Directory
                        if (!($Debug -eq "False")) { Write-Host "The folder has been created" }
                        if (!($Debug_CSV -eq "")) {
                            $DebugMessage = "The folder has been created"
                            Output 
                        }
                    }
                    catch {
                        if (!($Debug -eq "False")) { Write-Host "The folder can't be created" }
                        if (!($Debug_CSV -eq "")) {
                            $DebugMessage = "The path is empty"
                            Output                          
                            
                        }
                    }
                }
                else {
                    if (!($Debug -eq "False")) { Write-Host "The folder exists" }
                    if (!($Debug_CSV -eq "")) {
                        $DebugMessage = "The folder($Folder) exists"
                        Output
                    }
                }
            }
            else {
                if (!($Debug -eq "False")) { Write-Host "The path doesn't exist" }
                if (!($Debug_CSV -eq "")) {
                    $DebugMessage = "The path doesn't exist"
                    Output 
                }
            }
        }
        else {
            if ((!($Debug -ieq "False")) -and ($Debug_CSV -ieq "")) { Write-Host "The path is empty" }
            if (!($Debug_CSV -ieq "")) {
                $DebugMessage = "The path is empty"
                Output 
            }
        }

        $Permissions_Answer = Read-Host "DO you whant to set a Permissions? (Yes/NO)"
        if ($Permissions_Answer -ieq "Yes" -or $Permissions_Answer -ieq "Y") {
            if (!($Permissions_Account -ieq "")) {
                Permissions_Account
            } else {
                $Permissions_Account = Read-Host "what is the name for account and group?"
                if (!($Permissions_Account -ieq "")) {Permissions_Account}
            } 
        }
    }
}
