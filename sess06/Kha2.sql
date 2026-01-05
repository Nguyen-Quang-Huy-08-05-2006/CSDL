USE ecommerce_db;

ALTER TABLE orders
ADD total_amount DECIMAL(10,2);

UPDATE orders SET total_amount = 3500000 WHERE order_id = 1;
UPDATE orders SET total_amount = 4200000 WHERE order_id = 2;
UPDATE orders SET total_amount = 2800000 WHERE order_id = 3;
UPDATE orders SET total_amount = 1500000 WHERE order_id = 4;
UPDATE orders SET total_amount = 5200000 WHERE order_id = 5;
UPDATE orders SET total_amount = 3100000 WHERE order_id = 6;

SELECT c.customer_id, c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

SELECT c.customer_id, c.full_name, MAX(o.total_amount) AS max_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.customer_id, c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;
