
-- PART I - DATABASE SETUP
DROP DATABASE IF EXISTS SalesDB;
CREATE DATABASE SalesDB;
USE SalesDB;

-- A. CREATE TABLE --
CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Country    VARCHAR(50),
    Score      INTEGER
);

CREATE TABLE Products (
    ProductID INTEGER PRIMARY KEY,
    Product   VARCHAR(100),
    Category  VARCHAR(50),
    Price     DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmployeeID INTEGER PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Department VARCHAR(50),
    BirthDate  DATE,
    Gender     VARCHAR(10),
    Salary     DECIMAL(10,2),
    ManagerID  INTEGER NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Orders (
    OrderID       INTEGER PRIMARY KEY,
    ProductID     INTEGER,
    CustomerID    INTEGER,
    SalesPersonID INTEGER,
    OrderDate     DATE,
    ShipDate      DATE NULL,
    OrderStatus   VARCHAR(30),
    ShipAddress   VARCHAR(150),
    BillAddress   VARCHAR(150),
    Quantity      INTEGER,
    Sales         DECIMAL(10,2),
    CreationTime  DATETIME,
    FOREIGN KEY (ProductID)     REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID)    REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalesPersonID) REFERENCES Employees(EmployeeID)
);

-- C. INSERT sample data --
INSERT INTO Customers (CustomerID, FirstName, LastName, Country, Score) VALUES
(1, 'Arzu',  'Bakirova', 'Azerbaijan', 720),
(2, 'Tom',  'Cruise',   'USA',        450),
(3, 'Diane',  'Kruger',  'Germany',    860),
(4, 'Marion',  'Cotillard',   'France',     280),
(5, 'Thomas', 'Muller',    'Germany',    550),
(6, 'Aliye',  'Aliyeva',  'Azerbaijan', 610);   -- heç vaxt sifariş verməyib --

INSERT INTO Products (ProductID, Product, Category, Price) VALUES
(101, 'Mouse', 'Electronics', 55),
(102, 'Table',   'Furniture',   230),
(103, 'Laptop',         'Electronics', 850),
(104, 'Notebook',       'Stationery',  12),
(105, 'Smart Phone',    'Electronics', 420);

-- Menecer əvvəl daxil edilir (öz-özünə istinad FK) --
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
(11, 'Bruce', 'Lee',   'Sales',   '1988-03-14', 'Male',   2200, NULL),
(12, 'Emma',  'Stone', 'Sales',   '1991-07-22', 'Female', 2400, 11),
(13, 'Jackie',  'Chan', 'Support', '1985-11-05', 'Male',   1900, 11);

INSERT INTO Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus,
                    ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(201, 101, 1, 11, '2026-10-04', '2026-10-06', 'Delivered', '12 Nizami St, Baku',       '12 Nizami St, Baku',       2, 110.00,  '2026-10-04 09:15:00'),
(202, 103, 3, 12, '2026-10-08', '2026-10-10', 'Shipped',   '5 Berliner Str, Berlin',   '5 Berliner Str, Berlin',   1, 850.00,  '2026-10-08 11:30:00'),
(203, 102, 2, 11, '2026-10-12', NULL,         'Pending',   '77 Broadway, New York',    '77 Broadway, New York',    1, 230.00,  '2026-10-12 14:05:00'),
(204, 105, 5, 12, '2026-10-15', '2026-10-20', 'Delivered', '9 Hauptstr, Munich',       '9 Hauptstr, Munich',       1, 420.00,  '2026-10-15 16:40:00'),
(205, 103, 3, 11, '2026-10-02', '2026-10-12', 'Delivered', '5 Berliner Str, Berlin',   '5 Berliner Str, Berlin',   2, 1700.00, '2026-10-02 10:00:00'),
(206, 103, 5, 12, '2026-10-28', '2026-11-09', 'Delivered', '9 Hauptstr, Munich',       '9 Hauptstr, Munich',       2, 1700.00, '2026-10-28 13:20:00'),
(105, 103, 3, 12, '2026-10-20', NULL,         'Pending',   '5 Berliner Str, Berlin',   '5 Berliner Str, Berlin',   3, 2550.00, '2026-10-20 08:45:00'),
(110, 105, 1, 11, '2026-10-25', NULL,         'Pending',   '1 Old Address, Baku',      '12 Nizami St, Baku',       4, 1680.00, '2026-10-25 12:10:00'),
(999, 104, 2, 13, '2026-10-30', NULL,         'Test',      'TEST',                     'TEST',                     1, 12.00,   '2026-10-30 17:00:00');  -- müvəqqəti test qeydi --

-- D. Verify --
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Orders;

-- PART I - 10 BASIC SQL TASKS

-- Task 1: Explore a table --
SELECT * FROM Customers;
SELECT FirstName, LastName, Country FROM Customers;

-- Task 2: Filter by country --
SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country = 'Germany';

-- Task 3: Combine conditions --
SELECT CustomerID, FirstName, LastName, Country, Score
FROM Customers
WHERE Score >= 300 AND Country IN ('Germany', 'France');

-- Task 4: Sort products (most expensive first) --
SELECT ProductID, Product, Category, Price
FROM Products
ORDER BY Price DESC;

-- Task 5: Price range 50..300 inclusive --
SELECT Product, Price
FROM Products
WHERE Price BETWEEN 50 AND 300;

-- Task 6: Text pattern - name contains 'Phone' --
SELECT Product, Category
FROM Products
WHERE Product LIKE '%Phone%';

-- Task 7: Distinct categories, alphabetical --
SELECT DISTINCT Category
FROM Products
ORDER BY Category;

-- Task 8: Each OrderID with the customer's first and last name --
SELECT o.OrderID, c.FirstName, c.LastName
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

-- Task 9: Number of orders and total Sales per OrderStatus --
SELECT OrderStatus, COUNT(*) AS OrderCount, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalSales DESC;

-- Task 10: Safe data change (INSERT -> UPDATE -> verify -> DELETE) --
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (900, 'Test Headset', 'Electronics', 40);

UPDATE Products SET Price = 45 WHERE ProductID = 900;

SELECT * FROM Products WHERE ProductID = 900;   -- yoxlama --

DELETE FROM Products WHERE ProductID = 900;

-- İzah: UPDATE və DELETE-də WHERE olmasa, əmr cədvəldəki BÜTÜN sətirlərə
-- tətbiq olunar (bütün qiymətlər dəyişər və ya bütün məlumat silinər).
-- WHERE yalnız hədəf sətri seçərək təsadüfi məlumat itkisinin qarşısını alır.

-- PART II - ASSIGNMENT 1: CUSTOMER LOYALTY AND SALES ANALYSIS --

-- Assignment 1, Task 1: High-score customers (Score > 500) --
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Score > 500
ORDER BY Score DESC;

-- Assignment 1, Task 2: Target countries (Germany/France/USA, Score >= 300) --
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Country IN ('Germany', 'France', 'USA') AND Score >= 300;

-- Assignment 1, Task 3: Purchase history (full name, OrderID, OrderDate, Sales) --
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderID, o.OrderDate, o.Sales
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Assignment 1, Task 4: Inactive customers (LEFT JOIN + IS NULL) --
SELECT c.CustomerID, c.FirstName, c.LastName, c.Country
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Assignment 1, Task 5: Total Sales per customer (with at least one order) --
SELECT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS Customer,
       SUM(o.Sales) AS TotalSales
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSales DESC;

-- Assignment 1, Task 6: Loyalty threshold (total Sales > 1000) -> HAVING --
SELECT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS Customer,
       SUM(o.Sales) AS TotalSales
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > 1000
ORDER BY TotalSales DESC;

-- Assignment 1, Task 7: Top-five customers by total Sales --
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS Customer, c.Country,
       SUM(o.Sales) AS TotalSales
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSales DESC
LIMIT 5;   -- SQL Server: SELECT TOP 5 --

-- PART II - ASSIGNMENT 2: ORDER AND DELIVERY INVESTIGATION --

-- Assignment 2, Task 1: October 2026 orders (inclusive) --
SELECT OrderID, CustomerID, OrderDate, ShipDate, OrderStatus
FROM Orders
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31';

-- Assignment 2, Task 2: Pending queue, oldest first --
SELECT *
FROM Orders
WHERE OrderStatus = 'Pending'
ORDER BY OrderDate ASC;

-- Assignment 2, Task 3: Late shipments (ShipDate > 7 days after OrderDate) --
SELECT o.OrderID, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderDate, o.ShipDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE DATEDIFF(o.ShipDate, o.OrderDate) > 7;

-- Assignment 2, Task 4: Customers affected by delayed orders --
SELECT DISTINCT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, c.Country
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE DATEDIFF(o.ShipDate, o.OrderDate) > 7;

-- Assignment 2, Task 5: Status correction for OrderID 105 --
SELECT * FROM Orders WHERE OrderID = 105;   -- əvvəlcə önizləmə --
UPDATE Orders
SET OrderStatus = 'Shipped', ShipDate = '2026-11-05'
WHERE OrderID = 105;
SELECT * FROM Orders WHERE OrderID = 105;   -- yoxlama --

-- Assignment 2, Task 6: Address correction for OrderID 110 --
SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;
UPDATE Orders
SET ShipAddress = '45 Main Street, Baku'
WHERE OrderID = 110;
SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;

-- Assignment 2, Task 7: Remove temporary test record OrderID 999 --
SELECT * FROM Orders WHERE OrderID = 999;
DELETE FROM Orders WHERE OrderID = 999;
SELECT * FROM Orders WHERE OrderID = 999;   -- 0 sətir qaytarmalıdır --

-- Assignment 2, Task 8: Status distribution --
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus;

-- Assignment 2, Task 9: Unshipped orders (ShipDate IS NULL) --
SELECT o.OrderID, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderDate, o.OrderStatus
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.ShipDate IS NULL;

-- PART II - ASSIGNMENT 3: PRODUCTS AND EMPLOYEE PERFORMANCE --

-- Assignment 3, Task 1: Affordable products (50..300), price ascending --
SELECT Product, Category, Price
FROM Products
WHERE Price BETWEEN 50 AND 300
ORDER BY Price ASC;

-- Assignment 3, Task 2: Premium electronics (Price > 500) --
SELECT *
FROM Products
WHERE Category = 'Electronics' AND Price > 500;

-- Assignment 3, Task 3: Product sales (name, category, Quantity, Sales) --
SELECT p.Product, p.Category, o.Quantity, o.Sales
FROM Products p
INNER JOIN Orders o ON p.ProductID = o.ProductID;

-- Assignment 3, Task 4: Top-5 best-selling products by total Quantity --
SELECT p.ProductID, p.Product, SUM(o.Quantity) AS TotalQuantity
FROM Products p
INNER JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Product
ORDER BY TotalQuantity DESC
LIMIT 5;

-- Assignment 3, Task 5: Unsold items (no matching order) --
SELECT p.ProductID, p.Product, p.Category
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;

-- Assignment 3, Task 6: Employee performance (EmployeeID = SalesPersonID) --
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS Employee, e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department;

-- Assignment 3, Task 7: Top-performing staff (total Sales > 5000) --
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS Employee, e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department
HAVING SUM(o.Sales) > 5000
ORDER BY TotalSales DESC;

-- Assignment 3, Task 8: New product --
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (501, 'Wireless Keyboard', 'Electronics', 75);

-- Assignment 3, Task 9: Price correction 75 -> 90 --
UPDATE Products SET Price = 90 WHERE ProductID = 501;
SELECT * FROM Products WHERE ProductID = 501;

-- Assignment 3, Task 10: Inventory column --
ALTER TABLE Products ADD StockQuantity INT;

-- Assignment 3, Task 11: Combined directory (UNION removes duplicates) --
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees;

-- Assignment 3, Task 12: Category performance (total Sales > 2000) --
SELECT p.Category, SUM(o.Quantity) AS TotalQuantity, SUM(o.Sales) AS TotalSales
FROM Products p
INNER JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Category
HAVING SUM(o.Sales) > 2000
ORDER BY TotalSales DESC;
