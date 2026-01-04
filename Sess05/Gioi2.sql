CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    sold_quantity INT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO products (product_name, price, stock, sold_quantity, status) VALUES
('iPhone 15', 25000000, 10, 120, 'active'),
('Samsung Galaxy S23', 18000000, 15, 95, 'active'),
('Laptop Dell Inspiron', 22000000, 5, 80, 'active'),
('Tai nghe Bluetooth', 1500000, 30, 200, 'active'),
('Chuột không dây Logitech', 450000, 50, 300, 'active'),
('Bàn phím cơ Keychron', 1800000, 20, 160, 'active'),
('USB 64GB', 350000, 100, 400, 'active'),
('Ổ cứng SSD 512GB', 1900000, 25, 140, 'active'),
('Webcam Full HD', 1200000, 40, 110, 'inactive'),
('Sạc nhanh 65W', 900000, 60, 260, 'active');

SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 10;

SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 10, 5;

SELECT *
FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;
