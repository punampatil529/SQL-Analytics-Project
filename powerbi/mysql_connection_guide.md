# MySQL to Power BI Connection Guide

## Prerequisites

### 1. Install MySQL ODBC Driver
Download and install the MySQL ODBC Driver from the official MySQL website:
- MySQL Connector/ODBC 8.0 (recommended)
- Ensure you install the version that matches your Power BI Desktop architecture (32-bit or 64-bit)

### 2. Configure MySQL Connection
1. Open **ODBC Data Sources** (64-bit) from Windows
2. Click **Add** to create a new data source
3. Select **MySQL ODBC 8.0 Unicode Driver**
4. Configure the connection:
   - **Data Source Name**: SalesAnalyticsDB
   - **Server**: localhost (or your MySQL server address)
   - **User**: analytics_reader
   - **Password**: [your password]
   - **Database**: sales_analytics_db
   - **Port**: 3306

## Connecting Power BI to MySQL

### Step 1: Open Power BI Desktop
1. Launch Power BI Desktop
2. Click **Get Data**
3. Select **Database** > **MySQL database**

### Step 2: Configure Connection
```
Server: localhost:3306
Database: sales_analytics_db
```

### Step 3: Authentication
- Select **Database** authentication
- Enter credentials:
  - Username: analytics_reader
  - Password: [your password]

### Step 4: Select Tables
Choose the following tables for your data model:
- ✅ customers
- ✅ products
- ✅ sales
- ✅ customer_segments_view
- ✅ monthly_sales_summary_view
- ✅ product_performance_view

## Data Model Setup

### Relationships
Power BI should automatically detect relationships, but verify:
- `sales.customer_id` → `customers.customer_id` (Many-to-One)
- `sales.product_id` → `products.product_id` (Many-to-One)

### Key Measures to Create
```dax
// Total Sales
Total Sales = SUM(sales[total_amount])

// Total Orders
Total Orders = COUNT(sales[sale_id])

// Average Order Value
Average Order Value = DIVIDE([Total Sales], [Total Orders])

// Sales Growth (Month over Month)
Sales Growth MoM = 
VAR CurrentMonthSales = [Total Sales]
VAR PreviousMonthSales = CALCULATE([Total Sales], DATEADD(sales[order_date], -1, MONTH))
RETURN DIVIDE(CurrentMonthSales - PreviousMonthSales, PreviousMonthSales)

// Customer Count
Customer Count = DISTINCTCOUNT(sales[customer_id])
```

## Troubleshooting

### Common Issues and Solutions

1. **Connection Failed**
   - Verify MySQL server is running
   - Check firewall settings
   - Ensure MySQL user has proper permissions

2. **ODBC Driver Not Found**
   - Reinstall MySQL ODBC driver
   - Ensure architecture matches (32-bit vs 64-bit)

3. **Authentication Errors**
   - Verify username and password
   - Check user permissions in MySQL
   - Ensure user can connect from the client machine

4. **Slow Performance**
   - Check MySQL indexes are in place
   - Consider creating aggregated views
   - Limit data import to necessary columns only

## Data Refresh Options

### Manual Refresh
- Click **Refresh** in Power BI Desktop
- Use **Refresh Now** in Power BI Service

### Scheduled Refresh (Power BI Service)
1. Publish report to Power BI Service
2. Configure data gateway (if needed)
3. Set up scheduled refresh (daily/hourly)

### Real-time Updates
- Consider using DirectQuery mode for real-time data
- Note: Some Power BI features may be limited with DirectQuery
