#################################
#Configure the settings		#
#################################

$kb = "KB5004945"
$kbsearch = "*$kb*"

###############
#temp folder # 
##############

$path = "C:\temp\"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

#######################################################################
##Detect if the pswindowsupdate is installed.. so not install it!     #
#######################################################################

if (Get-Module -ListAvailable -Name pswindowsupdate) {
    Write-Host "PSUpdate Module exists"
} 
else {
	Install-PackageProvider NuGet -Force | out-null 
        install-module pswindowsupdate -force | out-null 
    Write-Host "Module does not exist, installing it now"
   
}

####################################################
####Check if the windows update is installed      #
###################################################

if ($status = Get-hotfix | where-object {($_.HotFixID -like $kbsearch )})

{
    Write-Host "Update $kb Already installed"
    exit 0
} 
else {
	
    Write-Host "Update $kb not installed, installing it now"
    exit 1
   
}




