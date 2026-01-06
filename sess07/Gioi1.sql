CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 3500000),
(2, '2025-01-02', 5200000),
(3, '2025-01-03', 1500000),
(1, '2025-01-04', 8200000),
(4, '2025-01-05', 2700000),
(2, '2025-01-06', 6800000);

SELECT *
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM orders
);
