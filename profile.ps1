Set-Alias which Get-Command
Set-Alias powershell pwsh
Set-Alias powershell.exe pwsh
Set-Alias grep rg
Set-Alias vi subl
Set-Alias vim subl

Set-Alias reset-env "$PSScriptRoot/reset-env.ps1"
Set-Alias md5 "$PSScriptRoot/md5.ps1"

Set-Alias activate-conda "$PSScriptRoot/conda.ps1"
Set-Alias activate-java "$PSScriptRoot/java.ps1"
Set-Alias activate-starship "$PSScriptRoot/starship.ps1"

$isRoot = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isRoot) {
    $env:starshipIsRoot = $isRoot
}

Write-Host "`t## Commands:"
Write-Host "`t> nvm, activate-conda, activate-java"
Write-Host "`t> z, pushd, md5, reset-env"
Write-Host "`t> rg <pattern> [--glob <string>] -[B|A <num>] [--files [<targetDir>]]`n"

activate-starship
$ExecutionContext.InvokeCommand.LocationChangedAction = {
    $host.UI.RawUI.WindowTitle = Split-Path (pwd) -Leaf
}