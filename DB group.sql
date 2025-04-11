-- Create the bookstore database
CREATE DATABASE bookstore;
USE bookstore;
-- Book languages
CREATE TABLE book_language (
    id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);

-- Authors
CREATE TABLE author (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Publishers
CREATE TABLE publisher (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Books
CREATE TABLE book (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    language_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (publisher_id) REFERENCES publisher(id),
    FOREIGN KEY (language_id) REFERENCES book_language(id)
);

-- Book-Author
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(id),
    FOREIGN KEY (author_id) REFERENCES author(id)
);




-- Countries
CREATE TABLE country (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Addresses
CREATE TABLE address (
    id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES country(id)
);

-- Address Status
CREATE TABLE address_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Customers
CREATE TABLE customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

-- Customer Addresses
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    status_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (address_id) REFERENCES address(id),
    FOREIGN KEY (status_id) REFERENCES address_status(id)
);



-- Shipping Methods
CREATE TABLE shipping_method (
    id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100)
);

-- Customer Orders
CREATE TABLE cust_order (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    shipping_method_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id)
);

-- Order Lines
CREATE TABLE order_line (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES cust_order(id),
    FOREIGN KEY (book_id) REFERENCES book(id)
);

-- User Roles
CREATE ROLE reader;
CREATE ROLE manager;
GRANT SELECT ON bookstore.* TO reader;
GRANT ALL PRIVILEGES ON bookstore.* TO manager;

-- Create Users
CREATE USER 'alice'@'localhost' IDENTIFIED BY 'password1';
GRANT reader TO 'alice'@'localhost';
CREATE USER 'bob'@'localhost' IDENTIFIED BY 'password2';
GRANT manager TO 'bob'@'localhost';

-- Test Queries
SELECT b.title, a.name FROM book b
JOIN book_author ba ON b.id = ba.book_id
JOIN author a ON ba.author_id = a.id;

SELECT c.first_name, c.last_name, a.street, a.city FROM customer c
JOIN customer_address ca ON c.id = ca.customer_id
JOIN address a ON ca.address_id = a.id
JOIN address_status s ON ca.status_id = s.id
WHERE s.status_name = 'current';

