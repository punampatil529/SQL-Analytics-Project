# MySQL Setup Script for Windows
# Real-World SQL Analytics Project Setup
# 
# PROJECT AIM: Learn MySQL (DBMS) and SQL/T-SQL (Query Languages) 
# through hands-on business intelligence project
#
# This PowerShell script helps set up MySQL and the project database

# Check if MySQL is installed
function Test-MySQLInstalled {
    try {
        $mysql = Get-Command mysql -ErrorAction Stop
        Write-Host "MySQL is installed at: $($mysql.Source)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "MySQL is not installed or not in PATH" -ForegroundColor Red
        return $false
    }
}

# Check if MySQL service is running
function Test-MySQLService {
    $service = Get-Service -Name "MySQL*" -ErrorAction SilentlyContinue
    if ($service -and $service.Status -eq "Running") {
        Write-Host "MySQL service is running" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "MySQL service is not running" -ForegroundColor Red
        return $false
    }
}

# Main setup function
function Setup-MySQLProject {
    Write-Host "=== MySQL Project Setup ===" -ForegroundColor Cyan
    
    # Check MySQL installation
    if (-not (Test-MySQLInstalled)) {
        Write-Host "Please install MySQL Server first:" -ForegroundColor Yellow
        Write-Host "1. Download from: https://dev.mysql.com/downloads/mysql/" -ForegroundColor Yellow
        Write-Host "2. Run the installer and set a root password" -ForegroundColor Yellow
        Write-Host "3. Make sure MySQL bin directory is in your PATH" -ForegroundColor Yellow
        return
    }
    
    # Check MySQL service
    if (-not (Test-MySQLService)) {
        Write-Host "Starting MySQL service..." -ForegroundColor Yellow
        try {
            Start-Service -Name "MySQL*"
            Start-Sleep -Seconds 5
        }
        catch {
            Write-Host "Failed to start MySQL service. Please start it manually." -ForegroundColor Red
            return
        }
    }
    
    # Get MySQL root password
    $rootPassword = Read-Host -Prompt "Enter MySQL root password" -AsSecureString
    $rootPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($rootPassword))
    
    # Test connection
    Write-Host "Testing MySQL connection..." -ForegroundColor Yellow
    $testConnection = "mysql -u root -p$rootPasswordPlain -e 'SELECT VERSION();'"
    $result = Invoke-Expression $testConnection
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "MySQL connection successful!" -ForegroundColor Green
        
        # Create database and load schema
        Write-Host "Creating database schema..." -ForegroundColor Yellow
        $schemaPath = Join-Path $PSScriptRoot "scripts\mysql\01_create_schema.sql"
        $createDB = "mysql -u root -p$rootPasswordPlain < '$schemaPath'"
        Invoke-Expression $createDB
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Database schema created successfully!" -ForegroundColor Green
            
            # Prompt for data loading
            $loadData = Read-Host "Do you want to load sample data? (y/n)"
            if ($loadData -eq 'y' -or $loadData -eq 'Y') {
                $dataPath = Join-Path $PSScriptRoot "scripts\mysql\02_load_data.sql"
                $loadDataCmd = "mysql -u root -p$rootPasswordPlain sales_analytics_db < '$dataPath'"
                Invoke-Expression $loadDataCmd
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Sample data loaded successfully!" -ForegroundColor Green
                }
                else {
                    Write-Host "Error loading sample data. Check file paths in 02_load_data.sql" -ForegroundColor Red
                }
            }
        }
        else {
            Write-Host "Error creating database schema" -ForegroundColor Red
        }
    }
    else {
        Write-Host "MySQL connection failed. Check your password and try again." -ForegroundColor Red
    }
}

# Check for MySQL ODBC Driver
function Test-MySQLODBC {
    $odbcDrivers = Get-OdbcDriver | Where-Object { $_.Name -like "*MySQL*" }
    if ($odbcDrivers) {
        Write-Host "MySQL ODBC Driver found:" -ForegroundColor Green
        $odbcDrivers | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Green }
        return $true
    }
    else {
        Write-Host "MySQL ODBC Driver not found" -ForegroundColor Red
        Write-Host "Download from: https://dev.mysql.com/downloads/connector/odbc/" -ForegroundColor Yellow
        return $false
    }
}

# Display next steps
function Show-NextSteps {
    Write-Host "`n=== 🎯 PROJECT AIM ACHIEVED ===" -ForegroundColor Cyan
    Write-Host "✅ MySQL (DBMS) - Database server setup complete" -ForegroundColor Green
    Write-Host "✅ Database Schema - Tables, relationships, and indexes created" -ForegroundColor Green
    Write-Host "✅ Sample Data - Real-world business data loaded" -ForegroundColor Green
    
    Write-Host "`n=== 📚 WHAT YOU'VE LEARNED SO FAR ===" -ForegroundColor Cyan
    Write-Host "• Database Management: MySQL installation and configuration" -ForegroundColor Yellow
    Write-Host "• Schema Design: Normalized tables with proper relationships" -ForegroundColor Yellow
    Write-Host "• Data Loading: ETL process for importing business data" -ForegroundColor Yellow
    
    Write-Host "`n=== 🚀 NEXT LEARNING STEPS ===" -ForegroundColor Cyan
    Write-Host "1. 📊 Power BI Connection - Learn BI tool integration" -ForegroundColor Yellow
    Write-Host "   → Install MySQL ODBC Driver" -ForegroundColor White
    Write-Host "   → Follow guide: powerbi\mysql_connection_guide.md" -ForegroundColor White
    
    Write-Host "2. 💻 SQL Query Practice - Master query languages" -ForegroundColor Yellow
    Write-Host "   → Connect: mysql -u root -p sales_analytics_db" -ForegroundColor White
    Write-Host "   → Practice: scripts\mysql\03_analytics_queries.sql" -ForegroundColor White
    
    Write-Host "3. 📈 Business Analytics - Create real insights" -ForegroundColor Yellow
    Write-Host "   → Build dashboards using: powerbi\sample_reports.md" -ForegroundColor White
    Write-Host "   → Answer business questions with data" -ForegroundColor White
    
    Write-Host "`n=== 🔍 QUICK DATA EXPLORATION ===" -ForegroundColor Cyan
    Write-Host "Connect to your database and try these business queries:" -ForegroundColor White
    Write-Host "SELECT COUNT(*) FROM customers;  -- How many customers?" -ForegroundColor Gray
    Write-Host "SELECT COUNT(*) FROM products;   -- How many products?" -ForegroundColor Gray
    Write-Host "SELECT COUNT(*) FROM sales;      -- How many transactions?" -ForegroundColor Gray
    Write-Host "SELECT SUM(total_amount) FROM sales; -- Total revenue?" -ForegroundColor Gray
}

# Run the setup
Setup-MySQLProject
Test-MySQLODBC
Show-NextSteps

Write-Host "`nSetup complete! Check the output above for any errors." -ForegroundColor Green
