#=============================================================================================================================
#
# Script Name:     Remediate_Update_PowerShell_Modules.ps1
# Description:     Remediate outdated PowerShell Module and update from PowerShell Gallery
# Notes:           The purpose of this script is to keep installed PowerShell Modules on IT Administrator Devices up to 
#                  date with the latest PowerShell Modules from the PowerShell Gallery
#
#=============================================================================================================================

# Define Variables
$Array = @(Get-InstalledModule)
$Green = 'Green'
$DarkRed = 'DarkRed'
$White = 'White'


   Foreach ($Module in $Array)
   
   {
     $ModuleCheck = Get-InstalledModule -name $Module.Name -ErrorAction SilentlyContinue
     $online = Find-Module -Name $module.name -Repository PSGallery -ErrorAction Stop   

     if ($ModuleCheck.version -EQ $online.Version) {
           Write-Host 'Detected: '$Module.Name, 'doesnt require an update as installed version' $Module.Version,'matches the latest online version' $online.Version -ForegroundColor $Green 
          }
     else {
           Write-Host 'Detected:'$Module.Name 'Module', 'is running an outdate version' $Module.Version, 'Version'$online.Version, 'is now available' -ForegroundColor $White -BackgroundColor $DarkRed
           Uninstall-Module -Name $Module.Name -RequiredVersion $module.version 
           Write-Host -BackgroundColor $DarkRed -ForegroundColor $White 'Info: Legacy Version of',$Module.name,'module now removed'
           Install-Module -Name $Module.Name -RequiredVersion $online.Version -Force -AllowClobber
          }
          }
# SIG # Begin signature block
# MIID5wYJKoZIhvcNAQcCoIID2DCCA9QCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURlbMwJUOBvgqD199hBYZrhQm
# xQKgggIDMIIB/zCCAWigAwIBAgIQQpygbaU9/7tO9TFRA7HT5jANBgkqhkiG9w0B
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
# NwIBFTAjBgkqhkiG9w0BCQQxFgQUaZE08cgiR5qNfNoOfMbd//sf+ZMwDQYJKoZI
# hvcNAQEBBQAEgYBS02NkezUF8sgaQ7pYf5Sm3+oqt/d5w8UiIW6L+5uMoJbdlFJc
# 9fM1wnAEURVHp5UNpLa5a78kpP63Ne6G6p7RVi237IMq2vaZnOts6Jg4hCuLbLPP
# YShU4zWM/9eX0GVlw2T7K1Iv8sCnmSIbbuMNEek00RfiIGKdE2pDBgfJlg==
# SIG # End signature block
