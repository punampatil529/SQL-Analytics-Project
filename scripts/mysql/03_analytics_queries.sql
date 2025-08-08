-- MySQL Analytics and Reporting Queries
-- This script contains various analytical queries for business intelligence

USE SalesAnalyticsDB;

-- 1. Monthly Sales Summary
SELECT 
    YEAR(OrderDate) as SalesYear,
    MONTH(OrderDate) as SalesMonth,
    MONTHNAME(OrderDate) as MonthName,
    COUNT(*) as TotalOrders,
    SUM(TotalAmount) as TotalRevenue,
    AVG(TotalAmount) as AverageOrderValue,
    COUNT(DISTINCT CustomerID) as UniqueCustomers
FROM Sales
GROUP BY YEAR(OrderDate), MONTH(OrderDate), MONTHNAME(OrderDate)
ORDER BY SalesYear, SalesMonth;

-- 2. Customer Segment Analysis
SELECT 
    c.CustomerSegment,
    COUNT(DISTINCT c.CustomerID) as CustomerCount,
    COUNT(s.CustomerID) as TotalOrders,
    COALESCE(SUM(s.TotalAmount), 0) as TotalRevenue,
    COALESCE(AVG(s.TotalAmount), 0) as AverageOrderValue,
    COALESCE(SUM(s.TotalAmount) / COUNT(DISTINCT c.CustomerID), 0) as RevenuePerCustomer
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerSegment
ORDER BY TotalRevenue DESC;

-- 3. Product Category Performance
SELECT 
    p.Category,
    COUNT(DISTINCT p.ProductID) as ProductCount,
    COALESCE(SUM(s.Quantity), 0) as TotalQuantitySold,
    COALESCE(SUM(s.TotalAmount), 0) as TotalRevenue,
    COALESCE(AVG(s.TotalAmount), 0) as AverageOrderValue,
    RANK() OVER (ORDER BY COALESCE(SUM(s.TotalAmount), 0) DESC) as RevenueRank
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;

-- 4. Top 10 Performing Products
SELECT 
    p.ProductName,
    p.Category,
    p.UnitPrice,
    COUNT(s.OrderID) as OrderCount,
    COALESCE(SUM(s.Quantity), 0) as TotalQuantitySold,
    COALESCE(SUM(s.TotalAmount), 0) as TotalRevenue
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.UnitPrice
ORDER BY TotalRevenue DESC
LIMIT 10;

-- 5. Customer Purchase Behavior Analysis
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) as CustomerName,
    c.CustomerSegment,
    c.Country,
    COUNT(s.OrderID) as TotalOrders,
    COALESCE(SUM(s.TotalAmount), 0) as TotalSpent,
    COALESCE(AVG(s.TotalAmount), 0) as AverageOrderValue,
    MIN(s.OrderDate) as FirstPurchase,
    MAX(s.OrderDate) as LastPurchase,
    CASE 
        WHEN MIN(s.OrderDate) IS NOT NULL AND MAX(s.OrderDate) IS NOT NULL 
        THEN DATEDIFF(MAX(s.OrderDate), MIN(s.OrderDate))
        ELSE 0 
    END as CustomerLifespanDays,
    CASE 
        WHEN COALESCE(SUM(s.TotalAmount), 0) > 1000 THEN 'High Value'
        WHEN COALESCE(SUM(s.TotalAmount), 0) > 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as ValueSegment
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.CustomerSegment, c.Country
ORDER BY TotalSpent DESC;

-- 6. Salesperson Performance
SELECT 
    sp.SalespersonID,
    CONCAT(sp.FirstName, ' ', sp.LastName) as SalespersonName,
    sp.Territory,
    sp.Commission,
    COUNT(s.OrderID) as TotalOrders,
    COALESCE(SUM(s.TotalAmount), 0) as TotalSales,
    COALESCE(AVG(s.TotalAmount), 0) as AverageOrderValue,
    COALESCE(SUM(s.TotalAmount) * sp.Commission, 0) as EstimatedCommission
FROM Salespeople sp
LEFT JOIN Sales s ON sp.SalespersonID = s.SalespersonID
GROUP BY sp.SalespersonID, sp.FirstName, sp.LastName, sp.Territory, sp.Commission
ORDER BY TotalSales DESC;

-- 7. Geographical Sales Analysis
SELECT 
    c.Country,
    COUNT(DISTINCT c.CustomerID) as CustomerCount,
    COUNT(s.OrderID) as TotalOrders,
    COALESCE(SUM(s.TotalAmount), 0) as TotalRevenue,
    COALESCE(AVG(s.TotalAmount), 0) as AverageOrderValue
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.Country
ORDER BY TotalRevenue DESC;

-- 8. Daily Sales Trend (for Power BI visualization)
SELECT 
    OrderDate,
    COUNT(*) as DailyOrders,
    SUM(TotalAmount) as DailyRevenue,
    AVG(TotalAmount) as DailyAverageOrder,
    SUM(Quantity) as DailyQuantitySold
FROM Sales
GROUP BY OrderDate
ORDER BY OrderDate;

-- 9. Inventory Stock Analysis
SELECT 
    p.ProductName,
    p.Category,
    p.StockQuantity,
    COALESCE(SUM(s.Quantity), 0) as TotalSold,
    p.StockQuantity - COALESCE(SUM(s.Quantity), 0) as RemainingStock,
    CASE 
        WHEN p.StockQuantity - COALESCE(SUM(s.Quantity), 0) < 10 THEN 'Low Stock'
        WHEN p.StockQuantity - COALESCE(SUM(s.Quantity), 0) < 50 THEN 'Medium Stock'
        ELSE 'High Stock'
    END as StockLevel,
    CASE 
        WHEN COALESCE(SUM(s.Quantity), 0) > 0 
        THEN ROUND((p.StockQuantity - COALESCE(SUM(s.Quantity), 0)) / (COALESCE(SUM(s.Quantity), 0) / DATEDIFF(CURDATE(), '2024-01-15')), 0)
        ELSE NULL 
    END as DaysOfStockRemaining
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.StockQuantity
ORDER BY RemainingStock ASC;

-- 10. Revenue Growth Analysis
SELECT 
    OrderDate,
    SUM(TotalAmount) as DailyRevenue,
    SUM(SUM(TotalAmount)) OVER (ORDER BY OrderDate) as CumulativeRevenue,
    LAG(SUM(TotalAmount)) OVER (ORDER BY OrderDate) as PreviousDayRevenue,
    CASE 
        WHEN LAG(SUM(TotalAmount)) OVER (ORDER BY OrderDate) > 0 
        THEN ROUND(
            ((SUM(TotalAmount) - LAG(SUM(TotalAmount)) OVER (ORDER BY OrderDate)) / LAG(SUM(TotalAmount)) OVER (ORDER BY OrderDate)) * 100, 
            2
        )
        ELSE NULL
    END as DayOverDayGrowthPercent
FROM Sales
GROUP BY OrderDate
ORDER BY OrderDate;

-- 11. Customer Retention Analysis
WITH CustomerOrderDates AS (
    SELECT 
        CustomerID,
        OrderDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) as OrderNumber
    FROM Sales
),
RepeatCustomers AS (
    SELECT 
        CustomerID,
        COUNT(*) as TotalOrders,
        MIN(OrderDate) as FirstOrder,
        MAX(OrderDate) as LastOrder
    FROM CustomerOrderDates
    GROUP BY CustomerID
)
SELECT 
    'Total Customers' as Metric,
    COUNT(*) as Value
FROM RepeatCustomers
UNION ALL
SELECT 
    'Repeat Customers',
    COUNT(*)
FROM RepeatCustomers
WHERE TotalOrders > 1
UNION ALL
SELECT 
    'One-time Customers',
    COUNT(*)
FROM RepeatCustomers
WHERE TotalOrders = 1
UNION ALL
SELECT 
    'Average Orders per Customer',
    ROUND(AVG(TotalOrders), 2)
FROM RepeatCustomers;

-- 12. Sales Performance by Territory
SELECT 
    sp.Territory,
    COUNT(DISTINCT sp.SalespersonID) as SalespeopleCount,
    COUNT(s.OrderID) as TotalOrders,
    SUM(s.TotalAmount) as TotalRevenue,
    AVG(s.TotalAmount) as AverageOrderValue,
    SUM(s.TotalAmount) / COUNT(DISTINCT sp.SalespersonID) as RevenuePerSalesperson
FROM Salespeople sp
LEFT JOIN Sales s ON sp.SalespersonID = s.SalespersonID
GROUP BY sp.Territory
ORDER BY TotalRevenue DESC;
