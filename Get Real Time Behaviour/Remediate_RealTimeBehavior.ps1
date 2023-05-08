<#
Version: 1.0
Author: Bernard Mah
Script: Detect-RealTimeBehaviour
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 32 & 64 Bit
#> 

$version = 'R1'
try {
    Set-MpPreference -DisableBehaviorMonitoring $false
    Write-Output "$version Remediated"
    exit 0
}
catch {
    Write-Output "$version Failed"
    exit 1
}