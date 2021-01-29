if ($Args.Count -eq 0) {
    Write-Host "reset-env <env_var> [...]"
} else {
    foreach ($arg in $args) {
        Write-Host "Updating $arg"
        Set-Item `
            -Path (('Env:', $arg) -join '') `
            -Value ((
                [System.Environment]::GetEnvironmentVariable($arg, "Machine"),
                [System.Environment]::GetEnvironmentVariable($arg, "User")
            ) -match '.' -join ';')
    }
}