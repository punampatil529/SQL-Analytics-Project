-- T-SQL Analytics and Reporting Queries
-- This script contains various analytical queries for business intelligence

-- 1. Sales Performance Analysis
-- Monthly sales summary
WITH MonthlySales AS (
    SELECT 
        YEAR(OrderDate) as SalesYear,
        MONTH(OrderDate) as SalesMonth,
        DATENAME(MONTH, OrderDate) as MonthName,
        COUNT(*) as TotalOrders,
        SUM(TotalAmount) as TotalRevenue,
        AVG(TotalAmount) as AverageOrderValue,
        COUNT(DISTINCT CustomerID) as UniqueCustomers
    FROM Sales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
)
SELECT 
    SalesYear,
    SalesMonth,
    MonthName,
    TotalOrders,
    FORMAT(TotalRevenue, 'C') as TotalRevenue,
    FORMAT(AverageOrderValue, 'C') as AverageOrderValue,
    UniqueCustomers,
    LAG(TotalRevenue) OVER (ORDER BY SalesYear, SalesMonth) as PreviousMonthRevenue,
    FORMAT(
        CASE 
            WHEN LAG(TotalRevenue) OVER (ORDER BY SalesYear, SalesMonth) > 0 
            THEN ((TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY SalesYear, SalesMonth)) / LAG(TotalRevenue) OVER (ORDER BY SalesYear, SalesMonth)) * 100
            ELSE 0 
        END, 
        'N2'
    ) + '%' as MonthOverMonthGrowth
FROM MonthlySales
ORDER BY SalesYear, SalesMonth;

-- 2. Customer Segment Analysis
SELECT 
    c.CustomerSegment,
    COUNT(*) as CustomerCount,
    COUNT(s.CustomerID) as TotalOrders,
    FORMAT(SUM(s.TotalAmount), 'C') as TotalRevenue,
    FORMAT(AVG(s.TotalAmount), 'C') as AverageOrderValue,
    FORMAT(SUM(s.TotalAmount) / COUNT(*), 'C') as RevenuePerCustomer
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerSegment
ORDER BY SUM(s.TotalAmount) DESC;

-- 3. Product Category Performance
SELECT 
    Category,
    COUNT(*) as ProductCount,
    SUM(s.Quantity) as TotalQuantitySold,
    FORMAT(SUM(s.TotalAmount), 'C') as TotalRevenue,
    FORMAT(AVG(s.TotalAmount), 'C') as AverageOrderValue,
    RANK() OVER (ORDER BY SUM(s.TotalAmount) DESC) as RevenueRank
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY Category
ORDER BY TotalRevenue DESC;

-- 4. Top Performing Products
SELECT TOP 10
    p.ProductName,
    p.Category,
    FORMAT(p.UnitPrice, 'C') as UnitPrice,
    COUNT(s.OrderID) as OrderCount,
    SUM(s.Quantity) as TotalQuantitySold,
    FORMAT(SUM(s.TotalAmount), 'C') as TotalRevenue
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName, p.Category, p.UnitPrice
ORDER BY SUM(s.TotalAmount) DESC;

-- 5. Customer Purchase Behavior
WITH CustomerMetrics AS (
    SELECT 
        c.CustomerID,
        CONCAT(c.FirstName, ' ', c.LastName) as CustomerName,
        c.CustomerSegment,
        c.Country,
        COUNT(s.OrderID) as TotalOrders,
        SUM(s.TotalAmount) as TotalSpent,
        AVG(s.TotalAmount) as AverageOrderValue,
        MIN(s.OrderDate) as FirstPurchase,
        MAX(s.OrderDate) as LastPurchase,
        DATEDIFF(DAY, MIN(s.OrderDate), MAX(s.OrderDate)) as CustomerLifespanDays
    FROM Customers c
    LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName, c.CustomerSegment, c.Country
)
SELECT 
    CustomerName,
    CustomerSegment,
    Country,
    TotalOrders,
    FORMAT(TotalSpent, 'C') as TotalSpent,
    FORMAT(AverageOrderValue, 'C') as AverageOrderValue,
    FirstPurchase,
    LastPurchase,
    CustomerLifespanDays,
    CASE 
        WHEN TotalSpent > 1000 THEN 'High Value'
        WHEN TotalSpent > 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as ValueSegment
FROM CustomerMetrics
WHERE TotalOrders > 0
ORDER BY TotalSpent DESC;

-- 6. Salesperson Performance
SELECT 
    sp.SalespersonID,
    CONCAT(sp.FirstName, ' ', sp.LastName) as SalespersonName,
    sp.Territory,
    sp.Commission,
    COUNT(s.OrderID) as TotalOrders,
    FORMAT(SUM(s.TotalAmount), 'C') as TotalSales,
    FORMAT(AVG(s.TotalAmount), 'C') as AverageOrderValue,
    FORMAT(SUM(s.TotalAmount) * sp.Commission, 'C') as EstimatedCommission
FROM Salespeople sp
LEFT JOIN Sales s ON sp.SalespersonID = s.SalespersonID
GROUP BY sp.SalespersonID, sp.FirstName, sp.LastName, sp.Territory, sp.Commission
ORDER BY SUM(s.TotalAmount) DESC;

-- 7. Geographical Sales Analysis
SELECT 
    c.Country,
    COUNT(DISTINCT c.CustomerID) as CustomerCount,
    COUNT(s.OrderID) as TotalOrders,
    FORMAT(SUM(s.TotalAmount), 'C') as TotalRevenue,
    FORMAT(AVG(s.TotalAmount), 'C') as AverageOrderValue
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.Country
ORDER BY SUM(s.TotalAmount) DESC;

-- 8. Daily Sales Trend (for Power BI)
SELECT 
    OrderDate,
    COUNT(*) as DailyOrders,
    SUM(TotalAmount) as DailyRevenue,
    AVG(TotalAmount) as DailyAverageOrder,
    SUM(Quantity) as DailyQuantitySold
FROM Sales
GROUP BY OrderDate
ORDER BY OrderDate;

-- 9. Stock Analysis
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
    END as StockLevel
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.StockQuantity
ORDER BY RemainingStock;

-- 10. Revenue Growth Trend
WITH DailyRevenue AS (
    SELECT 
        OrderDate,
        SUM(TotalAmount) as DailyRevenue
    FROM Sales
    GROUP BY OrderDate
)
SELECT 
    OrderDate,
    FORMAT(DailyRevenue, 'C') as DailyRevenue,
    FORMAT(SUM(DailyRevenue) OVER (ORDER BY OrderDate), 'C') as CumulativeRevenue,
    FORMAT(
        LAG(DailyRevenue) OVER (ORDER BY OrderDate), 'C'
    ) as PreviousDayRevenue,
    CASE 
        WHEN LAG(DailyRevenue) OVER (ORDER BY OrderDate) > 0 
        THEN FORMAT(
            ((DailyRevenue - LAG(DailyRevenue) OVER (ORDER BY OrderDate)) / LAG(DailyRevenue) OVER (ORDER BY OrderDate)) * 100, 
            'N2'
        ) + '%'
        ELSE 'N/A'
    END as DayOverDayGrowth
FROM DailyRevenue
ORDER BY OrderDate;
