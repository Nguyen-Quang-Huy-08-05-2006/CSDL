CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL
);

INSERT INTO customers (full_name, city) VALUES
('Nguyen Van An', 'Ha Noi'),
('Tran Thi Binh', 'TP.HCM'),
('Le Van Cuong', 'Da Nang'),
('Pham Thi Dao', 'Ha Noi'),
('Hoang Van Em', 'TP.HCM');

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-01-01', 'completed'),
(1, '2025-01-05', 'pending'),
(2, '2025-01-03', 'completed'),
(3, '2025-01-04', 'cancelled'),
(4, '2025-01-06', 'completed'),
(2, '2025-01-07', 'pending');

SELECT o.order_id, o.order_date, o.status, c.full_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;
