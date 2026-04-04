# Auto Git Push Script
Set-Location "C:\Users\anr_l\Desktop\gaga\itsec-shell-automation"

git add .
git commit -m "Auto update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 
git push