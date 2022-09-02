using namespace System.Net
param($psItems)

$psItems.function = 'hello4'

Write-Host "Hello $($psItems.Name)! - You ran in $($psItems.function)"

$psItems
