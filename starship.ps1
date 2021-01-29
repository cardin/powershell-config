$ENV:STARSHIP_CONFIG = "$PSScriptRoot/starship.toml"
Invoke-Expression (&starship init powershell)
