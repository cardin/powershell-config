PARAM (
    [parameter(Mandatory=$false)][int] $choiceNum
)

. "$PSScriptRoot\scripts\find-exe.ps1"

$exeLocs = @(
    "Miniconda*",
    "Anaconda*",
    "ProgramData/Miniconda*",
    "ProgramData/Anaconda*"
)
function Find-AllConda() {
    return Find-Defaults $exeLocs
}

function Show-Help() {
    Write-Host "Usage: activate-conda [choiceNum]`n"
    Write-Host -NoNewline "Example: "
    Write-Host -ForegroundColor Magenta "activate-conda 1`n"
    Write-Host "Available:"
    $results = Find-AllConda
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
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    (& "$loc" "shell.powershell" "hook") | Out-String | Invoke-Expression
    #endregion

    Write-Host -NoNewline "Activated "
    Write-Host -ForegroundColor Magenta $loc`n
}

## =========== START ===========

IF (!$PSBoundParameters.ContainsKey('choiceNum')) {
    Show-Help
    RETURN
}

$all_paths = Find-AllConda
IF ($choiceNum -ge $all_paths.length) {
    Write-Host -ForegroundColor Red "[ERROR] Given choice $choiceNum is out of range!`n"
    RETURN
}

$conda_path = Join-Path $all_paths[$choiceNum] -ChildPath "\Scripts\conda.exe"
if (-Not $(Test-Path $conda_path)) {
    Write-Host -ForegroundColor Red "[ERROR] $conda_path not found!`n"
    RETURN
}
Activate "$conda_path"
activate-starship

RETURN
