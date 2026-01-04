CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO products (product_name, price, stock, status) VALUES
('iPhone 15', 25000000, 10, 'active'),
('Samsung Galaxy S23', 18000000, 15, 'active'),
('Laptop Dell Inspiron', 22000000, 5, 'active'),
('Chuột không dây Logitech', 450000, 50, 'inactive'),
('Bàn phím cơ Keychron', 1800000, 20, 'active');


SELECT * 
FROM products;

SELECT * 
FROM products
WHERE status = 'active';

SELECT * 
FROM products
WHERE price > 1000000;

SELECT * 
FROM products
WHERE status = 'active'
ORDER BY price ASC;
