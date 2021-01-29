if ($Args.Count -eq 0) {
    Write-Host "md5 <filepath> [<otherFilepath>]"`n
} elseif ($Args.Count -eq 1) {
    (Get-FileHash $Args[0] -Algorithm "MD5").Hash
} else {
    if ($(md5 $Args[0]) -eq $(md5 $Args[1])) {
        Write-Host "MD5 is the same!"`n
    } else {
        Write-Host "MD5 isn't the same!"`n
    }
}