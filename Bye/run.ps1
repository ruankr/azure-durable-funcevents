using namespace System.Net
param($name, $TriggerMetadata)

# $InstanceId = $TriggerMetadata.InstanceId

# Send-DurableExternalEvent -InstanceId $InstanceId -EventName "taskDone"

Write-Host "Bye $name"

$name
