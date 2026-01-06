CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO customers (name, email) VALUES
('Nguyen Van An', 'an@gmail.com'),
('Tran Thi Binh', 'binh@gmail.com'),
('Le Van Cuong', 'cuong@gmail.com'),
('Pham Thi Dao', 'dao@gmail.com'),
('Hoang Van Em', 'em@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 3500000),
(1, '2025-01-05', 4200000),
(1, '2025-01-10', 3100000),
(2, '2025-01-03', 5200000),
(2, '2025-01-08', 6800000),
(3, '2025-01-04', 1500000),
(4, '2025-01-06', 2700000),
(4, '2025-01-09', 8200000),
(5, '2025-01-11', 900000);

SELECT *
FROM customers
WHERE id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(total_spent)
        FROM (
            SELECT SUM(total_amount) AS total_spent
            FROM orders
            GROUP BY customer_id
        ) AS t
    )
);
