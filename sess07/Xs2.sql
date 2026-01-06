CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 3000000),
(1, '2025-01-05', 5000000),
(2, '2025-01-03', 4000000),
(2, '2025-01-08', 2000000),
(3, '2025-01-04', 1500000),
(3, '2025-01-10', 2500000),
(4, '2025-01-06', 9000000),
(5, '2025-01-11', 1000000);

SELECT
    customer_id,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(total_amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) AS t
);
