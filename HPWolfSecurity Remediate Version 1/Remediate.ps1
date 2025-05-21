do {
    $Apps = Get-CimInstance -ClassName Win32_Product | Where-Object {(($_.Name -like "HP Wolf*") `
        -or ($_.Name -like "HP Security*") `
        -or ($_.Name -like "HP Connection Optimizer*") `
        -or ($_.Name -like "HP Documentation*") `
        -or ($_.Name -like "HP Security Update Service*") `
        -or ($_.Name -like "HP Sure Run Module*") `
        -or ($_.Name -like "HP Easy Clean*") `
        -or ($_.Name -like "HP Privacy Settings*") `
        -or ($_.Name -like "HP QuickDrop*") `
        -or ($_.Name -like "HP Support Assistant*") `
        -or ($_.Name -like "HP Wolf Security - Console*") `
        -or ($_.Name -like "HP System Information*") `
        -or ($_.Name -like "HP WorkWell*") `
        -or ($_.Name -like "myHP*"))} | Select-Object Name, IdentifyingNumber | Sort-Object Name -Descending
    foreach ($App in $Apps) {
        $AppID=  $App.IdentifyingNumber
        $ArgumentList = '/uninstall ' + $AppID + ' /quiet /norestart'
        $p = Start-Process -FilePath 'msiexec.exe' -ArgumentList $ArgumentList -Wait -PassThru -ErrorAction SilentlyContinue
    }
} while ($null -ne $Apps)