@echo off
echo.
echo ========================================
echo    MoodCommerce — GitHub Upload Script
echo ========================================
echo.

REM Go to project folder
cd "C:\Users\IRFAN\Documents\MoodCommerce"

REM Initialize git if not already done
git init

REM Add all files
echo Adding all files...
git add .

REM Commit
echo Committing files...
git commit -m "MoodCommerce — Full Web Technologies Project"

REM Set main branch
git branch -M main

REM Push to GitHub (replace YOUR_USERNAME with your GitHub username)
echo Pushing to GitHub...
git push -u origin main

echo.
echo ========================================
echo    Upload Complete! Check GitHub!
echo ========================================
echo.
pause
