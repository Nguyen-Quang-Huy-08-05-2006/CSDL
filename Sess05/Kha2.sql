CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO customers (full_name, email, city, status) VALUES
('Nguyen Van An', 'an@gmail.com', 'Ha Noi', 'active'),
('Tran Thi Binh', 'binh@gmail.com', 'TP.HCM', 'active'),
('Le Van Cuong', 'cuong@gmail.com', 'Da Nang', 'inactive'),
('Pham Thi Dao', 'dao@gmail.com', 'Ha Noi', 'active'),
('Hoang Van Em', 'em@gmail.com', 'TP.HCM', 'inactive');

SELECT * 
FROM customers;

SELECT * 
FROM customers
WHERE city = 'TP.HCM';

SELECT * 
FROM customers
WHERE status = 'active' AND city = 'Ha Noi';

SELECT * 
FROM customers
ORDER BY full_name ASC;
