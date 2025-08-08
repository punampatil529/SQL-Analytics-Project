-- T-SQL Database Setup Script for Azure SQL Database
-- This script creates the database schema and tables for the analytics project

-- Create database (if running locally, uncomment the next line)
-- CREATE DATABASE SalesAnalyticsDB;
-- USE SalesAnalyticsDB;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    City NVARCHAR(50),
    Country NVARCHAR(50),
    RegistrationDate DATE NOT NULL,
    CustomerSegment NVARCHAR(20) CHECK (CustomerSegment IN ('Basic', 'Standard', 'Premium')),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(101,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    SupplierID INT,
    Description NVARCHAR(500),
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    ModifiedDate DATETIME2 DEFAULT GETDATE()
);

-- Create Sales table
CREATE TABLE Sales (
    OrderID INT IDENTITY(1001,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),
    TotalAmount AS (Quantity * UnitPrice) PERSISTED,
    OrderDate DATE NOT NULL,
    SalespersonID INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign key constraints
    CONSTRAINT FK_Sales_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Sales_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Salespeople table
CREATE TABLE Salespeople (
    SalespersonID INT IDENTITY(201,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    HireDate DATE NOT NULL,
    Territory NVARCHAR(50),
    Commission DECIMAL(3,2) CHECK (Commission BETWEEN 0 AND 1),
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

-- Create indexes for better performance
CREATE INDEX IX_Sales_CustomerID ON Sales(CustomerID);
CREATE INDEX IX_Sales_ProductID ON Sales(ProductID);
CREATE INDEX IX_Sales_OrderDate ON Sales(OrderDate);
CREATE INDEX IX_Customers_Segment ON Customers(CustomerSegment);
CREATE INDEX IX_Products_Category ON Products(Category);

-- Create a view for sales summary
CREATE VIEW vw_SalesSummary AS
SELECT 
    s.OrderID,
    s.OrderDate,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    c.CustomerSegment,
    c.Country,
    s.ProductName,
    s.Category,
    s.Quantity,
    s.UnitPrice,
    s.TotalAmount,
    CONCAT(sp.FirstName, ' ', sp.LastName) AS SalespersonName,
    sp.Territory
FROM Sales s
INNER JOIN Customers c ON s.CustomerID = c.CustomerID
LEFT JOIN Salespeople sp ON s.SalespersonID = sp.SalespersonID;

PRINT 'Database schema created successfully!';
