#=============================================================================================================================
#
# Script Name:     Detect_Update_PowerShell_Modules.ps1
# Description:     Detect outdated PowerShell Module and update from PowerShell Gallery
# Notes:           The purpose of this script is to keep installed PowerShell Modules on IT Administrator Devices up to 
#                  date with the latest PowerShell Modules from the PowerShell Gallery
#
#=============================================================================================================================

# Define Variables
$Array = @(Get-InstalledModule)
$Green = 'Green'
$DarkRed = 'DarkRed'
$DarkCyan = 'DarkCyan'
$White = 'White'

   Foreach ($Module in $Array) {
   

    $ModuleCheck = Get-InstalledModule -name $Module.Name -ErrorAction SilentlyContinue
    $online = Find-Module -Name $module.name -Repository PSGallery -ErrorAction Stop   

     if ($ModuleCheck.version -EQ $online.Version) {
           Write-Host 'Detected: '$Module.Name, 'doesnt require an update as installed version' $Module.Version,'matches the latest online version' $online.Version -ForegroundColor $Green
           
          }
     else {
           Write-Host 'Detected:'$Module.Name 'Module', 'is running an outdate version' $Module.Version, 'Version'$online.Version, 'is now available' -ForegroundColor $White -BackgroundColor $DarkRed
           Exit 1
          }  
}

# SIG # Begin signature block
# MIID5wYJKoZIhvcNAQcCoIID2DCCA9QCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2Y+WhHHtP0GBbIFatVmE5n8l
# 8kqgggIDMIIB/zCCAWigAwIBAgIQQpygbaU9/7tO9TFRA7HT5jANBgkqhkiG9w0B
# AQUFADAaMRgwFgYDVQQDDA9CbG9nYWJvdXQuQ2xvdWQwHhcNMjAwODI2MjE1NzU3
# WhcNMjQwODI2MDAwMDAwWjAaMRgwFgYDVQQDDA9CbG9nYWJvdXQuQ2xvdWQwgZ8w
# DQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBANxdFHO7/WOrtN5bIfrO7n6cMc52aS14
# AyqN5oPd+D+cw9jsRiCa3YPFcnwTEYl6chGXg6O9vi2sp45v1dTNIV5L1YojtsVT
# NsSJ5CSi+LGtS4LIX6Buhsi7WhIlndS4BSVP4NlMjO5NMekFuA+4ITJy0dzPqp64
# iU/w0p2+UuU5AgMBAAGjRjBEMBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQW
# BBRXaewv9To8HU85dx80ObrML+/L9TAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcN
# AQEFBQADgYEAP1o8VlE6LGGx96f8WCtMnyckZr0hOniZNMiE73CnoVEeL6tkevDD
# rwCsy7w+edBNJQcvElIfR7jsdvxaZ+ni5AkmnhDDa3iiMTG3gfv/0QBhIcO5Gnu6
# EIcGo+XmeVoC5qKqFbSrdsCQd20BPzExPgA/uCSTWjavikIs2Ugcg1gxggFOMIIB
# SgIBATAuMBoxGDAWBgNVBAMMD0Jsb2dhYm91dC5DbG91ZAIQQpygbaU9/7tO9TFR
# A7HT5jAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUuxcuQAjLtYqHbYb4f5FZLnCSJuowDQYJKoZI
# hvcNAQEBBQAEgYDNTwpE0Qo0VI8t4xua/REuYXvRzalyXDAWC+y41ceTuo3o6W0K
# /CQLvrMogbeeMo49h+NiiJI/mk1FMuMeETU785JAO5Ujqe3cWpIQQT57NEO2Xwst
# NR8Yto/UUQL9+dcZmDHOkBbpn2D8VWMMXnUQYrNlH2snOdEiZxaycghCzg==
# SIG # End signature block
