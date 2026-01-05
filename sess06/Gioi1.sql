CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (order_date, total_amount) VALUES
('2025-01-01', 3500000),
('2025-01-01', 4200000),
('2025-01-01', 3100000),
('2025-01-02', 5200000),
('2025-01-02', 6800000),
('2025-01-03', 1500000),
('2025-01-03', 2700000),
('2025-01-04', 12000000);

SELECT order_date, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY order_date;

SELECT order_date, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_date;

SELECT order_date, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;
