PARAM (
    [int] $version,
    [string] $provider
)

function Get-Provider ($provider) {
    IF ($provider -like "mini") {
        RETURN "Miniconda"
    } ELSE {
        RETURN "Anaconda"
    }
}

function Get-All-Conda () {
    RETURN Get-ChildItem "${env:USERPROFILE}/Miniconda*", "${env:USERPROFILE}/Anaconda*", `
            "C:/ProgramData/Miniconda*", "D:/ProgramData/Miniconda*", `
            "C:/ProgramData/Anaconda*", "D:/ProgramData/Anaconda*", `
            "C:/Miniconda*", "D:/Miniconda*", `
            "C:/Anaconda*", "D:/Anaconda*" `
            | % { $_.FullName }
}

function Get-Conda ($version, $provider) {
    $conda_paths = Get-All-Conda

    # Match by provider
    $provider_paths = @($conda_paths) -match $provider_dir #case insensitive

    # Match by version
    $version_paths = @($provider_paths) -match "conda$($version)"
    RETURN $version_paths
}

function activate($loc) {
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    (& "$loc" "shell.powershell" "hook") | Out-String | Invoke-Expression
    #endregion

    Write-Host -NoNewline "Activated "
    Write-Host -ForegroundColor Magenta $loc`n
}

IF (!$PSBoundParameters.ContainsKey('version')) {
    Write-Host "Usage: activate-conda <2|3> [mini]`n"
    Write-Host -NoNewline "Example: "
    Write-Host -ForegroundColor Magenta "activate-conda 3 mini`n"
    Write-Host "Available:"
    Write-Host `t$($(Get-All-Conda) -join "`n`t")`n
    RETURN
}

$provider_dir = Get-Provider $provider
$conda_paths = @(Get-Conda $version $provider_dir)

IF ($conda_paths.length -eq 0) {
    Write-Host -ForegroundColor Red "[ERROR] $provider_dir $version not found!`n"
    RETURN
} 

IF ($conda_paths.length -gt 1) {
    Write-Host "More than 1 path found:"
    Write-Host `t$($conda_paths -join "`n")`n
    Write-Host "Using the first on the list."
} 
$conda_path = $conda_paths[0]
activate "$conda_path\Scripts\conda.exe"
activate-starship

RETURN
