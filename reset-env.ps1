if ($Args.Count -eq 0) {
    Write-Host "Usage: reset-env <env_var> [...]"
    Write-Host -NoNewline "Example: "
    Write-Host -ForegroundColor Magenta "reset-env PATH`n"
    RETURN
} 

foreach ($arg in $args) {
    Write-Host "Updating $arg"
    Set-Item `
        -Path (('Env:', $arg) -join '') `
        -Value ((
            [System.Environment]::GetEnvironmentVariable($arg, "Machine"),
            [System.Environment]::GetEnvironmentVariable($arg, "User")
        ) -match '.' -join ';')
}
