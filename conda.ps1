function activate($loc) {
    #region conda initialize
    # !! Contents within this block are managed by 'conda init' !!
    (& "$loc" "shell.powershell" "hook") | Out-String | Invoke-Expression
    #endregion

    Write-Host -NoNewline "Activated "
    Write-Host -ForegroundColor Magenta $loc`n
}

function get-all-conda() {
    RETURN Get-ChildItem "C:\*Anaconda*", "C:\*miniconda*", `
        "D:\*Anaconda*", "D:\*miniconda*" `
        |% { $_.FullName }
}

$condaLocs = get-all-conda
if ($condaLocs.Count -eq 0) {
    Write-Host "No conda detected at usual paths!"
} elseif ($condaLocs.Count -gt 1) {
    Write-Host "Too many conda detected!"
    Write-Host `t$($condaLocs -join "`n")`n
} else {
    activate "$condaLocs\Scripts\conda.exe"
}
activate-starship