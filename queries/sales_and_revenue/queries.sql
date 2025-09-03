-- What are the top 10 customers by lifetime revenue?
select company_name,
       total_revenue,
       rank() over (order by sub.total_revenue desc) as rank
from (
    select o.customer_id,
    round(SUM((od.unit_price * (1 - od.discount))::numeric * od.quantity), 2) as total_revenue
    from orders o
    join order_details od on o.order_id = od.order_id
    group by customer_id
     ) sub
join customers c on c.customer_id = sub.customer_id
order by rank
limit 10



-- Which products are the most profitable (revenue − cost)?
with ProductProfitability AS (
    select
    p.product_id,
    product_name,
    ROUND(SUM((pc.cost::numeric * od.quantity::numeric)), 2) AS total_cost,
    round(SUM((od.unit_price * (1 - od.discount))::numeric * od.quantity), 2) as total_revenue,
    round(SUM(((od.unit_price * (1 - od.discount)) - pc.cost)::numeric * od.quantity), 2) as total_profit,
     round(
        SUM(((od.unit_price * (1 - od.discount)) - pc.cost)::numeric * od.quantity)
        / NULLIF(SUM((od.unit_price * (1 - od.discount))::numeric * od.quantity), 0) * 100, 2
    ) as margin_percent
    from order_details od
    join product_costs pc on pc.product_id = od.product_id
    join products p on p.product_id = pc.product_id
    group by p.product_id, product_name
)

select *,
case
    when margin_percent >= 30 then 'High Margin'
    when margin_percent >= 15 then 'Medium Margin'
    else 'Low Margin'
end as margin_label
from ProductProfitability
order by margin_percent desc


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



-- Which categories drive the most sales?
select c.category_name, count(od.product_id) as sales_number
from order_details od
join products p on od.product_id = p.product_id
join categories c on c.category_id = p.category_id
group by c.category_name
order by sales_number desc