PARAM (
    [parameter(Mandatory=$false)][int] $choiceNum
)

. "$PSScriptRoot\scripts\find-exe.ps1"

$exeLocs = @(
    "node-*"
)
function Find-AllNode() {
    return Find-Defaults $exeLocs
}

function Show-Help() {
    Write-Host "Usage: activate-node [choiceNum]`n"
    Write-Host -NoNewline "Example: "
    Write-Host -ForegroundColor Magenta "activate-nodejs 1`n"
    Write-Host "Available:"
    $results = Find-AllNode
    if ($results.Length -gt 0) {
        $results | % {$i = 0} {
           Write-Host "`t$($i):`t $_"
           $i++
       }
       Write-Host "`n"
    } else {
        Write-Host "-"
    }
}

function Activate($loc) {
    Write-Host -NoNewline "Setting `$env to "
    Write-Host -ForegroundColor Magenta "$loc`n"

    # Set Path
    $Env:PATH = "$loc;$Env:PATH"
}

## =========== START ===========

IF (!$PSBoundParameters.ContainsKey('choiceNum')) {
    Show-Help
    RETURN
}

$all_paths = Find-AllNode
IF ($choiceNum -ge $all_paths.length) {
    Write-Host -ForegroundColor Red "[ERROR] Given choice $choiceNum is out of range!`n"
    RETURN
}

$node_path = $all_paths[$choiceNum]
Activate $node_path

RETURN
