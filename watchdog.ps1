#parameters
$applicationName = ''
$toEmailAddress = ""
$fromEmailAddress = ""
$smtpServer = ""
$smtpPort = 25
$applicationLocation = ""

$badCycleCount = 0
$loop = $true
do
{
    $proccess = Get-Process $applicationName -ErrorAction SilentlyContinue
    #check if application is running
    if($proccess.Responding -and $proccess)
    {
        Write-Host "Process $applicationName is running"
        if($badCycleCount -gt 0)
        {
            Write-Host 'auto restart worked'
            #sends email to notify user that the application is running and sets badCycleCount to 0
            $badCycleCount = 0
            $subject = "Clone successfully recovered"
            $body = "Process $applicationName has been restored"
            Send-MailMessage -to $toEmailAddress -From $fromEmailAddress -Subject $subject -Body $body -SmtpServer $smtpServer -port $smtpPort
             Start-Sleep -Seconds 300 #wait for 5 min
        }
    }
    else
    {
        if($badCycleCount -ge 0 -and $badCycleCount -le 1)
        {
            Write-Host 'auto restarting'
            #Attempts automatic restart of application
            stop-process $applicationName -force
            Start-Process $applicationLocation
            #increments bad cycle count
            $badCycleCount = $badCycleCount + 1
            #send email to notify of automatic restart
            $subject = "Clone crashed automatic recovery action started"
            $body = "Process $applicationName has stopped responding or is not running. Attempting automatic restart."
            Send-MailMessage -to $toEmailAddress -From $fromEmailAddress -Subject $subject -Body $body -SmtpServer $smtpServer -port $smtpPort
            
            #small wait to allow application time to restart
            Start-Sleep -Seconds 30
        }else {
            Write-Host 'manual review'
            #sends email to notify of manual review is requried
            $subject = "Clone crashed manual review required"
            $body = "Process $applicationName has been stopped responding and failed automatic restart for $badCycleCount five minute cycles. Please review manually."
            Send-MailMessage -to $toEmailAddress -From $fromEmailAddress -Subject $subject -Body $body -SmtpServer $smtpServer -port $smtpPort
            Start-Sleep -Seconds 30
        }
    }

   Start-Sleep -Seconds 300
} while($loop -eq $true)
