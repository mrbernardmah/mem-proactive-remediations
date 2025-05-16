# Function to add and enable a firewall rule using netsh
function Add-FirewallRule {
    param (
        [string]$ruleName,
        [string]$program,
        [string]$protocol,
        [string]$localPort
    )
    netsh advfirewall firewall add rule name=$ruleName `
        dir=in action=allow program=$program `
        protocol=$protocol localport=$localPort profile=any enable=yes
}

# Function to enable a firewall rule using Enable-NetFirewallRule
function Enable-FirewallRule {
    param (
        [string]$ruleName
    )
    Enable-NetFirewallRule -DisplayName $ruleName
}

# Define the firewall rules to remediate
$firewallRules = @(
    @{
        Name = "Remote Desktop - Shadow (TCP-In)"
        Program = "%SystemRoot%\system32\RdpSa.exe"
        Protocol = "TCP"
        LocalPort = "Any"
    },
    @{
        Name = "Remote Desktop - User Mode (TCP-In)"
        Program = "%SystemRoot%\system32\svchost.exe"
        Protocol = "TCP"
        LocalPort = "3389"
    },
    @{
        Name = "Remote Desktop - User Mode (UDP-In)"
        Program = "%SystemRoot%\system32\svchost.exe"
        Protocol = "UDP"
        LocalPort = "3389"
    }
)

# Remediate the firewall rules
foreach ($rule in $firewallRules) {
    $ruleEnabled = Is-FirewallRuleEnabled -ruleName $rule.Name
    if (-not $ruleEnabled) {
        Add-FirewallRule -ruleName $rule.Name -program $rule.Program -protocol $rule.Protocol -localPort $rule.LocalPort
        Enable-FirewallRule -ruleName $rule.Name
    }
}
