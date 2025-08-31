drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120) ,
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--data exploration

--count of rows
SELECT count(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
or
category IS NULL
or
mrp IS NULL
or
discountpercent IS NULL
or
discountsellingprice IS NULL
or
weightInGms IS NULL
or
availablequantity IS NULL
or
outofstock IS NULL
or
quantity IS NULL;



--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;


--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)> 1
ORDER BY count(sku_id) DESC;


--data cleaning

-- products with price = O
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingPrice = 0;


DELETE FROM zepto
WHERE mrp = 0;


--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto


-- QI. Find the top 10 best—value products based on the discount percentage
select distinct name , mrp , discountPercent
from zepto
order by discountPercent desc
limit 10;


--Q2 .What are the Products with High MRP but Out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;



-- Q3. Calculate Estimated Revenue for each category 

SELECT category,
SUM (discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY totat_revenue;

-- Q4. Find all products where MRP is greater than 500and discount is less than 10%

select name , mrp , discountPercent
from zepto
where mrp > 500 and discountPercent < 10


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category , round(avg(discountpercent),2) as avg_discount
from zepto 
group by category 
order by avg_discount desc
limit 5;


--  Q6. Find the price per gram for products above 100g and sort by best value.

select name , round(mrp/ weightingms,2) as price_per_gm
from zepto
where weightingms > 100
order by price_per_gm asc;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT category , name , weightingms,
    CASE
        WHEN weightingms > 1000 THEN 'BULK'
        WHEN weightingms > 500 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS product_size_category
FROM zepto;


-- Q8. What is the Total Inventory Weight Per Category and order in desc

select category , sum(weightingms*availableQuantity) as total_inventory_wt
from zepto 
group by category
order by total_inventory_wt desc ;