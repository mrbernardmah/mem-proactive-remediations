 Clear-Host
 <#Information
 
 
    Author: thewatchernode
    Contact: author@blogabout.cloud
    Published: 5th January 2021
    
    .DESCRIPTION
    This script is designed remediate OneDrive Flag 
    
    Version Changes            
    
    : 0.1 Initial Script Build
    : 1.0 Inital Release
     
    Credit:
    
    .EXAMPLE
    .\Set-DetectOneDriveDelayFlag.ps1
    
    Description
    -----------
    Runs script with default values.
    
    .INPUTS
    None. You cannot pipe objects to this script.
#>


#region Shortnames
$Path = "HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts\Business1"
$Name = "Timerautomount"
$Type = "QWORD"
$Value = 1
#endregion Shortnames

#region Script Block
Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
#endregion Script Block