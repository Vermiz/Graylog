#!/usr/bin/pwsh
#Run this script one time on day

$user = "USER"
$Pass = Get-Content "CREDENTIAL FILE LOCATION" | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $Pass

Connect-ExchangeOnline -Credential $cred

$rightNow = Get-Date -format "MM/dd/yyyy HH:mm:ss"
$24HoursAgo = (Get-Date $rightNow).AddHours(-24)
$messageList = @() # Full contents of the trace will go here
$page = 1
$pageSize = 5000
$datestring = (Get-Date).ToString("s").Replace(":","-")

do
{
    #Write-Output "Getting page $page of messages...
    $messagesThisPage = Get-MessageTrace -StartDate $24HoursAgo -EndDate $rightNow -PageSize $pageSize -Page $page

    #Write-Output "There were $($messagesThisPage.count) messages on page $page..."
    $messageList += $messagesThisPage

    $page++
}
until ($messagesThisPage.count -lt $pageSize)

Write-Output "Message trace returned $($messageList.count) messages total."
$messageList | Export-Csv "/srv/log/messagetrace/$datestring.csv" -NoTypeInformation
#Import to Graylog using nxloga
Remove-Item -Path "/srv/log/messagetrace/Graylog/import.csv"
Copy-Item "/srv/log/messagetrace/$datestring.csv" -Destination "/srv/log/messagetrace/Graylog/import.csv"

Disconnect-ExchangeOnline -Confirm:$false
Exit
