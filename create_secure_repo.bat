@echo off
echo ========================================
echo    Creating Secure GitHub Repository
echo ========================================

echo.
echo Step 1: Cleaning old Git data...
rmdir /s /q .git 2>nul
if exist .git (
    echo Warning: Could not remove .git folder. Please close VS Code and run again.
    pause
    exit
)

echo Step 2: Initializing new repository...
git init

echo Step 3: Setting personal configuration (SECURE)...
git config user.name "punampatil529"
git config user.email "punampatil529@gmail.com"

echo Step 4: Adding all files...
git add .

echo Step 5: Creating secure initial commit...
git commit -m "Initial commit: SQL Analytics Project

Professional SQL analytics solution featuring:
- MySQL database with normalized schema
- Real-world business scenario and sample data  
- T-SQL and MySQL compatibility scripts
- Power BI integration and dashboard guides
- Complete learning roadmap and documentation
- Automated setup and configuration tools

Technologies: MySQL, SQL, T-SQL, Power BI, Business Intelligence
Skills demonstrated: Database design, Query optimization, Data visualization"

echo Step 6: Setting up main branch...
git branch -M main

echo.
echo ========================================
echo Repository ready for GitHub!
echo ========================================
echo.
echo NEXT STEPS:
echo 1. Go to GitHub.com and create new repository named 'SQL-Analytics-Project'
echo 2. Copy the repository URL
echo 3. Run: git remote add origin [YOUR-REPO-URL]  
echo 4. Run: git push -u origin main
echo.
echo SECURITY CHECK:
git log --pretty="Author: %%an <%%ae>" -1
echo.
echo If you see only 'punampatil529 ^<punampatil529@gmail.com^>' above, you're secure!
echo.
pause
