# MySQL Database Configuration

## Connection Settings
- **Host**: `localhost` or `your-mysql-server.com`
- **Port**: `3306`
- **Database**: `sales_analytics_db`
- **Authentication**: MySQL Native Authentication

## Connection String Examples

### MySQL Connection String
```
Server=localhost;Port=3306;Database=sales_analytics_db;Uid=your-username;Pwd=your-password;SslMode=Required;
```

### ODBC Connection String
```
DRIVER={MySQL ODBC 8.0 Unicode Driver};SERVER=localhost;PORT=3306;DATABASE=sales_analytics_db;UID=your-username;PWD=your-password;
```

### Power BI Connection
```
Data Source: localhost:3306
Database: sales_analytics_db
Authentication: MySQL Database Authentication
```

## Security Configuration

### MySQL User Management
- Configure MySQL users with appropriate privileges:
  - Your development machine IP
  - Power BI service connection
  - Local network access

### Access Control
1. Create database users for different roles:
   - `analytics_reader`: SELECT permissions on all tables and views
   - `data_loader`: INSERT, UPDATE permissions for ETL processes
   - `admin_user`: Full database permissions

```sql
-- Create users with specific roles
CREATE USER 'analytics_reader'@'%' IDENTIFIED BY 'secure_password';
CREATE USER 'data_loader'@'%' IDENTIFIED BY 'secure_password';
CREATE USER 'admin_user'@'%' IDENTIFIED BY 'secure_password';

-- Grant permissions
GRANT SELECT ON sales_analytics_db.* TO 'analytics_reader'@'%';
GRANT SELECT, INSERT, UPDATE ON sales_analytics_db.* TO 'data_loader'@'%';
GRANT ALL PRIVILEGES ON sales_analytics_db.* TO 'admin_user'@'%';
```

## Performance Optimization

### MySQL Configuration
- **Memory Settings**: Adjust `innodb_buffer_pool_size` based on available RAM
- **Connection Limits**: Set appropriate `max_connections` value
- **Query Cache**: Enable query cache for read-heavy workloads

### Indexing Strategy
```sql
-- Additional indexes for better query performance
CREATE INDEX idx_sales_order_date_customer 
ON sales(order_date, customer_id);

CREATE INDEX idx_customers_country_segment 
ON customers(country, customer_segment);

CREATE INDEX idx_products_category 
ON products(category);
```

## Backup and Disaster Recovery

### MySQL Backup Strategy
- **Daily Backups**: Use `mysqldump` for full database backups
- **Binary Log**: Enable binary logging for point-in-time recovery
- **Replication**: Set up master-slave replication for high availability

```bash
# Example backup command
mysqldump -u admin_user -p --single-transaction --routines --triggers sales_analytics_db > backup_$(date +%Y%m%d).sql
```

### MySQL Replication
- Configure master-slave replication for high availability
- Consider read replicas for reporting workloads to reduce load on primary server

## Monitoring and Performance Tuning

### Key Metrics to Monitor
- CPU and memory utilization
- Disk I/O performance
- Connection count
- Slow query log analysis

### MySQL Performance Schema
```sql
-- Enable performance schema for monitoring
UPDATE performance_schema.setup_instruments 
SET ENABLED = 'YES', TIMED = 'YES' 
WHERE NAME LIKE '%statement/%';

-- Query to find slow queries
SELECT * FROM performance_schema.events_statements_summary_by_digest 
ORDER BY avg_timer_wait DESC LIMIT 10;
```

## Data Loading Options

### CSV Data Import
```sql
-- Load data from CSV files
LOAD DATA INFILE '/path/to/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

### ETL Process with MySQL
- Use MySQL Workbench for visual data modeling
- Implement stored procedures for data transformation
- Schedule data loads using MySQL Event Scheduler

```sql
-- Example event scheduler for daily data load
CREATE EVENT daily_data_load
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
  CALL load_daily_sales_data();
```
