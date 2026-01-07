CREATE DATABASE shopping_system;
USE shopping_system;

CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	phone VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE categories(
	category_id INT PRIMARY KEY AUTO_INCREMENT,
	category_name VARCHAR(255) NOT NULL
);

CREATE TABLE products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
	product_name VARCHAR(255) NOT NULL,
	price DECIMAL(10,2) NOT NULL CHECK(price > 0),
	category_id INT,
	FOREIGN KEY(category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_id INT,
	order_date DATETIME,
	status ENUM('Pending','Completed','Cancel'),
	FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
	order_item_id INT PRIMARY KEY AUTO_INCREMENT,
	order_id INT,
	product_id INT,
	quantity INT CHECK(quantity > 0),
	FOREIGN KEY(order_id) REFERENCES orders(order_id),
	FOREIGN KEY(product_id) REFERENCES products(product_id)
);

-- Phần A
SELECT * FROM categories;

SELECT * 
FROM orders
WHERE status = 'Completed';

SELECT * 
FROM products
ORDER BY price DESC;

SELECT * 
FROM products
ORDER BY price DESC
LIMIT 5 OFFSET 2;

-- Phần B
SELECT 
	p.product_name,
	p.price,
	c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id;

SELECT
	o.order_id,
	o.order_date,
	c.customer_name,
	o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT
	order_id,
	SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id;

SELECT
	c.customer_name,
	COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT
	c.customer_name,
	COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;

SELECT
	c.category_name,
	AVG(p.price) AS avg_price,
	MIN(p.price) AS min_price,
	MAX(p.price) AS max_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name;

-- Phần C
SELECT *
FROM products
WHERE price > (
	SELECT AVG(price) FROM products
);

SELECT *
FROM customers
WHERE customer_id IN (
	SELECT customer_id FROM orders
);

SELECT order_id
FROM order_items
GROUP BY order_id
HAVING SUM(quantity) = (
	SELECT MAX(total_qty)
	FROM (
		SELECT SUM(quantity) AS total_qty
		FROM order_items
		GROUP BY order_id
	) t
);

SELECT DISTINCT customer_name
FROM customers
WHERE customer_id IN (
	SELECT o.customer_id
	FROM orders o
	JOIN order_items oi ON o.order_id = oi.order_id
	JOIN products p ON oi.product_id = p.product_id
	WHERE p.category_id = (
		SELECT category_id
		FROM products
		GROUP BY category_id
		ORDER BY AVG(price) DESC
		LIMIT 1
	)
);
