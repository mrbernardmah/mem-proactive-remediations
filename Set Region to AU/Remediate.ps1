# This script sets the region to Australia (AU)
# Set the region to AU (Australia)
# Replace "AU" with the appropriate code if needed
Set-ItemProperty -Path "HKCU:\Control Panel\International\Geo" -Name "Nation" -Value "AU"
Set-ItemProperty -Path "HKCU:\Control Panel\International\Geo" -Name "Name" -Value "AU"
Write-Output "Region set to Australia (AU)"