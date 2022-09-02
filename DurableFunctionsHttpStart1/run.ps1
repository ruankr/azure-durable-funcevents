using namespace System.Net

param($Request, $TriggerMetadata)

$runId = (New-Guid).Guid

$inputs = @{
    Name  = "$($Request.Query.Name)"
    runId = $runId
    url   = $TriggerMetadata.Request.Url
}

$FunctionName = $Request.Params.FunctionName
$InstanceId = Start-DurableOrchestration -FunctionName $FunctionName -Input $inputs -InstanceId $runId
Write-Host "Started orchestration with ID = '$InstanceId'"

$Response = New-DurableOrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId
Push-OutputBinding -Name Response -Value $Response
