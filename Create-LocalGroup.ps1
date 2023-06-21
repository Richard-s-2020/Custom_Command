function Create-LocalGroup {
    # For custom command zoals Create-Localgroup -MainFolder * -SubFolder * -Name * -Debug (False or True)
    param (
        [string]$MainFolder,
        [string]$SubFolder,
        [string]$Name,
        [ValidateSet("False", "True")]
        [string]$Debug
    )
    try {
        #Import ADD
        Import-Module ActiveDirectory
        
        #Deze command zorg ervoor dat die data krijgt van Domain were it need to save-it. 
        $domain = Get-ADDomain
        $Domain_OU = $domain.DistinguishedName

        #Create a string were everthing is save for locatie for the localGroup
        $Rename = "OU=$SubFolder,OU=$MainFolder,$Domain_OU"
        
        # Specify the group name and other properties
        $groupDescription = "For the domain $Name"

        # Create the group within the specified OU
        $OU = Get-ADOrganizationalUnit -Identity $Rename
        New-ADGroup -Name $Name -Description $groupDescription -GroupCategory Security -GroupScope Global -Path $OU.DistinguishedName
        
        #Debug on or off 
        if ($Debug -eq "True") { Write-Host "$Name" at the location $OU.DistinguishedName }
    
    }
    catch {

    }
}   

