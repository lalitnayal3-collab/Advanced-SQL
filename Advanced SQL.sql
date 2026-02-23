-- Question1 What is a Common Table Expression (CTE)?

A CTE (Common Table Expression) is a temporary named result set created using the WITH keyword. It exists only during the execution of a query.

How it improves readability:

Breaks complex queries into logical steps

Makes queries easier to read and maintain

Avoids repeating subqueries

Example:
WITH ProductSales AS (
    SELECT ProductID, SUM(Quantity) AS TotalQty
    FROM Sales
    GROUP BY ProductID
)
SELECT * FROM ProductSales;

-- Question2. Why are some views updatable while others are read-only?

A view is updatable if it is based on a single table and does not use:

JOIN

GROUP BY

DISTINCT

Aggregate functions

A view becomes read-only when it includes these elements.

Example:
-- Updatable View
CREATE VIEW vw_ProductPrice AS
SELECT ProductID, ProductName, Price
FROM Products;
-- Read-only View
CREATE VIEW vw_CategorySummary AS
SELECT Category, COUNT(*) AS TotalProducts
FROM Products
GROUP BY Category;

-- Question3. Advantages of Stored Procedures

Stored procedures:

Improve performance (precompiled)

Reduce network traffic

Increase security

Allow reuse of logic

Simplify maintenance


-- Question4. Purpose of Triggers.

A trigger automatically executes when an event (INSERT, UPDATE, DELETE) occurs on a table.

Essential use case:
Archiving deleted records for audit/history tracking.

-- Question5. Need for Data Modelling and Normalization.

Data modelling and normalization:

Reduce data redundancy

Improve data consistency

Avoid update anomalies

Improve database performance

Make the database scalable and maintainable


-- Question6. CTE to calculate total revenue per product (Revenue > 3000).
WITH RevenueCTE AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(p.Price * s.Quantity) AS Revenue
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT * 
FROM RevenueCTE
WHERE Revenue > 3000;

-- Question7. Create view vw_CategorySummary

CREATE VIEW vw_CategorySummary AS
SELECT 
    Category,
    COUNT(*) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

-- Question8 Create updatable view and update price
 View creation:
CREATE VIEW vw_ProductUpdate AS
SELECT ProductID, ProductName, Price
FROM Products;

 Update using view:
UPDATE vw_ProductUpdate
SET Price = 1500
WHERE ProductID = 1;

-- Question9 Stored procedure to return products by category
DELIMITER $$

CREATE PROCEDURE GetProductsByCategory(IN cat_name VARCHAR(50))
BEGIN
    SELECT *
    FROM Products
    WHERE Category = cat_name;
END $$

DELIMITER ;
Call procedure:
CALL GetProductsByCategory('Electronics');

-- Question10 AFTER DELETE trigger to archive products
Archive table:
CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP
);
Trigger:
DELIMITER $$

CREATE TRIGGER trg_after_product_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive
    VALUES (
        OLD.ProductID,
        OLD.ProductName,
        OLD.Category,
        OLD.Price,
        NOW()
    );
END $$

DELIMITER ;