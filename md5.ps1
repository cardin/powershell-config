if ($Args.Count -eq 0) {
    Write-Host "Usage: md5 <filepath> [<otherFilepath>]"`n
    Write-Host -NoNewline "Examples: "
    Write-Host -ForegroundColor Magenta "md5 C:/file.txt`n"
    Write-Host -ForegroundColor Magenta "md5 C:/file.txt C:/fileClone.txt`n"
    RETURN
}

if ($Args.Count -eq 1) {
    (Get-FileHash $Args[0] -Algorithm "MD5").Hash
} else {
    if ($(md5 $Args[0]) -eq $(md5 $Args[1])) {
        Write-Host "MD5 is the same!"`n
    } else {
        Write-Host "MD5 isn't the same!"`n
    }
}
