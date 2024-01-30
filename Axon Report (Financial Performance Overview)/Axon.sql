-- KPIs

-- Total Revenue
select sum(priceEach*quantityOrdered) as Total_Revenue
from orderdetails;

-- COGS 
select sum(p.buyPrice*od.quantityOrdered) as COGS
from orderdetails od
join products p on od.productCode = p.productCode;

-- Total Profit 
select (sum(priceEach*quantityOrdered) - sum(p.buyPrice*od.quantityOrdered)) as Total_Profit
from orderdetails od
join products p on od.productCode = p.productCode;

-- Profit Percentage
select round(((sum(priceEach*quantityOrdered) - sum(p.buyPrice*od.quantityOrdered))/
			sum(priceEach*quantityOrdered)*100),2) as Profit_Percentage
from orderdetails od
join products p on od.productCode = p.productCode;

-- Total Orders
select count(distinct orderNumber) as Total_Orders
from orders;

-- Net Orders
select count(distinct orderNumber) as Total_Orders
from orders
where status not in ('Cancelled', 'Disputed');

-- Gross Order Unit
select sum(quantityOrdered) as Gross_Order_Unit
from orderdetails;

-- Gross Order Unit
select sum(quantityOrdered) as Net_Order_Unit
from orderdetails od
join orders o on od.orderNumber = o.orderNumber
where o.status not in ('Cancelled', 'Disputed');

-- Current Year Revenue
select sum(priceEach*quantityOrdered) as Current_Year_Revenue
from orderdetails od
join orders o on od.orderNumber = o.orderNumber
where year(o.orderDate) = (select max(year(orderDate)) from orders);

-- Total Products 
select count(distinct productCode) as Total_Products
from products;

-- Average Units Per Order
select round(sum(od.quantityOrdered)/ count(distinct o.orderNumber),2) as Average_Units_Per_Order
from orderdetails od
join orders o on od.orderNumber = o.orderNumber;

-- Average Shipping Duration
select ceil(avg(datediff(shippedDate,orderDate))) as Average_Shipping_Days
from orders;

-- Average Order Value
select round(sum(od.priceEach*od.quantityOrdered) / count(distinct o.orderNumber),2) as Average_Order_Value
from orderdetails od
join orders o on od.orderNumber = o.orderNumber;

-- Total Customers 
select count(distinct customerNumber) as Total_Customers
from customers;

-- Active Customers
select count(distinct c.customerNumber) as Active_Customers
from customers c 
join orders o on c.customerNumber = o.customerNumber
where orderDate between (select date_add(max(orderDate), interval -1.5 year) from orders)
				and (select max(orderDate) from orders);
                
-- Average Customer Spend
select round(sum(priceEach*quantityOrdered) / (select count(distinct customerNumber) as Total_Customers
from customers),2) as Average_Customer_Spend
from orderdetails;

-- Total Pending amount
select round(sum(priceEach*quantityOrdered) - (select sum(amount) from payments)) as Total_Pending_Amount
from orderdetails;

-- Overall Churn Rate
select round((((count(distinct customerNumber) - (select count(distinct c.customerNumber) as Active_Customers
from customers c 
join orders o on c.customerNumber = o.customerNumber
where orderDate between (select date_add(max(orderDate), interval -1.5 year) from orders)
				and (select max(orderDate) from orders)))/(select count(distinct customerNumber) as Total_Customers
from customers))*100),2) as Overall_Churn_Rate
from customers;


-- Total Employees
select count(distinct employeeNumber) as Total_Employees from employees;

-- Total Sales Representatives
select count(distinct employeeNumber) as Sales_Representative from employees
where jobTitle = 'Sales Rep';

-- Higher Management
select count(distinct employeeNumber) as Managers from employees
where jobTitle != 'Sales Rep';

-- Average Representatives' Revenue
select round(sum(priceEach*quantityOrdered)/(select count(distinct employeeNumber) as Sales_Representative from employees
where jobTitle = 'Sales Rep'),2) as Average_Rep_Revenue
from orderdetails;

-- Average Representatives' Unit
select round(sum(quantityOrdered)/(select count(distinct employeeNumber) as Sales_Representative from employees
where jobTitle = 'Sales Rep'),2) as Average_Rep_Units
from orderdetails;

-- Total Offices
select count(distinct officeCode) as Total_Offices from offices;

-- Total Regions
select count(distinct territory) as Total_Regions from offices;











