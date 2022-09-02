using namespace System.Net
param($psItems)

$psItems.function = 'hello2'

Send-DurableExternalEvent -InstanceId $($psItems.tposRunId) -EventName "Paris" -verbose

$psItems
