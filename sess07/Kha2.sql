CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO products (name, price) VALUES
('iPhone 15', 25000000),
('Samsung Galaxy S23', 18000000),
('Tai nghe Bluetooth', 1500000),
('Ban phim co', 1800000),
('Chuot khong day', 450000),
('USB 64GB', 350000),
('Loa Bluetooth', 1700000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 1, 1),
(6, 5, 3);

SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);
