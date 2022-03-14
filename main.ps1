Set-Alias which Get-Command
Set-Alias powershell pwsh
Set-Alias powershell.exe pwsh
Set-Alias vi vim
Set-Alias wc Measure-Object

Set-Alias reset-env "$PSScriptRoot/reset-env.ps1"
Set-Alias md5 "$PSScriptRoot/md5.ps1"

Set-Alias activate-conda "$PSScriptRoot/conda.ps1"
Set-Alias activate-java "$PSScriptRoot/java.ps1"
Set-Alias activate-node "$PSScriptRoot/nodejs.ps1"
Set-Alias activate-starship "$PSScriptRoot/starship.ps1"

$isRoot = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isRoot) {
    $env:starshipIsRoot = $isRoot
}

if ($PSVersionTable.PSVersion.Major -gt 5) {
    $host.UI.RawUI.WindowTitle = Split-Path (pwd) -Leaf
    $ExecutionContext.InvokeCommand.LocationChangedAction = {
        $host.UI.RawUI.WindowTitle = Split-Path (pwd) -Leaf
    }
}

Set-PSReadLineKeyHandler -Chord Ctrl+b -ScriptBlock {
    # Shortcut Key to swap backslash with forward slash
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $line = $line.Replace("\", "/")

    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($line)
}

function helpMe() {
    Write-Host "## Commands (helpMe):"
    Write-Host "`t> nvm*, activate-[conda|java|node]"
    Write-Host "`t> z, md5, reset-env, bash, gsudo*"
    Write-Host "`t> rg <pattern> [-g <glob>] [-i] [-v] [-B|A|C <lines>] [-l] [-c] [--no-ignore] [--hidden]"
    Write-Host "`t> fd <pattern> [<dir>] [-e <ext>] [-g <glob>] [--no-ignore] [--hidden] [--full-path]`n"
}
helpMe

activate-starship
Import-Module ZLocation
