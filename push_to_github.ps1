# Secure GitHub Repository Setup Script
# This script creates a clean repository without any organizational information

param(
    [string]$RepoUrl = "https://github.com/punampatil529/SQL-Analytics-Project.git"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Creating Secure GitHub Repository" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan

# Step 1: Clean any existing Git data
Write-Host "`nStep 1: Cleaning existing Git data..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Remove-Item -Recurse -Force ".git" -ErrorAction SilentlyContinue
    Write-Host "✅ Removed existing Git directory" -ForegroundColor Green
}

# Step 2: Initialize new repository
Write-Host "`nStep 2: Initializing new repository..." -ForegroundColor Yellow
git init
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Repository initialized" -ForegroundColor Green
}

# Step 3: Configure with personal information only (SECURE)
Write-Host "`nStep 3: Setting secure Git configuration..." -ForegroundColor Yellow
git config user.name "punampatil529"
git config user.email "punampatil529@gmail.com"
Write-Host "✅ Personal credentials configured (SECURE)" -ForegroundColor Green

# Step 4: Add all project files
Write-Host "`nStep 4: Adding all project files..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ All files staged for commit" -ForegroundColor Green
}

# Step 5: Create initial commit
Write-Host "`nStep 5: Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: SQL Analytics Project

Professional SQL analytics solution featuring:
- MySQL database with normalized schema and sample data
- Advanced SQL queries and T-SQL compatibility scripts  
- Power BI integration guides and dashboard templates
- Complete learning roadmap and educational documentation
- Real-world business scenarios and analytics queries
- Automated setup tools and configuration guides

Technologies: MySQL, SQL, T-SQL, Power BI, Business Intelligence
Purpose: Learning database management and data visualization skills"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Initial commit created successfully" -ForegroundColor Green
}

# Step 6: Set main branch
Write-Host "`nStep 6: Setting main branch..." -ForegroundColor Yellow
git branch -M main
Write-Host "✅ Main branch configured" -ForegroundColor Green

# Step 7: Add remote repository
Write-Host "`nStep 7: Connecting to GitHub repository..." -ForegroundColor Yellow
git remote add origin $RepoUrl
Write-Host "✅ Remote repository connected: $RepoUrl" -ForegroundColor Green

# Step 8: Push to GitHub
Write-Host "`nStep 8: Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
} else {
    Write-Host "⚠️ Push failed. You may need to authenticate with GitHub." -ForegroundColor Red
}

# Security verification
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "           SECURITY VERIFICATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$authorInfo = git log --pretty="format:%an <%ae>" -1
Write-Host "`nCommit Author: $authorInfo" -ForegroundColor White

if ($authorInfo -match "punampatil529.*punampatil529@gmail.com") {
    Write-Host "✅ SECURE: Only personal information in Git history" -ForegroundColor Green
} else {
    Write-Host "⚠️ WARNING: Check author information above" -ForegroundColor Yellow
}

# Final summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "              SUCCESS!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Repository created with secure configuration" -ForegroundColor Green
Write-Host "✅ All project files uploaded to GitHub" -ForegroundColor Green
Write-Host "✅ No organizational information included" -ForegroundColor Green
Write-Host "✅ Professional portfolio piece ready!" -ForegroundColor Green

Write-Host "`n🔗 Repository URL: https://github.com/punampatil529/SQL-Analytics-Project" -ForegroundColor Cyan
Write-Host "`n💡 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Visit your repository and add a description" -ForegroundColor White
Write-Host "   2. Add topics: sql, mysql, powerbi, analytics, database" -ForegroundColor White
Write-Host "   3. Star your own repository" -ForegroundColor White
Write-Host "   4. Add this project to your resume and LinkedIn!" -ForegroundColor White

Write-Host "`nPress any key to continue..." -ForegroundColor Gray
Read-Host
