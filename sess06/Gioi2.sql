CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price) VALUES
('iPhone 15', 25000000),
('Samsung Galaxy S23', 18000000),
('Tai nghe Bluetooth', 1500000),
('Ban phim co', 1800000),
('Chuot khong day', 450000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 4),
(5, 3, 2),
(6, 4, 3),
(7, 4, 1),
(8, 5, 5);

SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT p.product_id, p.product_name, SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT p.product_id, p.product_name, SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000;
