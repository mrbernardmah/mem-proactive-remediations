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

#region Function
Function Set-OneDriveRegKey {
Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}
}
#endregion Function

#Script Block
Set-OneDriveRegKey