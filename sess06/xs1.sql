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
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (full_name, city) VALUES
('Nguyen Van An', 'Ha Noi'),
('Tran Thi Binh', 'TP.HCM'),
('Le Van Cuong', 'Da Nang'),
('Pham Thi Dao', 'Ha Noi'),
('Hoang Van Em', 'TP.HCM');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 3500000),
(1, '2025-01-05', 4200000),
(1, '2025-01-10', 3100000),
(2, '2025-01-03', 5200000),
(2, '2025-01-08', 6800000),
(3, '2025-01-04', 1500000),
(4, '2025-01-06', 2700000),
(4, '2025-01-09', 8200000),
(4, '2025-01-12', 1200000),
(5, '2025-01-11', 900000);

SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 3
   AND SUM(o.total_amount) > 10000000
ORDER BY total_spent DESC;
