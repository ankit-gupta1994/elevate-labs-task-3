CREATE DATABASE elevate_labs_task_3;

USE elevate_labs_task_3;

-- Creating required table:
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
Book_id INT PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(60),
Genre VARCHAR(40),
Published_Year INT,
Price Numeric(10,2),
Stock INT);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(100)
    );
    
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date Date,
    Quantity INT,
	Total_Amount NUMERIC(10,2)
    );

-- Inserting the data using Table Data Import Wizard.

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- SQL queries to extract and analyse data from three tables named: books, customers, and orders.

-- 1) Retrieve all books in the "Fiction" genre
SELECT * FROM books 
WHERE Genre = "Fiction";

-- 2) Find books published after the year 1950
SELECT * FROM books 
WHERE published_year > 1950 
ORDER BY published_year;

-- 3) List all customers from the Canada
SELECT * FROM customers
WHERE country = "Canada";

-- 4) Show orders placed in November 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30'
ORDER BY order_date;

-- 5) Retrieve the total stock of books available
SELECT SUM(stock) AS Total_Stock FROM books;

-- 6) Find the details of the most expensive book
SELECT * FROM books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT c.*, o.quantity FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.quantity>1;

-- 8) List all genres available in the Books table
SELECT DISTINCT(genre) FROM books;

-- 9) Find the book with the lowest stock
SELECT * FROM books
WHERE stock = 0;

-- 10) Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS Total_Revenue 
FROM orders;

-- 11) Retrieve the total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS Total_books_sold 
FROM books b
JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.genre;

-- 12) Find the average price of books in the "Fantasy" genre
SELECT genre, ROUND(AVG(price),2) AS Average_price
FROM books
GROUP BY genre
HAVING genre = "Fantasy";

-- 13) List customers who have placed at least 2 orders
SELECT o.customer_id, c.name, COUNT(c.customer_id) AS Total_order_placed FROM orders o 
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id
HAVING COUNT(o.customer_id) >=2
ORDER BY Total_order_placed;

-- 14) Find the most frequently ordered book
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 15) Show the top 3 most expensive books of 'Fantasy' Genre
SELECT * FROM books
WHERE genre = "Fantasy"
ORDER BY price DESC
LIMIT 3;

-- 16) Retrieve the total quantity of books sold by each author
SELECT b.author, SUM(o.quantity) AS Total_books_sold
FROM orders o
JOIN books b
ON o.book_id = b.book_id
GROUP BY b.author
ORDER BY Total_books_sold DESC;

-- 17) List the cities where customers who spent over $30 are located
SELECT c.city, SUM(o.total_amount) AS Total_spent
FROM orders o 
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING Total_spent > 30
ORDER BY Total_spent;

-- 18) Find the customer who spent the most on orders
SELECT o.customer_id, c.name, SUM(o.total_amount) AS Money_spent
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id
ORDER BY money_spent DESC
LIMIT 1;

-- 19) Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;


