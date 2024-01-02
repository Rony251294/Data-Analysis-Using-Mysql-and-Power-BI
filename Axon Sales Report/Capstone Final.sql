-- Primary KPIs

-- Total revenue
select sum(amount) as total_revenue
from payments;

-- Total orders
select count(distinct orderNumber) as total_orders
from orders;

-- Total customers
select count(distinct customerNumber) as total_customers from customers;

-- Total_profit
SELECT
    SUM((MSRP - buyPrice) * quantityOrdered) AS grand_total_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode;
    
    -- Average order value
select round(sum(amount)/ (select count(distinct orderNumber) from orders),2) as avg_order_value from payments;


-- Other Measures

-- Daily Trend for Total Orders
select dayname(orderDate) as day_name, count(distinct o.orderNumber) as total_orders
from orders o
join customers c on o.customerNumber = c.customerNumber
group by 1
order by 2 desc;

-- Monthly Trend for Total Orders
select monthname(orderDate) as month_name, count(distinct o.orderNumber) as total_orders
from orders o
join customers c on o.customerNumber = c.customerNumber
group by 1
order by 2 desc;

-- Percent Sales by Product Line
select sub.productLine, round((sub.order_count/sum(sub.order_count) over())*100,2) as percent_of_total
from
(SELECT 
    productLine, 
    ROUND((COUNT(DISTINCT orderNumber)*100) / (SELECT COUNT(DISTINCT orderNumber) FROM orders), 2) as percentage_sales,  
    count(distinct orderNumber) as order_count
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    productLine
ORDER BY 
    percentage_sales DESC)sub;
    
-- Customer Distribution by Country

select country, count(distinct customerNumber) as customer_count
from customers 
group by country
order by count(distinct customerNumber) desc;

-- Percent profit by Product Line

select pl.productLine, SUM((MSRP - buyPrice) * quantityOrdered) as profit,
round((SUM((MSRP - buyPrice) * quantityOrdered)/
(SELECT SUM((MSRP - buyPrice) * quantityOrdered)
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode)*100),2) as percent_of_total
from products p
join orderdetails od on p.productCode = od.productCode
join productlines pl on p.productLine = pl.productLine
group by pl.productLine
order by 2 desc;

-- Top 10 Employees by Total Sales

select sub.emp_name,  sub.total_orders, 
round(((sub.total_orders/ sum(sub.total_orders) over())*100),2) as percent_of_total
from
(select e.employeeNumber, e.firstName as emp_name, count(distinct od.orderNumber) as total_orders
from customers c
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
right join employees e on c.salesRepEmployeeNumber = e.employeeNumber
where e.jobTitle = 'Sales Rep'
group by 1,2
order by 3 desc
limit 10)sub;


-- Credit Limit VS Total Orders

Select c.customerName, c.creditLimit, count(distinct o.orderNumber) as total_orders
from customers c
left join orders o on c.customerNumber = o.customerNumber
group by 1,2
order by 2 desc;


-- Yearly Trend of Total Profit

SELECT
    year(orders.orderDate) as order_year, 
    SUM((products.MSRP - products.buyPrice) * orderdetails.quantityOrdered) as yearly_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode
JOIN 
	orders  ON orders.orderNumber = orderdetails.orderNumber
    group by 1
    order by 1;
    
    
-- Top 5 Products by Total Profit

SELECT
    products.productName, 
    SUM((products.MSRP - products.buyPrice) * orderdetails.quantityOrdered) as total_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode
JOIN 
	orders  ON orders.orderNumber = orderdetails.orderNumber
    group by 1
    order by 2 desc
    limit 5;
    

-- Bottom 5 Products by Total Profit


SELECT
    products.productName, 
    SUM((products.MSRP - products.buyPrice) * orderdetails.quantityOrdered) as total_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode
JOIN 
	orders  ON orders.orderNumber = orderdetails.orderNumber
    group by 1
    order by 2 
    limit 5;
    
    
-- Top 5 Products Contribution in total Profit
    
select sum(sub.total_profit) over() as total_profit_of_top_5,
	   round(((sum(sub.total_profit) over()/
(SELECT
    SUM((MSRP - buyPrice) * quantityOrdered) AS grand_total_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode))*100),2) as percent_of_total
from
(SELECT
    products.productName, 
    SUM((products.MSRP - products.buyPrice) * orderdetails.quantityOrdered) as total_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode
JOIN 
	orders  ON orders.orderNumber = orderdetails.orderNumber
    group by 1
    order by 2 desc
    limit 5)sub
    limit 1;
    
    
-- Bottom 5 Products Contribution in Total Profit

select sum(sub.total_profit) over() as total_profit_of_bottom_5,
	   round(((sum(sub.total_profit) over()/
(SELECT
    SUM((MSRP - buyPrice) * quantityOrdered) AS grand_total_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode))*100),2) as percent_of_total
from
(SELECT
    products.productName, 
    SUM((products.MSRP - products.buyPrice) * orderdetails.quantityOrdered) as total_profit
FROM
    products
JOIN
    orderdetails ON products.productCode = orderdetails.productCode
JOIN 
	orders  ON orders.orderNumber = orderdetails.orderNumber
    group by 1
    order by 2 
    limit 5)sub
    limit 1;


    

