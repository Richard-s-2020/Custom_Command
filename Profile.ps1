foreach ($profileLocation in ($PROFILE | Get-Member -MemberType NoteProperty).Name)
{
    Write-Host "$($profileLocation): $($PROFILE.$profileLocation)"
    Get-ChildItem .\Get-Folder_Permissions.ps1 | %{. $_ }
    Get-ChildItem .\Get-WindowsPosition.ps1 | %{. $_ }
    Get-ChildItem .\Create-User.ps1 | %{. $_ }
    Get-ChildItem .\Create-CSV_User.ps1 | %{. $_ }
    clear
    Write-Host "Custom Function are read to go"
}