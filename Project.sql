CREATE DATABASE coffee_shop;
USE coffee_shop;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Position VARCHAR(50)
);

CREATE TABLE Item (
    Item_ID INT PRIMARY KEY,
    Item_Name VARCHAR(100),
    Price DECIMAL(5,2),
    Quantity INT
);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Order_Date DATE,
    Total_Amount DECIMAL(10,2),
    Payment_Method VARCHAR(50),
    Customer_ID INT,
    Employee_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);

CREATE TABLE Order_Details (
    Order_ID INT,
    Item_ID INT,
    Quantity INT,
    PRIMARY KEY (Order_ID, Item_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

SHOW TABLES;

DESCRIBE Customer;
DESCRIBE Employee;
DESCRIBE Item;
DESCRIBE Orders;
DESCRIBE Order_Details;

ALTER TABLE Customer 
MODIFY COLUMN Name VARCHAR(100) NOT NULL;

ALTER TABLE Customer 
MODIFY COLUMN Phone VARCHAR(15) NOT NULL;

ALTER TABLE Customer 
ADD UNIQUE (Phone);

ALTER TABLE Orders 
ADD CHECK (Total_Amount >= 0);

ALTER TABLE Item 
ADD CHECK (Price >= 0);

ALTER TABLE Orders 
ALTER Payment_Method SET DEFAULT 'Card';

INSERT INTO Customer VALUES
(1, 'Aliyah Al-Otaibi', '050000000'),
(2, 'Maryam Al-Oufi', '050000000'),
(3, 'Layan Alswaat', '050000000'),
(4, 'Aseel Ibrahim', '050000000'),
(5, 'Sara Al-Harbi', '050000000');

INSERT INTO Employee VALUES 
(1, 'Ali Hassan', 'Cashier'),
(2, 'Mona Saad', 'Barista'),
(3, 'Omar Fahad', 'Supervisor'),
(4, 'Laila Ahmed', 'Barista'),
(5, 'Yousef Khaled', 'Cashier');

INSERT INTO Item VALUES
(1, 'Latte', 15.00, 50),
(2, 'Espresso', 10.00, 40),
(3, 'Cappuccino', 14.00, 30),
(4, 'Cheesecake', 18.00, 20),
(5, 'Brownie', 12.00, 25);

INSERT INTO Orders VALUES
(1, '2026-04-01', 25.00, 'Cash', 1, 1),
(2, '2026-04-02', 30.00, 'Card', 2, 2),
(3, '2026-04-03', 18.00, 'Cash', 3, 3),
(4, '2026-04-04', 27.00, 'Card', 4, 4),
(5, '2026-04-05', 22.00, 'Cash', 5, 5);

INSERT INTO Order_Details VALUES
(1, 1, 1),
(1, 2, 1),
(2, 3, 2),
(3, 4, 1),
(4, 5, 2),
(5, 1, 1);

SELECT * FROM Customer;
SELECT * FROM Employee;
SELECT * FROM Item;
SELECT * FROM Orders;
SELECT * FROM Order_Details;

SELECT Name, Phone 
FROM Customer;

SELECT Item_Name, Price FROM Item 
WHERE Price > 10;

SELECT Order_ID, Payment_Method 
FROM Orders 
WHERE Payment_Method = 'Cash';

SELECT Employee_Name, Position 
FROM Employee 
WHERE Position = 'Barista';

SELECT COUNT(*) AS Total_Orders 
FROM Orders;

SELECT SUM(Total_Amount) AS Total_Sales 
FROM Orders;

SELECT AVG(Total_Amount) AS Average_Order_Value 
FROM Orders;

SELECT Employee_ID, COUNT(Order_ID) AS Total_Orders
FROM Orders
GROUP BY Employee_ID;

SELECT o.Order_ID, c.Name AS Customer_Name, e.Employee_Name, o.Total_Amount
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Employee e ON o.Employee_ID = e.Employee_ID;

SELECT Name
FROM Customer
WHERE Customer_ID IN (
SELECT Customer_ID
    FROM Orders
    WHERE Total_Amount > (
        SELECT AVG(Total_Amount)
        FROM Orders
    )
);

CREATE VIEW order_report AS
SELECT o.Order_ID, c.Name AS Customer_Name, e.Employee_Name, o.Order_Date,
    o.Payment_Method, o.Total_Amount, i.Item_Name, od.Quantity
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Employee e ON o.Employee_ID = e.Employee_ID
JOIN Order_Details od ON o.Order_ID = od.Order_ID
JOIN Item i ON od.Item_ID = i.Item_ID;

SELECT * FROM order_report;