PARAM (
    [int] $version,
    [string] $provider
)

function Get-Provider ($provider) {
    IF ($provider -like "Oracle") {
        RETURN "Java"
    } ELSE {
        RETURN "AdoptOpenJDK"
    }
}

function Get-All-Java () {
    RETURN Get-ChildItem "C:/Program Files*/Java/*", "D:/Program Files*/Java/*", `
            "C:/Program Files*/AdoptOpenJDK/*", "D:/Program Files*/AdoptOpenJDK/*" `
            | Where { $_ -match "(jre|jdk)" } `
            | % { $_.FullName }
}

function Get-Java ($version, $provider) {
    $java_paths = Get-All-Java

    # Match by provider
    $provider_paths = @($java_paths) -match $provider_dir #case insensitive

    # Match by version
    $version_paths = @($provider_paths) -match "(jre|jdk)(1\.|\-)$($version)"
    RETURN $version_paths
}

IF (!$PSBoundParameters.ContainsKey('version')) {
    Write-Host "Usage: activate-java <verNumber> [oracle]`n"
    Write-Host -NoNewline "Example: "
    Write-Host -ForegroundColor Magenta "activate-java 11 oracle`n"
    Write-Host "Available:"
    Write-Host `t$($(Get-All-Java) -join "`n`t")`n
    RETURN
}

$provider_dir = Get-Provider $provider
$java_paths = @(Get-Java $version $provider_dir)

IF ($java_paths.length -eq 0) {
    Write-Host -ForegroundColor Red "[ERROR] $provider_dir Java $version not found!`n"
    RETURN
} 

IF ($java_paths.length -gt 1) {
    Write-Host "More than 1 path found:"
    Write-Host `t$($java_paths -join "`n")`n
    Write-Host "Using the first on the list."
} 
$java_path = $java_paths[0]
Write-Host -NoNewline "Setting `$env to "
Write-Host -ForegroundColor Magenta "$java_path`n"

# Set Path
$Env:JAVA_HOME = "$java_path"
$Env:PATH = "$java_path/bin;$Env:PATH"

RETURN