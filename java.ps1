PARAM (
    [parameter(Mandatory=$false)][int] $choiceNum
)

. "$PSScriptRoot\scripts\find-exe.ps1"

$exeLocs = @(
    "Oracle/*jdk*",
    "Oracle/*jre*",
    "*Adoptium*/*jdk*",
    "*Adoptium*/*jre*",
    "*AdoptOpenJDK*/*jdk*",
    "*AdoptOpenJDK*/*jre*"
)
function Find-AllJava() {
    return Find-Defaults $exeLocs
}

function Show-Help() {
    Write-Host "Usage: activate-java [choiceNum]`n"
    Write-Host -NoNewline "Example: "
    Write-Host -ForegroundColor Magenta "activate-java 1`n"
    Write-Host "Available:"
    $results = Find-AllJava
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

    $binPath = Join-Path $loc -ChildPath bin
    
    # Set Path
    $Env:JAVA_HOME = "$loc"
    $Env:PATH = "$binPath;$Env:PATH"
}

## =========== START ===========

IF (!$PSBoundParameters.ContainsKey('choiceNum')) {
    Show-Help
    RETURN
}

$all_paths = Find-AllJava
IF ($choiceNum -ge $all_paths.length) {
    Write-Host -ForegroundColor Red "[ERROR] Given choice $choiceNum is out of range!`n"
    RETURN
}

$java_path = $all_paths[$choiceNum]
Activate $java_path

RETURN
