function Create-User {
    param (
        [string]$Folder,
        [string]$OU
    )
    $antwere = Read-Host "Do you whant a custom OU (Y|N)"
    Import-Module ActiveDirectory
    
    if (-not $Folder) {
        if (-not ([System.Management.Automation.PSTypeName]'Win32').Type) {
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
        }
        
        Add-Type -AssemblyName System.Windows.Forms
        
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.InitialDirectory = "C:\Path\To\Initial\Folder"
        $openFileDialog.Filter = "CSV Files (*.csv)|*.csv"
        $openFileDialog.Title = "Select CSV File"
        
        $form = New-Object System.Windows.Forms.Form
        $form.TopMost = $true
        
        $result = $openFileDialog.ShowDialog($form)
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $filePath = $openFileDialog.FileName
        }
        else {
            return
        }
        #General:
        $CSV_Filles = Import-Csv -Path $filePath -Delimiter ";"
        foreach ($Account in $CSV_Filles) {
            $GebruikersNaam = $Account.GebruikersNaam
            $Firstname = $Account.Firstname
            $Achternaam = $Account.Achternaam
            $DisplayName = $Account.DisplayName
            $Description = $Account.Description
            $office = $Account.Office 
            $Email = $Account.EmailAddress
            
            #address
            $Street = $Account.Street
            $City = $Account.City
            $Postcode = $Account.Postcode
            
            #profile
            $ProfilePath = $Account.ProfilePath
            $ScriptPath = $Account.ScriptPath
            $Home_Folder = $Account.HomeFolder

            #Telephone
            $HomePhone = $Account.HomePhone
            $MobilePhone = $Account.MobilePhone
            $Fax = $Account.fax

            #Organization
            $Title = $Account.Title
            $Department = $Account.Department
            $Company = $Account.Company
            $Member = $Account.Member
            $Password = $Account.Passord
            $changeLoGin = $Account.ChangePasswordAtLogon
            
            if (-not($GebruikersNaam -eq "" -or $Firstname -eq "" -or $Achternaam -eq "" -or $Password)) {
                if ($antwere -eq "Yes" -or $antwere -eq "Y") {
                    Create-OU -Locatie "Afdeling" -Name $Department -OwnAccount "False"
                }
                Create-LocalGroup -Locatie "Afdeling" -SubFolder $Department  -Name $Department
            }
            else {
                Write-Host "The account can't be make bacause the Username or Firstname or achternaam or password is not true"
            }   
        }
    }
    else {

        $CSV_Filles = Import-Csv -Path $Folder -Delimiter ";"
        foreach ($Account in $CSV_Filles) {
            $GebruikersNaam = $Account.GebruikersNaam
            $Firstname = $Account.Firstname
            $Achternaam = $Account.Achternaam
            $DisplayName = $Account.DisplayName
            $Description = $Account.Description
            $office = $Account.Office 
            $Email = $Account.EmailAddress
            
            #address
            $Street = $Account.Street
            $City = $Account.City
            $Postcode = $Account.PostalCode
            
            #profile
            $ProfilePath = $Account.ProfilePath
            $ScriptPath = $Account.ScriptPath
            $Home_Folder = $Account.HomeFolder

            #Telephone
            $HomePhone = $Account.HomePhone
            $MobilePhone = $Account.MobilePhone
            $Fax = $Account.fax

            #Organization
            $Title = $Account.Title
            $Department = $Account.Department
            $Company = $Account.Company
            $Member = $Account.Member
            $Password = $Account.Password
            $changeLoGin = $Account.ChangePasswordAtLogon
            
            $domain = Get-ADDomain
            $DC = $domain.DistinguishedName
            $Path = "OU=$Department,OU=Afdeling,$DC"
            

            if (-not($GebruikersNaam -eq "" -or $Firstname -eq "" -or $Achternaam -eq "" -or $Password -eq "")) {
                if ($antwere -eq "Yes" -or $antwere -eq "Y") {
                    Create-OU -Locatie "Afdeling" -Name $Department -OwnAccount "Yes"
                }
                $EmailAdress = $GebruikersNaam + "@Jahmmfm.de"
                #create User
                if ($changeLoGin -eq "True") {
                    $hangePasswordAtLogon = $true
                }
                
                New-ADUser -SamAccountName $GebruikersNaam -Name $Firstname -DisplayName $DisplayName -Surname $Achternaam -Description $Description -Office $office -EmailAddress $EmailAdress -StreetAddress $Street -City $City -PostalCode $Postcode -ProfilePath $ProfilePath -scriptPath $ScriptPath -HomeDirectory $Home_Folder -HomePhone $HomePhone -MobilePhone $MobilePhone -Fax $Fax -Title $Title -Department $Department -Company $Company -AccountPassword(ConverTto-SecureString $Password -AsPlainText -force) -path $Path -ChangePasswordAtLogon $hangePasswordAtLogon -Enabled $True
                
                Create-LocalGroup -Locatie "Afdeling" -SubFolder $Department  -Name $Department
                Add-ADGroupMember -Identity $Member -Members $GebruikersNaam
                Write-Host "$GebruikersNaam is add"
            }
            else {
                Write-Host "The account can't be make bacause the Username or Firstname or achternaam or password is not true"
            } 
        }
    }
}