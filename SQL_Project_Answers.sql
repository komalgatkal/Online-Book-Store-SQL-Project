
-- Create Database
CREATE DATABASE IF NOT EXISTS OnlineBookstore;

-- Switch to the database
USE OnlineBookstore;

-- Drop tables in child-to-parent order
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

-- Create Books table
CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10, 2),
    Stock INT
);

-- Create Customers table
CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

-- Create Orders table with foreign keys
CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2),

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID),

    CONSTRAINT fk_orders_books
        FOREIGN KEY (Book_ID)
        REFERENCES Books(Book_ID)
);

-- Check tables
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;



-------------------------------------------------------------------------- BASIC QUERIES---------------------------------------------------------------------------------------

-- 1) Retrieve all books in the "Fiction" genre

     SELECT * FROM  Books 
     WHERE Genre = "Fiction";

-- 2) Find books published after the year 1950
      
      SELECT * FROM Books
      WHERE Published_Year > 1950;
      
-- 3) List all customers from the Canada
      
      SELECT * FROM Customers
      WHERE Country = 'Canada';
      
-- 4) Show orders placed in November 2023
       
       SELECT * FROM Orders 
       WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';
       
-- 5) Retrieve the total stock of books available
     
      SELECT SUM(Stock) AS Total_Books 
      FROM Books;
      
-- 6) Find the details of the most expensive book
      
      SELECT * FROM Books
      ORDER BY Price DESC
      LIMIT 1;
      
-- 7) Show all customers who ordered more than 1 quantity of a book
      
	  SELECT DISTINCT c.Customer_ID,
             c.Name,
             o.Book_ID,
             o.Quantity
	  FROM Customers c
      JOIN Orders o
      ON c.Customer_ID = o.Customer_ID
      WHERE o.quantity>1;
      
-- 8) Retrieve all orders where the total amount exceeds $20
      
	  SELECT * FROM Orders 
	  WHERE Total_Amount > 20;
	  
-- 9) List all genres available in the Books table
	  
      SELECT DISTINCT Genre 
      FROM Books;
      
-- 10) Find the book with the lowest stock

       SELECT *
       FROM Books
       WHERE Stock = (SELECT MIN(Stock) FROM Books);
       
-- 11) Calculate the total revenue generated from all orders
	   
       SELECT SUM(Total_Amount) as Total_Revenue
       FROM Orders;
       
     
     
     
      
----------------------------------------------------------------------------- Advance Queries---------------------------------------------------------------------------------- 


-- 1) Retrieve the total number of books sold for each genre

      SELECT COUNT(Book_ID) FROM Books
      GROUP BY Genre;
      
-- 2) Find the average price of books in the "Fantasy" genre
      
      SELECT AVG(Price) as Average_Price FROM Books
      WHERE Genre = 'Fantasy';
      
-- 3) List customers who have placed at least 2 orders

      SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
	  FROM Customers c
      JOIN Orders o
      ON c.Customer_ID = o.Customer_ID
      GROUP BY o.customer_id, c.name
      HAVING COUNT(Order_id) >=2;
      
-- 4) Find the most frequently ordered book
      
      SELECT b.Book_ID, b.Title, COUNT(o.order_id) AS ORDER_COUNT
      FROM Books b
      JOIN Orders o
      ON b.Book_ID = o.Book_ID
      GROUP BY o.Book_ID, b.Title
      ORDER BY ORDER_COUNT DESC LIMIT 1;
      
-- 5) Show the top 3 most expensive books of 'Fantasy' Genre 
      
      SELECT * FROM Books
      WHERE Genre = 'Fantasy'
      ORDER BY Price DESC
      LIMIT 3;
      
-- 6) Retrieve the total quantity of books sold by each author
      
      SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
      FROM Books b
      JOIN Orders o
      ON b.Book_ID = o.Book_ID
      GROUP BY b.Author;
      
-- 7) List the cities where customers who spent over $30 are located
      
	  SELECT c.City, SUM(o.Total_Amount) AS Total_Expense
	  FROM Customers c
      JOIN Orders o
      ON c.Customer_ID = o.Customer_ID
      GROUP BY c.City
      HAVING SUM(o.Total_Amount) > 30 ; 
      
-- 8) Find the customer who spent the most on orders

      SELECT c.Name, c.Customer_ID, SUM(o.Total_Amount) AS Total_Expense
	  FROM Customers c
      JOIN Orders o
      ON c.Customer_ID = o.Customer_ID
      GROUP BY c.Customer_ID, c.Name
      ORDER BY Total_Expense DESC
      LIMIT 1; 
      
-- 9) Calculate the stock remaining after fulfilling all orders
      
      SELECT b.Book_ID,
             b.Title,
             b.Stock AS Original_Stock,
             COALESCE(SUM(o.Quantity), 0) AS Total_Ordered,
             b.Stock - COALESCE(SUM(o.Quantity), 0) AS Stock_Remaining
      FROM Books b
      LEFT JOIN Orders o
      ON b.Book_ID = o.Book_ID
      GROUP BY b.Book_ID, b.Title, b.Stock;
	  
      

