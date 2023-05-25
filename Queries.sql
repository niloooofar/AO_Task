--------------------------------------------------------------------------------------------------
------------------------------------------  Part A -----------------------------------------------
--------------------------------------------------------------------------------------------------

CREATE TABLE sale (
	SalesID INTEGER PRIMARY KEY,
	OrderID INTEGER,
	Customer VARCHAR(10),
	Product VARCHAR(10),
	'Date' INTEGER,
	Quantity FLOAT,
	UnitPrice FLOAT
);

CREATE TABLE sale_profit (
	Product VARCHAR(10),
	ProfitRatio FLOAT
);

------------------------------------------  Question 1 ------------------------------------------
SELECT sum(Quantity * UnitPrice) AS 'Total Sales' 
FROM sale;
  
------------------------------------------  Question 2 ------------------------------------------
SELECT count(DISTINCT Customer) AS 'Number Of Customers' 
FROM sale;

------------------------------------------  Question 3 ------------------------------------------
SELECT Product,
	sum(Quantity) AS 'Total Number Sold' ,
	sum(Quantity * UnitPrice) AS 'Total Amount Sold'
FROM sale
GROUP BY Product;

------------------------------------------  Question 4 ------------------------------------------
WITH q1 AS (
	SELECT Customer,
		OrderID,
		sum(Quantity * UnitPrice) AS 'price'
	FROM sale
	GROUP BY Customer, OrderID
	HAVING price > 1500
), 
q2 AS ( 
	SELECT DISTINCT Customer
	FROM q1
)
SELECT sale.Customer AS 'Customer Name',
	sum(sale.Quantity * sale.UnitPrice) 'Purchased Amount',
	count(DISTINCT sale.OrderID) AS 'Invoice Counts',
	sum(Quantity) AS 'Number of Item Purchased',
	count(DISTINCT sale.Product) AS 'Number of Unique Items Purchased'
FROM sale
JOIN q2
ON sale.Customer = q2.Customer
GROUP BY sale.Customer;

------------------------------------------  Question 5 -------------------------------------------
WITH q1 AS (
	SELECT sale.Product,
		sale.UnitPrice,
		sale.Quantity,
		IFNULL(sale_profit.ProfitRatio, 0.1) AS ProfitRatio
	FROM sale
	LEFT JOIN sale_profit 
	ON sale.Product = sale_profit.Product
),
q2 AS ( 
	SELECT
		sum(Quantity * UnitPrice) AS 'Total_Amount',
		sum(Quantity * UnitPrice * ProfitRatio) AS 'Total_Profit_Amount'
	FROM q1
)
SELECT
	Total_Profit_Amount,
	100 * Total_Profit_Amount / Total_Amount AS 'Profit_Percentage'
	FROM q2;

------------------------------------------  Question 6 -------------------------------------------
SELECT sum(Daily_Customers_Count) 
FROM (
	SELECT  date, count(DISTINCT customer) AS 'Daily_Customers_Count'
	FROM sale
	GROUP BY date);

	
--------------------------------------------------------------------------------------------------
------------------------------------------  Part B -----------------------------------------------
--------------------------------------------------------------------------------------------------

CREATE TABLE employee (
	Id INTEGER PRIMARY KEY,
	Name VARCHAR(50),
	Manger VARCHAR(50),
	ManagerId INTEGER 
);

--------------------------------------------------------------------------------------------------
WITH EmpMgrCTE AS (
	SELECT Id,
		Name,
		ManagerId,
		1 AS EmployeeLevel,
		Name AS TopManager
	FROM employee
	where ManagerId is NULL
	
	union ALL
	
	SELECT emp.Id,
		emp.Name,
		emp.ManagerId,
		mgr.EmployeeLevel + 1 AS EmployeeLevel,
		TopManager
	FROM employee emp 
	JOIN EmpMgrCTE AS mgr
	ON emp.ManagerId = mgr.Id
)
SELECT * 
FROM EmpMgrCTE
ORDER BY EmployeeLevel;