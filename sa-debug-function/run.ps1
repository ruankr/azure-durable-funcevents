using namespace System.Net
using namespace System.IO

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "Running debug function to determine modules and versions"

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

# Get Loaded Assemblies
if ($Request.Query.Assemblies) {
    $assemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()
    $null = $obj
    $obj = @()

    foreach ($assembly in $assemblies) {
        $temp = $assembly -split ','
        $props = [ordered]@{
            name           = $temp[0]
            version        = ($temp[1] -split "=")[1]
            Culture        = ($temp[2] -split "=")[1]
            PublicKeyToken = ($temp[3] -split "=")[1]
            Location       = $assembly.Location
        }
        $obj += New-Object PsObject -Property $props
    }
    $assembliesLoaded = $obj | Sort-Object -Property Name | Format-Table -Wrap
}

# Get Runspace details
$null = $runObj
$runObj = [PSCustomObject](@{
        ProcessId      = $PID
        HostInstanceId = $HOST.InstanceId
        Runspace       = $HOST.Runspace.Name
        HomeLocation   = $env:HOME
    }).GetEnumerator() | Sort-Object -Property Name | Format-Table -Wrap

# Output results
Write-Output "Getting PowerShell Module"
$displayResult = ((@{
            Modules      = Get-Module | Select-Object Name, Version, ModuleBase | Sort-Object -Property Name | Format-Table -Wrap
            Version      = $PSVersionTable | Select-Object PSVersion, PSEdition, Platform | Format-Table -Wrap
            Assemblies   = $assembliesLoaded
            RunspaceInfo = $runObj
            FuncOs       = [environment]::OSVersion
        }).GetEnumerator() | Sort-Object -Property Name).Value | Out-String
#Write-output `n$result.values

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $displayResult
    })