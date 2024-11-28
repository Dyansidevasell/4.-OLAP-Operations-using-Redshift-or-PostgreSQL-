/* OLAP Operations (using Redshift or PostgreSQL)
Develop the queries to retrieve information from the OLAP operations performed and to gain a deeper understanding of the sales data through different dimensions, aggregations, and filters.
Perform OLAP operations (Drill Down, Rollup, Cube, Slice, and Dice) on the "sales_sample" table to analyze sales data. The project will include the following tasks */

/* 1. Database Creation
Create a database to store the sales data (Redshift or PostgreSQL) */

CREATE DATABASE sales_data;

/* Create a table named "sales_sample" with the specified columns: Product_Id (Integer), Region (varchar(50))-like East ,West etc, Date (Date),Sales_Amount (int/numeric) */

CREATE TABLE sales_sample (Product_Id INTEGER,Region VARCHAR(100),Date DATE,Sales_Amount NUMERIC);

ALTER TABLE sales_sample
ALTER COLUMN Region TYPE VARCHAR(50); -- Changed Region varchar from 100 to 50 as question was mentioned as varchar 50

Select * From sales_sample;

/* 2. Data Creation 
Insert 10 sample records into the "sales_sample" table, representing sales data. */

INSERT INTO sales_sample (Product_Id, Region, Date, Sales_Amount)
VALUES
(1, 'North', '2024-09-25', 500.00),
(2, 'South', '2024-11-22', 200.00),
(3, 'East', '2024-07-15', 800.00),
(4, 'West', '2024-09-25', 700.00),
(5, 'North', '2024-02-15', 900.00),
(6, 'South', '2024-08-31', 600.00),
(7, 'East', '2024-06-05', 4300.00),
(8, 'West', '2024-05-10', 5500.00),
(9, 'South', '2024-03-09', 1000.00),
(10, 'North', '2024-01-18', 2200.00);

/* 3. Perform OLAP operations 
a) Drill Down-Analyze sales data at a more detailed level. Write a query to perform drill down from region to product level to understand sales performance. */

SELECT Region, Product_Id, SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
GROUP BY Region, Product_Id
ORDER BY Region, Product_Id;

/* b) Rollup- To summarize sales data at different levels of granularity. Write a query to perform roll up from product to region level to view total sales by region.  */

WITH ProductLevelSales AS ( 
SELECT Region, Product_Id, SUM(Sales_Amount) AS Total_Sales_Per_Product
FROM sales_sample
GROUP BY Region, Product_Id)

SELECT Region, SUM(Total_Sales_Per_Product) AS Total_Sales_By_Region
FROM ProductLevelSales
GROUP BY Region
ORDER BY Region;

/* c) Cube - To analyze sales data from multiple dimensions simultaneously. Write a query to Explore sales data from different perspectives, such as product, region, and date. */

SELECT Product_Id, Region, Date, SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
GROUP BY CUBE (Product_Id, Region, Date)
ORDER BY Product_Id, Region, Date;

/* d) Slice- To extract a subset of data based on specific criteria. Write a query to slice the data to view sales for a particular region or date range.  */

SELECT Product_Id, Region, Date, Sales_Amount
FROM sales_sample
WHERE Region = 'South' AND Date BETWEEN '2024-03-15' AND '2024-12-31'
ORDER BY Product_Id, Date;

/* e) Dice - To extract data based on multiple criteria. Write a query to view sales for specific combinations of product, region, and date */

SELECT Product_Id, Region, Date, Sales_Amount
FROM sales_sample
WHERE Product_Id IN (7, 9) AND Region IN ('North', 'East') AND Date BETWEEN '2024-02-25' AND '2024-12-31'
ORDER BY Product_Id, Region, Date;
