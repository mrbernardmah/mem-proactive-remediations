# Specify Max Days For CCM Cache Entries
$MaxRetention = 3

# Connect To Resource Manager Com Object
$SCCMClient = New-Object -ComObject UIResource.UIResourceMgr

# Get SCCM Client Cache Directory Location
$SCCMCacheDir = ($SCCMClient.GetCacheInfo().Location)

# List All Applications Due In The Future Or Currently Running
$PendingApps = @($SCCMClient.GetAvailableApplications() | ?{
    ($_.StartTime -gt (Get-Date)) -or ($_.IsCurrentlyRunning -eq 1)
})

# Create List Of Applications To Purge From Cache
$PurgeApps = @($SCCMClient.GetCacheInfo().GetCacheElements() | ?{
    ($_.ContentID -notin $PendingApps.PackageID) `
    -and ((Test-Path -Path $_.Location) -eq $true) `
    -and ($_.LastReferenceTime -lt (Get-Date).AddDays(- $MaxRetention))
})

# Get all cache directories with an active association
$ActiveDirs = @($SCCMClient.GetCacheInfo().GetCacheElements() | %{ 
    Write-Output $_.Location
})

# Build an array of folders in ccmcache that don't have an active association
$MiscDirs = @(Get-ChildItem -Path $SCCMCacheDir | ?{
    (($_.PsIsContainer -eq $true) -and ($_.FullName -notin $ActiveDirs)) 
})

# Add Old App & Misc Directories
$PurgeCount = $PurgeApps.Count + $MiscDirs.Count

# Return Number Of Applications To Purge
return $PurgeCount