# Detection Script
$geoPath = "HKCU:\Control Panel\International\Geo"

try {
    $nation = Get-ItemPropertyValue -Path $geoPath -Name "Nation" -ErrorAction Stop
    $name = Get-ItemPropertyValue -Path $geoPath -Name "Name" -ErrorAction Stop

    if ($nation -eq "AU" -and $name -eq "AU") {
        Write-Host "Location is correctly set to AU."
        exit 0  # Detection passes
    } else {
        Write-Host "Location is not set to AU. Nation: $nation, Name: $name"
        exit 1  # Detection fails
    }
} catch {
    Write-Host "Error reading registry values: $_"
    exit 1  # Detection fails if key/values are missing
}
