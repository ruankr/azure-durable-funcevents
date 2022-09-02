using namespace System.Net
param($name)


Write-Host "Hello $($name.Name)"

#Send-DurableExternalEvent -InstanceId $($name.runId) -EventName "London" -AppCode $env:funcKey

$eventName = "London"
$FunctionURL = $name.Url
$FunctionURL = $FunctionURL.split('/api')[0]
$URL = $FunctionURL + "/runtime/webhooks/durabletask/instances/$($name.runId)/raiseEvent/$($eventName)?code=" + $Env:funcKey

Invoke-RestMethod $URL -Method Post -ContentType 'application/json' -Body '{}' | Out-Null

$name
