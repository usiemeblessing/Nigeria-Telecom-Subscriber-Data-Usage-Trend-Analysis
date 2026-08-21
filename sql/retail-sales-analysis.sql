-- Part B - SQL (Business Queries) 
-- Question 22. Create a table called retail_sales and import the dataset

CREATE DATABASE IF NOT EXISTS retail_sales_db;

USE retail_sales_db;

CREATE TABLE retail_sales(
order_id VARCHAR (20),
customer_id VARCHAR (20),
customer_name VARCHAR (50),
customer_email VARCHAR (50),
product_name VARCHAR (50),
category VARCHAR (50),
region VARCHAR (20),
state VARCHAR (20),
quantity INT,
unit_price DECIMAL(15,2),
discount_rate DOUBLE,
gross_revenue DECIMAL(15,2),
net_revenue DECIMAL(15,2),
is_gross_equal_to_net VARCHAR (10),
payment_method VARCHAR (20),
order_date DATE,
order_year INT,
order_month VARCHAR (20),
order_quarter INT,
order_day_of_week VARCHAR (20),
delivery_days INT,
returned VARCHAR (10),
salesperson_id VARCHAR (20)
);

-- load csv file into mysql workbench 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/retail_sales.csv'
INTO TABLE retail_sales
FIELDS TERMINATED BY ","
IGNORE 1 LINES;

SELECT * FROM retail_sales limit 5; 

Question 23. Total revenue by region — ordered highest to lowest 
SELECT region, sum(net_revenue) AS total_revenue
FROM retail_sales
GROUP BY region
ORDER BY total_revenue DESC;

-- Question 24. Top 5 customers by total spending

select customer_id, customer_name, sum(net_revenue) as total_spending
from retail_sales
group by customer_id, customer_name
order by total_spending desc limit 5;

-- Question 25. Monthly revenue trend: year, month, total revenue, total orders
SELECT 
    order_year, 
    order_month, 
    SUM(net_revenue) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY order_year, order_month
ORDER BY order_year, STR_TO_DATE(CONCAT('01-', order_month, '-', order_year), '%d-%M-%Y');

-- Question 26. Return rate by category (% of orders returned)
SELECT 
    category,
    COUNT(CASE WHEN returned = 'Yes' THEN 1 END) * 100.0 / COUNT(*) AS return_rate_percentage
FROM retail_sales
GROUP BY category;

-- Question 27. Average delivery days by payment method
SELECT 
    payment_method, 
    AVG(delivery_days) AS avg_delivery_days
FROM retail_sales
GROUP BY payment_method;

-- Question 28. Revenue contribution by category (category, revenue, % of total)
SELECT 
    category,
    SUM(net_revenue) AS category_revenue,
    SUM(net_revenue) * 100.0 / (SELECT SUM(net_revenue) FROM retail_sales) AS percentage_of_total
FROM retail_sales
GROUP BY category;

-- Question 29. Identify customers who have placed more than 5 orders
    SELECT 
    customer_id, 
    customer_name, 
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) > 5;

-- Question 30. Month-over-month revenue growth using a window function (LAG)
WITH MonthlyRevenue AS (
    SELECT 
        order_year,
        order_month,
        SUM(net_revenue) AS current_month_revenue,
        -- Generates a sequence number to properly sort and lag sequential months
        ROW_NUMBER() OVER (ORDER BY order_year, STR_TO_DATE(CONCAT('01-', order_month, '-', order_year), '%d-%M-%Y')) AS seq
    FROM retail_sales
    GROUP BY order_year, order_month
)
SELECT 
    order_year,
    order_month,
    current_month_revenue,
    LAG(current_month_revenue, 1) OVER (ORDER BY seq) AS previous_month_revenue,
    (current_month_revenue - LAG(current_month_revenue, 1) OVER (ORDER BY seq)) AS revenue_growth
FROM MonthlyRevenue;


-- Question 31. Products with above-average revenue per unit
SELECT 
    product_name,
    AVG(net_revenue / quantity) AS avg_product_revenue_per_unit
FROM retail_sales
GROUP BY product_name
HAVING avg_product_revenue_per_unit > (
    SELECT AVG(net_revenue / quantity) 
    FROM retail_sales 
    WHERE quantity > 0
);

-- Question 32. Rank salespersons by total revenue using RANK()
SELECT 
    salesperson_id,
    SUM(net_revenue) AS total_revenue,
    RANK() OVER (ORDER BY SUM(net_revenue) DESC) AS revenue_rank
FROM retail_sales
GROUP BY salesperson_id;












