-- A1: List all orders with status and purchase date
SELECT order_id, customer_id, order_status, order_purchase_timestamp
FROM orders
ORDER BY order_purchase_timestamp DESC;

-- A2: Customers who placed more than 3 orders
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING order_count > 3;

-- B1: Total amount per order (JOIN orders with order_items)
SELECT o.order_id, SUM(oi.price + oi.freight_value) AS total_amount
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- B2: LEFT JOIN - Orders with or without reviews
SELECT o.order_id, orr.review_score
FROM orders o
LEFT JOIN order_reviews orr ON o.order_id = orr.order_id;

-- B3: Simulate RIGHT JOIN - Sellers with or without sales (using LEFT JOIN from sellers' perspective)
SELECT s.seller_id, COUNT(oi.order_id) AS total_sales
FROM sellers s
LEFT JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id;

-- C1: Customers who spent more than the average
SELECT customer_id
FROM (
    SELECT o.customer_id, SUM(oi.price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT o.customer_id, SUM(oi.price) AS total_spent
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    )
);

-- D1: Average payment amount per order
SELECT order_id, AVG(payment_value) AS avg_payment
FROM order_payments
GROUP BY order_id;

-- D2: Total revenue generated
SELECT SUM(payment_value) AS total_revenue
FROM order_payments;

-- E1: Create an index on customer_id in orders
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- E2: Create index on seller_id in order_items
CREATE INDEX idx_orderitems_seller ON order_items(seller_id)