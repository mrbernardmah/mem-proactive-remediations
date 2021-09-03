<#     
    .NOTES 
    =========================================================================== 
     Created with:     SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135 
     Created on:       23/02/2017 23:00 
     Created by:       Maurice.Daly 
     Organization:      
     Filename:         LaptopBatteryCheck.ps1 
    =========================================================================== 
    .DESCRIPTION 
        Configuration Item Script 
        Used to monitor the battery health of laptop systems. 
        Please specify your SMTP server, recipient and sender email addresses 
        within the script. 
 
        This script should be used as part of a configuration baseline. 
 
        Use : This script is provided as it and I accept no responsibility for any issues arising from its use. 
  
        Twitter : @modaly_it 
        Blog : http://deployeverything.com 

	.EXAMPLE
		In the below example both an email and report saved to a network share are created
		CheckBatteryHealth -SendEmailNotice $true -NetWorkReport $true

		In this example reports are saved to the specified network share only
		CheckBatteryHealth -SendEmailNotice $false -NetWorkReport $true

		
#> 

function CheckBatteryHealth
{
	param (
		[boolean]$SendEmailNotice,
		[boolean]$NetworkReport
	)
	
	# Maximum Acceptable Health Perentage
	$MinHealth = "99"
	
	# SMTP Server Name
	$SMTPServer = "smtp.office365.com"

	# Email Server Variables
	$Recipient = "Navitas IT <globaleucteam@navitas.com>"
	$Sender = "Battery Health Check <bernard.mah@navitas.com>"

	# Network Report Location
	$NetworkShare = '\\auwgsccm-01.services.local\sccm_sources$\Doc\Logs'
	
	# Use legacy WMI or Powershell 5.1 commands where available
	if (($PSVersionTable).psversion -lt "5.1")
	{
		# Check machine type and other info
		$Make = (Get-WmiObject -Class Win32_BIOS).Manufacturer
		$Model = (Get-WmiObject -Class Win32_ComputerSystem).Model
		$Name = (Get-WmiObject -Class Win32_ComputerSystem).Name
	}
	else
	{
		# Check machine type and other info
		$ComputerDetails = Get-ComputerInfo
		$Make = $ComputerDetails.CSManufacturer
		$Model = $ComputerDetails.CSModel
		$Name = $ComputerDetails.csName
		
	}
	
	[string]$SerialNumber = (Get-WmiObject win32_bios).SerialNumber
	
	# Set Variables for health check
	$Batteries = Get-WmiObject -Class "BatteryStatus" -Namespace "ROOT\WMI"
	$CurrentBattery = 0
	$ReplaceBatteryCount = 0
	
	# Set Initial Battery Replacement Status
	$ReplaceBattery = $false
	
	foreach ($Battery in $Batteries)
	{
		#Write-Host "Checking Battery Specs"
		$BatteryDesignSpec = (Get-WmiObject -Class "BatteryStaticData" -Namespace "ROOT\WMI").DesignedCapacity[$CurrentBattery]
		$BatteryFullCharge = (Get-WmiObject -Class "BatteryFullChargedCapacity" -Namespace "ROOT\WMI").FullChargedCapacity[$CurrentBattery]
		
		# Determine battery replacement required
		[int]$CurrentHealth = ($BatteryFullCharge/$BatteryDesignSpec) * 100
		
		if ($CurrentHealth -le $MinHealth)
		{
			#Write-Host "Battery needs replacing"
			$ReplaceBatteryCount++
			$LowHealthValue = $CurrentHealth
		}
	}
	
	if (($ReplaceBatteryCount -gt "0"))
	{
		# Flag Replacement Battery
		$ReplaceBattery = $true
		
		# Test SMTP Access
		$SMTPAvailable = (Test-NetConnection -ComputerName $SMTPServer -Port 25).TcpTestSucceeded 
		
		# Send Email Notification If Required
		If (($SendEmailNotice -eq $true) -and ($SMTPAvailable -eq $true))
		{
			# Email Body (HTML)
			$Body = '<p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">Configuration Manager has detected that the battery in ' + $Name + ' is currently running at <strong><span style="color: #ff0000;">' + $CurrentHealth + '%</span></strong>.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">As this is below the <span style="text-decoration: underline;">recommended replacement value of ' + $MinHealth + '%</span>, a replacement battery should be obtained from ' + $Make + ' for the laptop.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">The make, model and serial number of the laptop are as follows:<br /><br /> <strong>Make:</strong> ' + $Make + '<br/> <strong>Model:</strong> ' + $Model + '<br/> <strong>Serial:</strong> ' + $SerialNumber + '</span></p>'
			
			# Secondary Battery Detected
			if ($ReplaceBatteryCount -gt 1)
			{
				$Body = '<p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">Configuration Manager has detected that the battery in ' + $Name + ' is currently running at <strong><span style="color: #ff0000;">' + $LowHealth + '%</span></strong>.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">As this is below the <span style="text-decoration: underline;">recommended replacement value of ' + $MinHealth + '%</span>, a replacement battery should be obtained from ' + $Make + ' for the laptop.</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;">The make, model and serial number of the laptop are as follows:<br /><br /> <strong>Make:</strong> ' + $Make + '<br/> <strong>Model:</strong> ' + $Model + '<br/> <strong>Serial:</strong> ' + $SerialNumber + '</span></p><p style="line-height: 16.5pt; margin: 11.25pt 0cm 11.25pt 0cm;"><span style="font-size: 10.5pt; font-family: ' + "'Lucida Sans Unicode'" + ',sans-serif; color: #2b2e2f;"><strong>Note:</strong> This model has more than one battery present.</span></p>'
			}
			
			# Generate Battery Report (Windows 8 onwards)
			if ((Get-WmiObject -Class win32_OperatingSystem).Version -lt "6.2")
			{
				
				$ReportOutput = $env:TEMP + '\Battery-Report-' + $SerialNumber + '.html'
				Start-Process PowerCfg.exe -ArgumentList "/BatteryReport /OutPut $ReportOutput"
				sleep -second 2
				
				# Notify IT SUpport - If Battery Replacement Required
				send-mailmessage -from "$Sender" -to "$Recipient" -subject "Replacement Battery Required - $Name" -body $Body -BodyAsHtml -priority High -Attachments $ReportOutput -smtpServer $SMTPServer
			}
			else
			{
				# Notify IT SUpport - If Battery Replacement Required
				send-mailmessage -from "$Sender" -to "$Recipient" -subject "Replacement Battery Required - $Name" -body $Body -BodyAsHtml -priority High -smtpServer $SMTPServer
			}
			
		}
		
		If (($SMTPAvailable -eq $false) -or ($NetworkReport -eq $true))
		{
			# Create Report Location For Machine 
			$ModelReportDir = ($NetworkShare + "\" + $Name)
			If ((Test-Path -Path $ModelReportDir) -eq $false) { New-Item -Path $ModelReportDir -ItemType dir }
			
			# Copy Report 
			Copy-Item -Path $ReportOutput -Destination $ModelReportDir
			$ModelDetailsFile = "Details.csv"
			
			# Create Array With Required Details
			$Details = @()
			$DetailObjects = New-Object -TypeName System.Management.Automation.PSObject
			$DetailObjects | Add-Member -Name "Make" -MemberType NoteProperty -Value $Make
			$DetailObjects | Add-Member -Name "Model" -MemberType NoteProperty -Value $Model
			$DetailObjects | Add-Member -Name "Name" -MemberType NoteProperty -Value $Name
			$DetailObjects | Add-Member -Name "CurrentHealth" -MemberType NoteProperty -Value $CurrentHealth
			$DetailObjects | Add-Member -Name "LowHealth" -MemberType NoteProperty -Value $LowHealth
			$DetailObjects | Add-Member -Name "ReplaceBatteryCount" -MemberType NoteProperty -Value $ReplaceBatteryCount
			$DetailObjects | Add-Member -Name "SerialNumber" -MemberType NoteProperty -Value $SerialNumber
			$Details += $DetailObjects
			
			# Export Array As CSV
			$Details | Export-Csv -Path ($ModelReportDir + "\" + $ModelDetailsFile) -Force -NoTypeInformation
		}
	}
	Return $ReplaceBattery
}
CheckBatteryHealth -SendEmailNotice $true -NetWorkReport $true