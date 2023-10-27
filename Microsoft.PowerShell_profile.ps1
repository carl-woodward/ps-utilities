Import-Module PSReadLine

Import-Module ~\Source\ps-utilities\ps_utilities.psm1

Set-Alias -Name err -Value Get-ErrorText
Set-Alias -Name ee -Value Format-Integer
Set-Alias -Name touch -Value Touch-File
Set-Alias -Name gsp -Value Get-ShortPath