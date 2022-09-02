using namespace System.Net
param($name)


Write-Host "Hello $($name.Name)"

Start-Sleep -Seconds 35
Send-DurableExternalEvent -InstanceId $($name.runId) -EventName "Paris" -AppCode $env:funcKey

$name