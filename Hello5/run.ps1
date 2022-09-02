using namespace System.Net
param($psItems)

$psItems.function = 'hello5'

Write-Host "Hello $($psItems.Name)! - You ran in $($psItems.function)"

Write-Host "!!!!!!!!!!!!! Sending message !!!!!!!!!!!!!!!!"
Send-DurableExternalEvent -InstanceId $($psItems.tposRunId) -EventName "London" -verbose
Write-Host "!!!!!!!!!!!!! Sent message !!!!!!!!!!!!!!!!"
$psItems