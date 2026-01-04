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
(1, 3500000, '2025-01-10', 'completed'),
(2, 7200000, '2025-01-12', 'pending'),
(3, 12000000, '2025-01-15', 'completed'),
(1, 4800000, '2025-01-18', 'cancelled'),
(4, 9500000, '2025-01-20', 'completed'),
(2, 1500000, '2025-01-22', 'completed');

SELECT *
FROM orders
WHERE status = 'completed';

SELECT *
FROM orders
WHERE total_amount > 5000000;

SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;

SELECT *
FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;
