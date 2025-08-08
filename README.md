# SQL Analytics Project

## 🎯 Project Overview

This project demonstrates a complete SQL analytics solution using MySQL database with Power BI integration for business intelligence and data visualization. 

**📋 [Read the Complete Project Aim & Learning Objectives](PROJECT_AIM.md)**

### Real-World Business Scenario
You'll work as a **Data Analyst** for a global electronics retailer, solving actual business challenges:
- Analyzing sales performance across product categories
- Understanding customer behavior and segmentation  
- Creating executive dashboards for decision-making
- Optimizing inventory and forecasting trends

A comprehensive sales analytics system that includes:
- MySQL database with normalized schema (DBMS)
- Advanced SQL queries and T-SQL compatibility (Query Languages)
- Sample data for customers, products, and sales transactions
- Advanced analytics queries and views
- Power BI dashboards and reports
- Complete setup and configuration guides

## Prerequisites

### Required Software
1. **MySQL Server 8.0+**
   - Download from: https://dev.mysql.com/downloads/mysql/
   - Install MySQL Workbench (optional but recommended)

2. **Power BI Desktop**
   - Download from: https://powerbi.microsoft.com/desktop/
   - Free version available

3. **MySQL ODBC Driver 8.0**
   - Download from: https://dev.mysql.com/downloads/connector/odbc/
   - Required for Power BI connectivity

## Project Structure

```
SQL Project/
├── README.md                          # This file
├── data/                             # Sample data files
│   ├── customers.csv
│   ├── products.csv
│   └── sales.csv
├── scripts/
│   ├── mysql/                        # MySQL specific scripts
│   │   ├── 01_create_schema.sql      # Database and table creation
│   │   ├── 02_load_data.sql         # Data loading scripts
│   │   └── 03_analytics_queries.sql  # Sample analytics queries
│   ├── t-sql/                        # T-SQL scripts (for reference)
│   │   ├── 01_create_schema.sql
│   │   ├── 02_load_data.sql
│   │   └── 03_analytics_queries.sql
│   └── mysql_config/                 # MySQL configuration
│       └── azure_sql_config.md       # MySQL configuration guide
└── powerbi/                          # Power BI related files
    ├── README.md
    ├── mysql_connection_guide.md
    └── sample_reports.md
```

## Technologies Used

- **MySQL**: Primary database for data storage and analytics
- **Power BI Desktop**: Data visualization and business intelligence
- **MySQL ODBC Driver**: Database connectivity
- **T-SQL**: Alternative scripts for SQL Server compatibility

## Quick Setup Instructions

### Step 1: Install MySQL
1. Download and install MySQL Server
2. During installation, set root password (remember this!)
3. Start MySQL service
4. Install MySQL Workbench (optional)

### Step 2: Create Database and Schema
```bash
# Connect to MySQL
mysql -u root -p

# Run the schema creation script
source /path/to/scripts/mysql/01_create_schema.sql
```

### Step 3: Load Sample Data
1. Place CSV files in a location accessible to MySQL
2. Update file paths in `02_load_data.sql`
3. Execute the data loading script:
```sql
source /path/to/scripts/mysql/02_load_data.sql
```

### Step 4: Set Up Power BI Connection
1. Install MySQL ODBC Driver
2. Follow the guide in `powerbi/mysql_connection_guide.md`
3. Connect Power BI to your MySQL database
4. Import tables and create relationships

### Step 5: Create Visualizations
Follow the specifications in `powerbi/sample_reports.md` to create dashboards

## Key Features

- **Comprehensive Database Schema**: Normalized tables for customers, products, and sales
- **Sample Analytics Queries**: Pre-built queries for common business insights
- **Power BI Integration**: Complete guide for connecting and visualizing data
- **Dashboard Templates**: Executive, Sales, Customer, and Product analytics dashboards
- **Performance Optimization**: Indexes and views for efficient querying
- **Data Security**: Role-based access control and user management
