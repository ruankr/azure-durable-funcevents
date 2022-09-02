using namespace System.Net
param($name)


Write-Host "Hello $($name.Name)"

Start-Sleep -Seconds 35
#Send-DurableExternalEvent -InstanceId $($name.runId) -EventName "Madrid" -AppCode $env:funcKey

$eventName = "Madrid"
$FunctionURL = $name.Url
$FunctionURL = $FunctionURL.split('/api')[0]
$URL = $FunctionURL + "/runtime/webhooks/durabletask/instances/$($name.runId)/raiseEvent/$($eventName)?code=" + $Env:funcKey

Invoke-RestMethod $URL -Method Post -ContentType 'application/json' -Body '{}' | Out-Null

$name

$psItems
