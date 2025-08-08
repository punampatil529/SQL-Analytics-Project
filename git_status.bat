@echo off
echo ==============================================
echo       SQL Analytics Project - Git Helper
echo ==============================================

echo.
echo Current Git Status:
git status

echo.
echo Recent Commits:
git log --oneline -5

echo.
echo Remote Repository:
git remote -v

echo.
echo Branch Information:
git branch -a

echo.
echo ==============================================
echo To push changes:
echo 1. git add .
echo 2. git commit -m "Your commit message"  
echo 3. git push origin main
echo ==============================================

pause
