CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL
);

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 3500000, '2025-01-01', 'completed'),
(2, 7200000, '2025-01-02', 'pending'),
(3, 12000000, '2025-01-03', 'completed'),
(1, 4800000, '2025-01-04', 'cancelled'),
(4, 9500000, '2025-01-05', 'completed'),
(2, 1500000, '2025-01-06', 'completed'),
(3, 6600000, '2025-01-07', 'pending'),
(1, 8300000, '2025-01-08', 'completed'),
(4, 2100000, '2025-01-09', 'completed'),
(2, 5400000, '2025-01-10', 'pending'),
(3, 7600000, '2025-01-11', 'completed'),
(1, 1900000, '2025-01-12', 'completed');

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;
