-- T-SQL Data Loading Script
-- This script loads sample data into the tables

-- Insert Salespeople first
INSERT INTO Salespeople (FirstName, LastName, Email, HireDate, Territory, Commission)
VALUES 
    ('Alex', 'Johnson', 'alex.johnson@company.com', '2022-01-15', 'North America', 0.05),
    ('Maria', 'Rodriguez', 'maria.rodriguez@company.com', '2022-03-20', 'Europe', 0.06),
    ('James', 'Chen', 'james.chen@company.com', '2022-02-10', 'Asia Pacific', 0.05),
    ('Sarah', 'Thompson', 'sarah.thompson@company.com', '2022-04-05', 'North America', 0.07),
    ('Ahmed', 'Hassan', 'ahmed.hassan@company.com', '2022-05-12', 'Middle East', 0.06);

-- Insert Customers data
INSERT INTO Customers (FirstName, LastName, Email, City, Country, RegistrationDate, CustomerSegment)
VALUES 
    ('John', 'Smith', 'john.smith@email.com', 'New York', 'USA', '2023-01-15', 'Premium'),
    ('Sarah', 'Johnson', 'sarah.j@email.com', 'London', 'UK', '2023-02-20', 'Standard'),
    ('Mike', 'Brown', 'mike.brown@email.com', 'Toronto', 'Canada', '2023-01-28', 'Premium'),
    ('Emma', 'Davis', 'emma.davis@email.com', 'Sydney', 'Australia', '2023-03-10', 'Standard'),
    ('Chris', 'Wilson', 'chris.w@email.com', 'Berlin', 'Germany', '2023-02-14', 'Basic'),
    ('Lisa', 'Anderson', 'lisa.anderson@email.com', 'Paris', 'France', '2023-03-05', 'Premium'),
    ('David', 'Taylor', 'david.taylor@email.com', 'Tokyo', 'Japan', '2023-01-30', 'Standard'),
    ('Anna', 'Martinez', 'anna.m@email.com', 'Madrid', 'Spain', '2023-02-25', 'Basic'),
    ('Robert', 'Garcia', 'robert.g@email.com', 'Mexico City', 'Mexico', '2023-03-12', 'Standard'),
    ('Jennifer', 'Lee', 'jennifer.lee@email.com', 'Seoul', 'South Korea', '2023-01-18', 'Premium');

-- Insert Products data
INSERT INTO Products (ProductName, Category, UnitPrice, StockQuantity, SupplierID, Description)
VALUES 
    ('Laptop Pro', 'Electronics', 1299.99, 50, 1, 'High-performance laptop for professionals'),
    ('Wireless Mouse', 'Electronics', 29.99, 200, 2, 'Ergonomic wireless mouse with precision tracking'),
    ('Office Chair', 'Furniture', 249.99, 75, 3, 'Comfortable ergonomic office chair'),
    ('Keyboard', 'Electronics', 79.99, 150, 2, 'Mechanical keyboard with backlight'),
    ('Desk Lamp', 'Furniture', 45.00, 100, 4, 'Adjustable LED desk lamp'),
    ('Monitor', 'Electronics', 329.99, 60, 1, '27-inch 4K monitor'),
    ('Webcam', 'Electronics', 89.99, 120, 5, 'HD webcam for video conferencing'),
    ('Headphones', 'Electronics', 149.99, 80, 6, 'Noise-cancelling wireless headphones'),
    ('Standing Desk', 'Furniture', 599.99, 25, 3, 'Height-adjustable standing desk'),
    ('Tablet', 'Electronics', 399.99, 40, 7, '10-inch tablet with stylus'),
    ('Printer', 'Electronics', 199.99, 35, 8, 'Wireless all-in-one printer'),
    ('Cable Set', 'Electronics', 15.99, 300, 9, 'USB-C cable set with adapters'),
    ('Book Stand', 'Furniture', 35.00, 150, 4, 'Adjustable wooden book stand');

-- Insert Sales data
INSERT INTO Sales (CustomerID, ProductID, ProductName, Category, Quantity, UnitPrice, OrderDate, SalespersonID)
VALUES 
    (1, 101, 'Laptop Pro', 'Electronics', 1, 1299.99, '2024-01-15', 201),
    (2, 102, 'Wireless Mouse', 'Electronics', 2, 29.99, '2024-01-16', 202),
    (3, 103, 'Office Chair', 'Furniture', 1, 249.99, '2024-01-18', 203),
    (1, 104, 'Keyboard', 'Electronics', 1, 79.99, '2024-01-20', 201),
    (4, 105, 'Desk Lamp', 'Furniture', 2, 45.00, '2024-01-22', 204),
    (5, 101, 'Laptop Pro', 'Electronics', 1, 1299.99, '2024-01-25', 202),
    (6, 106, 'Monitor', 'Electronics', 1, 329.99, '2024-01-28', 205),
    (2, 107, 'Webcam', 'Electronics', 1, 89.99, '2024-02-01', 201),
    (7, 108, 'Headphones', 'Electronics', 1, 149.99, '2024-02-03', 203),
    (3, 109, 'Standing Desk', 'Furniture', 1, 599.99, '2024-02-05', 204),
    (8, 110, 'Tablet', 'Electronics', 1, 399.99, '2024-02-08', 202),
    (9, 103, 'Office Chair', 'Furniture', 2, 249.99, '2024-02-10', 205),
    (10, 111, 'Printer', 'Electronics', 1, 199.99, '2024-02-12', 201),
    (1, 112, 'Cable Set', 'Electronics', 3, 15.99, '2024-02-15', 203),
    (4, 113, 'Book Stand', 'Furniture', 1, 35.00, '2024-02-18', 204);

-- Verify data insertion
SELECT 'Customers' as TableName, COUNT(*) as RecordCount FROM Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Sales', COUNT(*) FROM Sales
UNION ALL
SELECT 'Salespeople', COUNT(*) FROM Salespeople;

PRINT 'Sample data loaded successfully!';
