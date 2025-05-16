# Function to check if a firewall rule exists and is enabled
function Is-FirewallRuleEnabled {
    param (
        [string]$ruleName
    )
    $ruleStatus = netsh advfirewall firewall show rule name=$ruleName | Select-String -Pattern "Enabled: Yes"
    return $ruleStatus -ne $null
}

# Define the firewall rules to check
$firewallRules = @(
    "Remote Desktop - Shadow (TCP-In)",
    "Remote Desktop - User Mode (TCP-In)",
    "Remote Desktop - User Mode (UDP-In)"
)

# Detect the status of each rule
foreach ($ruleName in $firewallRules) {
    $ruleEnabled = Is-FirewallRuleEnabled -ruleName $ruleName
    Write-Output "$ruleName Enabled: $ruleEnabled"
}
