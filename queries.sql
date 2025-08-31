-- Total cost, total revenue, total profit of all units of each product
select
    p.product_id,
    product_name,
    round(SUM((pc.cost::numeric * od.quantity::numeric)), 2) AS total_cost,
    round(SUM((od.unit_price * (1 - od.discount))::numeric * od.quantity), 2) as total_revenue,
    round(SUM(((od.unit_price * (1 - od.discount)) - pc.cost)::numeric * od.quantity), 2) as total_profit
from order_details od
join product_costs pc on pc.product_id = od.product_id
join products p on p.product_id = pc.product_id
group by p.product_id, product_name
order by total_profit desc

-- top 5 most profitable products
select
    p.product_name,
    p.product_id,
    round(SUM((od.unit_price::numeric * (1 - discount)::numeric * quantity::numeric)), 2) AS total_revenue
from order_details od
join products p on p.product_id=od.product_id
group by p.product_id, p.product_name
order by total_revenue
limit 5