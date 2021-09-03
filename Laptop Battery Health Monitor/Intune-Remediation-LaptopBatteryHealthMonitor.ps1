<#     
    .NOTES 
    =========================================================================== 
     Created with:     SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135 
     Created on:       23/02/2017 23:00 
     Created by:       Maurice.Daly 
     Organization:      
     Filename:         LaptopBatteryNotifier.ps1 
    =========================================================================== 
    .DESCRIPTION 
        Configuration Item Script 
        
		This script is to be used in conjunction with the LaptopBatteryCheck.ps1
		script deployed as a CI/CB in SCCM.

		Ths Check script writes values to a network share where no SMTP server is 
		available to route email notifications through. In this instance this
		script reads the network share, obtains the key information required for
		the email notification and the associated battery report and then sends
		the email notification.

		This allows for a single firewall exclusion to allow outbound port 25 traffic.
  
        Twitter : @modaly_it 
        Blog : http://deployeverything.com 

	.EXAMPLE
		In the below example both an email and report saved to a network share are created
		CheckBatteryHealth -SendEmailNotice $true -NetWorkReport $true

		In this example reports are saved to the specified network share only
		CheckBatteryHealth -SendEmailNotice $false -NetWorkReport $true

		
#> 

# Maximum Acceptable Health Perentage
$MinHealth = "99"

# SMTP Server Name
$SMTPServer = "smtp.office365.com"

# Email Server Variables
$Recipient = "Navitas IT <globaleucteam@navitas.com>"
$Sender = "BBattery Health Check <bernard.mah@navitas.com>"

# Network Report Location
$NetworkShare = '\\auwgsccm-01.services.local\sccm_sources$\Doc\Logs'

# Start Processing Laptop Battery Reports
$Computers = Get-ChildItem -Path $NetworkShare

# Loop through all folders/computers found on the network share
foreach ($Computer in $Computers)
{
	$ComputerDetails= Import-Csv -Path ($Computer.FullName + "\" + "Details.csv")
	$Make = $ComputerDetails.Make
	$Model = $ComputerDetails.Model
	$Name = $ComputerDetails.Name
	$CurrentHealth = $ComputerDetails.CurrentHealth
	$LowHealth = $ComputerDetails.LowHealth
	$ReplaceBatteryCount = $ComputerDetails.ReplaceBatteryCount
	$SerialNumber = $ComputerDetails.SerialNumber
	
	$ReportOutput = (Get-ChildItem -Recurse -Path $Computer.FullName | Where-Object { $_.Name -like "*.html" }).FullName
	
	# Email Body (HTML)
	$Body = '<p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">Configuration Manager has detected that the battery in ' + $Name + ' is currently running at <strong><span style="color: #ff0000;">' + $CurrentHealth + '%</span></strong>.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">As this is below the <span style="text-decoration: underline;">recommended replacement value of ' + $MinHealth + '%</span>, a replacement battery should be obtained from ' + $Make + ' for the laptop.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">The make, model and serial number of the laptop are as follows:<br /><br /> <strong>Make:</strong> ' + $Make + '<br/> <strong>Model:</strong> ' + $Model + '<br/> <strong>Serial:</strong> ' + $SerialNumber + '</span></p>'
		
	# Additional Text - Secondary Battery Detected
	if ($ReplaceBatteryCount -gt 1)
	{
		$Body = '<p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">Configuration Manager has detected that the battery in ' + $Name + ' is currently running at <strong><span style="color: #ff0000;">' + $LowHealth + '%</span></strong>.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">As this is below the <span style="text-decoration: underline;">recommended replacement value of ' + $MinHealth + '%</span>, a replacement battery should be obtained from ' + $Make + ' for the laptop.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">The make, model and serial number of the laptop are as follows:<br /><br /> <strong>Make:</strong> ' + $Make + '<br/> <strong>Model:</strong> ' + $Model + '<br/> <strong>Serial:</strong> ' + $SerialNumber + '</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;"><strong>Note:</strong> This model has more than one battery present.</span></p>'
	}

	# Notify IT SUpport - If Battery Replacement Required
	send-mailmessage -from "$Sender" -to "$Recipient" -subject "Replacement Battery Required - $Name" -body $Body -BodyAsHtml -priority High -Attachments $ReportOutput -smtpServer $SMTPServer
}

