function Create-Folder {
    param (
        [string]$CSV,
        [string]$Path,
        [string]$Name,
        [ValidateSet("False", "True")]
        [string]$Debug,
        [ValidateSet("False", "True")]
        [string]$Local_Group
    )
    function Share {
        if ($Share -eq "Yes") {
            $ShareName = $FolderName + "$"
            $NewFolder = $Folder + "\"
            Write-Host $ShareName
            Write-Host $NewFolder
            New-SmbShare -Name $ShareName -Path $NewFolder -ChangeAccess "Domain Users" -CimSession "Jahmmfm.de"
        }
    }

    if (!($CSV -eq "")) {
        $Datas = Import-Csv $CSV -Delimiter ";"
        foreach ($Data in $Datas) {
            $FolderName = $Data.FolderName
            $Patch = $Data.Patch
            $Rechten = $Data.Rechten
            $Member = $Data.Member
            $Share = $Data.Share
            $Overdelen = $Data.Overdelen
            $Folder = $Patch + $FolderName

            #rechten:
            $Read = "$FolderName" + "_R"
            $ReadAndWrite = "$FolderName" + "_RW"

            if (![string]::IsNullOrEmpty($Patch) -and $Folder -ne "\") {
                
                if (!(Test-Path $Patch) -or !(Test-Path $Folder)) {
                    New-Item -ItemType Directory -Path $Folder -Force

                    # Create local groups
                    Create-LocalGroup -MainFolder "Rank" -SubFolder "Share" -Name $Read
                    Create-LocalGroup -MainFolder "Rank" -SubFolder "Share" -Name $ReadAndWrite

                    # Set permissions
                    $Acl = Get-Acl $Folder
                    if ($Overdelen -eq "No") {
                        $Overdelen = "None"
                    }
                    else {
                        $Overdelen = "ContainerInherit,ObjectInherit"
                    }

                    if ($Rechten -eq "Read") {
                        #add member
                        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Read, "Read" , $Overdelen, "None", "Allow")
                        $Acl.AddAccessRule($AccessRule)
                        Set-Acl -Path $Folder -AclObject $Acl

                        Add-ADGroupMember -Identity $Read -Members $Member
                    }
                    elseif ($Rechten -eq "ReadAndExecute") {
                        #add member
                        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ReadAndWrite, "ReadAndExecute", $Overdelen, "None", "Allow")
                        $Acl.AddAccessRule($AccessRule)
                        Set-Acl -Path $Folder -AclObject $Acl
                                                
                        Add-ADGroupMember -Identity $ReadAndWrite -Members $Member
                    }
                }
                else {
                    $Acl = Get-Acl $Folder
                    if ($Overdelen -eq "No") {
                        $Overdelen = "None"
                    }
                    else {
                        $Overdelen = "ContainerInherit,ObjectInherit"
                    }
                    if ($Rechten -eq "Read") {
                        #add member
                        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Read, "Read" , $Overdelen, "None", "Allow")
                        $Acl.AddAccessRule($AccessRule)
                        Set-Acl -Path $Folder -AclObject $Acl

                        Add-ADGroupMember -Identity $Read -Members $Member
                    }
                    elseif ($Rechten -eq "ReadAndExecute") {
                        #add member
                        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ReadAndWrite, "ReadAndExecute", $Overdelen, "None", "Allow")
                        $Acl.AddAccessRule($AccessRule)
                        Set-Acl -Path $Folder -AclObject $Acl
                                                
                        Add-ADGroupMember -Identity $ReadAndWrite -Members $Member
                    }
                    
                }
                Share
            }
        }
    }
}
