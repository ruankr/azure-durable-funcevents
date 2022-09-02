using namespace System.Net
param($Context)
Write-Host "[orch] Using IP: $((Invoke-WebRequest -Uri "ifconfig.me/ip" -Method Get).Content) within process $($PID)"

$output = @()

# Removed timeout as Wait-DurableTask does not allow for conditionals ie. if timeout before gate1 AND gate2 then timeout. -Any goes on first one in logic, whereas it needs to bea able
# to wair for 1 or many and/or timeout. Need to find a way around this.
# $timeoutDuration = New-TimeSpan -Seconds 15
# $waitTimeout = Start-DurableTimer -Duration $timeoutDuration -NoWait

$gate1 = Start-DurableExternalEventListener -EventName "Paris" -NoWait
$gate2 = Start-DurableExternalEventListener -EventName "London" -NoWait

$output = Invoke-DurableActivity -FunctionName 'Hello' -Input $Context.Input
$output1 = Invoke-DurableActivity -FunctionName 'Hello1' -Input $output

$endResults = Wait-DurableTask -Task @($gate1, $gate2)


$finaloutput += Invoke-ActivityFunction -FunctionName 'Bye' -Input $output1
$finaloutput