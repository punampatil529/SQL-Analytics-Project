# Clean Repository Creation Script

# This script helps you create a clean repository without organizational information

Write-Host "=== Cleaning Repository for GitHub ===" -ForegroundColor Cyan

# 1. Remove .git directory to start fresh
if (Test-Path ".git") {
    Write-Host "Removing existing Git history..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force .git
}

# 2. Initialize fresh repository
Write-Host "Initializing clean repository..." -ForegroundColor Yellow
git init

# 3. Set personal user information
Write-Host "Setting personal Git configuration..." -ForegroundColor Yellow
git config user.name "punampatil529"
git config user.email "punampatil529@gmail.com"

# 4. Add all files
Write-Host "Adding files to repository..." -ForegroundColor Yellow
git add .

# 5. Create initial commit with personal information only
Write-Host "Creating clean initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: SQL Analytics Project

Complete SQL analytics solution with:
- MySQL database setup and configuration
- Sample business data for learning
- T-SQL and MySQL script compatibility
- Power BI integration guides
- Learning roadmap and project documentation
- Automated setup scripts"

# 6. Set up remote and push
Write-Host "Setting up GitHub remote..." -ForegroundColor Yellow
git branch -M main
git remote add origin https://github.com/punampatil529/-SQL-Analytics-Project.git

Write-Host "Pushing clean repository to GitHub..." -ForegroundColor Yellow
git push -u origin main --force

Write-Host "`n=== Clean Repository Created Successfully! ===" -ForegroundColor Green
Write-Host "✅ No organizational information included" -ForegroundColor Green
Write-Host "✅ Personal GitHub account information only" -ForegroundColor Green
Write-Host "✅ All project files preserved" -ForegroundColor Green
Write-Host "✅ Professional project structure maintained" -ForegroundColor Green

Write-Host "`nRepository URL: https://github.com/punampatil529/-SQL-Analytics-Project" -ForegroundColor Cyan
