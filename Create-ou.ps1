function Create-OU {
    param (
        [string]$Locatie,
        [string]$Name,
        [string]$Csv,
        [string]$OwnAccount,
        [ValidateSet("False", "True")]
        [string]$Debug
    )
    Function Make {
        $domain = Get-ADDomain
        $DC = $domain.DistinguishedName
        $Rename = "OU=" + $Locatie + "," + $DC 
        $Renames = "OU=$Name,$Rename"
        Import-Module ActiveDirectory
        while (-not([ADSI]::Exists("LDAP://$Renames"))) {
            
                if (-not[ADSI]::Exists("LDAP://ou=$Locatie,$DC")) {
                    New-ADOrganizationalUnit -Name $Locatie -Path $DC -ProtectedFromAccidentalDeletion 0 
                    Write-Host "ou will be added to AD"
                    if ($OwnAccount -eq "False") { Make }
                }
                else {
                        New-ADOrganizationalUnit -Name $Name -Path $Rename -ProtectedFromAccidentalDeletion 0 
                        Write-Host "ou will be added to AD"
                }
        }

    }

    if ($Debug -eq "") {}

    if (-not $Locatie) {
        $Locatie = Read-Host "were do you whant to Save the OU?"
    }
    
    if (-not $Name) {
        $Name = Read-Host "what are the names for the OU"
        Make
        }else {  
            Make
        }
    }    