#the name of the folder/filles
$Basis_Name = "RS_Remote"
$Sub_Name = "PowerShell Custom Command"
$Module = "Modules"
$Documents = "Profile.ps1"

$documentenPath = [Environment]::GetFolderPath("MyDocuments")

#set the folder path
$path = "$env:APPDATA"
$Basis_Folder = "$path\$Basis_Name"
$Sub_Folder = "$Basis_Folder\$Sub_Name"
$Module_Folder = "$Sub_Folder\$Module"
$Documents_Folder = "$documentenPath\WindowsPowerShell\$Documents"
$path_Import_module = "$Sub_Folder/Import-Module.ps1"

#controler the path to the basis folder
if (!(Test-Path $Basis_Folder)) {
    New-Item -Path $env:APPDATA -ItemType Directory -Name $Basis_Name
}
else {
    Write-Host "The folder exxits|$Basis_Folder"
}

#concatenate the path to the sub folder
if (!(Test-Path $Sub_Folder)) {
    New-Item -Path $Basis_Folder -ItemType Directory -Name $Sub_Name
} {
    Write-Host "The folder exxits|$Sub_Name"
}

#set up the path to the module folder
if (!(Test-Path $Module_Folder)) {
    New-Item -Path $Sub_Folder -ItemType Directory -Name $Module
} {
    Write-Host "The folder exxits|$Sub_Name"
}

#set-up powershell import module 
$Import_module_Name = '$_.FullName'
$Import_module = @"

Get-ChildItem -Path "$Module_Folder" -Filter "*.ps1" | ForEach-Object {
    Import-Module $Import_module_Name
}

"@

#test if the script exists
if (Test-Path -Path $path_Import_module) {
    Set-Content -Path "$path_Import_module" -Value $Import_module
}
else {
    New-Item -ItemType File -Path "$path_Import_module" -Value $Import_module
}


#test if the script exists
if (Test-Path -Path $Documents_Folder) {
    Set-Content -Path "$Documents_Folder" -Value "Import-Module '$path_Import_module'"
}
else {
    New-Item -ItemType File -Path "$Documents_Folder" -Value "Import-Module '$path_Import_module'"
}

#download modules
