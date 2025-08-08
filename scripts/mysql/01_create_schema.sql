-- MySQL Database Setup Script
-- This script creates the database schema and tables for the analytics project

-- Create database
CREATE DATABASE IF NOT EXISTS SalesAnalyticsDB;
USE SalesAnalyticsDB;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    City VARCHAR(50),
    Country VARCHAR(50),
    RegistrationDate DATE NOT NULL,
    CustomerSegment ENUM('Basic', 'Standard', 'Premium') NOT NULL,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    SupplierID INT,
    Description TEXT,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ModifiedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Salespeople table
CREATE TABLE Salespeople (
    SalespersonID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    HireDate DATE NOT NULL,
    Territory VARCHAR(50),
    Commission DECIMAL(3,2) CHECK (Commission BETWEEN 0 AND 1),
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Sales table
CREATE TABLE Sales (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),
    TotalAmount DECIMAL(12,2) AS (Quantity * UnitPrice) STORED,
    OrderDate DATE NOT NULL,
    SalespersonID INT,
    CreatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT FK_Sales_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Sales_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_Sales_Salesperson FOREIGN KEY (SalespersonID) REFERENCES Salespeople(SalespersonID)
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

-- Set AUTO_INCREMENT starting values to match T-SQL identity seeds
ALTER TABLE Customers AUTO_INCREMENT = 1;
ALTER TABLE Products AUTO_INCREMENT = 101;
ALTER TABLE Sales AUTO_INCREMENT = 1001;
ALTER TABLE Salespeople AUTO_INCREMENT = 201;

SELECT 'MySQL database schema created successfully!' as Status;
