-- Load Northwind sample data

-- Insert data into product_costs
INSERT INTO product_costs (product_id, cost)
SELECT product_id, ROUND((unit_price * 0.70)::numeric, 2)
FROM products
ON CONFLICT (product_id) DO NOTHING;