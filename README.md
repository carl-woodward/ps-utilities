# ps-utilities

## Overview
PowerShell module containing several utilities:
1. `Get-ErrorText` - Converting WIN32, HRESULT, and NTSTATUS error codes into text.
2. `Format-Integer` - Displays decimal and hex values for an integer.

## Usage
To use, you must either install the module for a given PowerShell session *or* have the PowerShell startup script run as part of PowerShell startup so the commands are available for each PowerShell session.

To import the module into a session:
1. `Import-Module ps-utilities.psm1` i.e. `Import-Module ~\Source\ps-utilities\ps-utilities.psm1.

To import the module into all PowerShell future sessions, update `Microsoft.PowerShell_profile.ps1` in your home Documents folder edit  ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 *or* ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 to include the fully qualified path to ps_utilities.psm1 and any aliases (if required):
```
Import-Module ~\Source\ps-utilities\ps_utilities.psm1

Set-Alias -Name err -Value Get-ErrorText
Set-Alias -Name ee -Value Format-Intege
```