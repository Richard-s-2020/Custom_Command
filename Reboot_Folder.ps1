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

        # Local Group                    | doen
        [string]$Local_Group,

        # Local Group 
        [ValidateSet("Yes", "NO")]
        [string]$Overdelen,
                
        # Share folder                   | doen
        [ValidateSet("False", "True")]
        [string]$Share,
                
        #antwere for if you ate on server core
        [ValidateSet("Yes", "NO")]
        [string]$answer,


        # Want to debug                  | doen
        [ValidateSet("False", "True")]
        [string]$Debug,

        # Want to debug in CSV           | doen
        [string]$Debug_CSV
    )
    
    function Output {
        # Export the string to a text file
        $Debug_CSV_Output = $Debug_CSV + "\test.csv"
        $string | Out-File -FilePath $Debug_CSV_Output -Append
        
    }

    function Local_Group {

    }

    if (!($CSV -eq "")) {
        Write-Host $CSV
    }
    else {
        # Check where path is
        if ($Path -eq "") {
            $answer = Read-Host "are you on widnows core (Yes/No) ?"
            if ($answer -eq "Yes") {
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
                        if ($Debug -eq "True") { Write-Host "The folder has been created" }
                        if (!($Debug_CSV -eq "")) {
                            $DebugMessage = "The folder has been created"
                            Output 
                        }
                    }
                    catch {
                        if ($Debug -eq "True") { Write-Host "The folder can't be created" }
                        if (!($Debug_CSV -eq "")) {
                            $DebugMessage = "The path is empty"
                            Output                          
                            
                        }
                    }
                }
                else {
                    if ($Debug -eq "True") { Write-Host "The folder exists" }
                    if (!($Debug_CSV -eq "")) {
                        $DebugMessage = "The folder($Folder) exists"
                        Output
                    }
                }
            }
            else {
                if ($Debug -eq "True") { Write-Host "The path doesn't exist" }
                if (!($Debug_CSV -eq "")) {
                    $DebugMessage = "The path doesn't exist"
                    Output 
                }
            }
        }
        else {
            if (($Debug -eq "True") -and ($Debug_CSV -eq "")) { Write-Host "The path is empty" }
            if (!($Debug_CSV -eq "")) {
                $DebugMessage = "The path is empty"
                Output 
            }
        }
        if (!($Local_Group -eq "")) {
            Write-Host hello
        }
    }
}
