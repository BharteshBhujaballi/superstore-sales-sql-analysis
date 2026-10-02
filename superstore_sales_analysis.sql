CREATE DATABASE SQL_PROJECT;
USE SQL_PROJECT;

-- QUESTION 1:Display all records from the Superstore sales table.
SELECT * 
FROM SAMPLESUPERSTORE;

-- Question 2:Display only the Category, Sub Category, Sales, Quantity, Discount, and Profit columns.
SELECT CATEGORY,"SUB CATEGORY",SALES,QUANTITY,DISCOUNT,PROFIT
FROM SAMPLESUPERSTORE;

-- Question 3:Find all distinct Categories,Subcategory and Regions available in the dataset.
SELECT DISTINCT CATEGORY,SUBCATEGORY,REGION
FROM SAMPLESUPERSTORE;

-- Question 4:Find all sales transactions where the Sales amount is greater than 500.
SELECT * 
FROM SAMPLESUPERSTORE
WHERE SALES>500;

-- Question 5:Display all transactions where the Discount is greater than 20% and Profit is negative.
SELECT * FROM SAMPLESUPERSTORE
WHERE DISCOUNT>0.20 AND PROFIT<0;

-- Filtering, Sorting & Calculations – 6 to 10
-- Question 6:Display all transactions from the Consumer segment and sort them by Sales in descending order.
SELECT * FROM SAMPLESUPERSTORE
WHERE SEGMENT='CONSUMER'
ORDER BY SALES DESC;

-- Question 7:Find the 10 highest-sales transactions in the dataset.
SELECT * FROM SAMPLESUPERSTORE
ORDER BY SALES
LIMIT 10;

-- Question 8:Calculate the total Sales, total Quantity, total Discount, and total Profit for the entire dataset.
SELECT SUM(SALES) AS TOTAL_SALES,
       SUM(QUANTITY) AS TOTAL_QUANTITY,
       SUM(DISCOUNT) AS TOTAL_DISCOUNT,
       SUM(PROFIT) AS TOTAL_PROFIT
FROM SAMPLESUPERSTORE;

-- Question 9:Calculate the average Sales, average Discount, and average Profit for all transactions.
SELECT AVG(SALES) AS AVERAGE_SALES,
       AVG(DISCOUNT) AS AVERAGE_DISCOUNT,
       AVG(PROFIT) AS AVERAGE_PROFIT
FROM SAMPLESUPERSTORE;

-- Question 10:Create a calculated column called Profit_Status using CASE.
SELECT SALES,PROFIT,
CASE
WHEN PROFIT>0 THEN 'PROFITABLE' 
WHEN PROFIT<0 THEN 'LOSS'
ELSE 'NO PROFIT'
END AS 'PROFIT_STATUES'
FROM SAMPLESUPERSTORE;

-- GROUP BY & HAVING – 11 to 15
-- Question 11:Find the total Sales and total Profit for each Category.
SELECT CATEGORY,
       SUM(SALES) AS TOTAL_SALES,
       SUM(PROFIT) AS TOTAL_PROFIT
FROM SAMPLESUPERSTORE
GROUP BY CATEGORY;

-- Question 12:Find the total Sales, total Quantity, and total Profit for each Region and sort the results by total Profit in descending order.
SELECT REGION,
	   SUM(SALES) AS TOTAL_SALES,
       SUM(QUANTITY) AS TOTAL_QUANTITY,
       SUM(PROFIT) AS TOTAL_PROFIT
FROM SAMPLESUPERSTORE
GROUP BY REGION
ORDER BY TOTAL_PROFIT DESC;

-- Question 13:Find the top 5 Sub-Categories based on total Sales.
SELECT SUBCATEGORY,
       SUM(SALES) AS TOTAL_SALES
FROM SAMPLESUPERSTORE
GROUP BY SUBCATEGORY
ORDER BY TOTAL_SALES DESC
LIMIT 5;

-- Question 14:Find the average Discount for each Category and display only categories whose average Discount is greater than 15%.
SELECT CATEGORY,
       AVG(DISCOUNT) AS AVERAGE_DISCOUNT
FROM SAMPLESUPERSTORE
GROUP BY CATEGORY
HAVING AVG(DISCOUNT)>0.15;

-- Question 15:Find the cities whose total Sales are greater than the average city Sales using a subquery.
SELECT CITY,SUM(SALES) AS TOTAL_SALES FROM SAMPLESUPERSTORE
GROUP BY CITY
HAVING SUM(SALES)>(SELECT AVG(CITY_SALES) FROM (SELECT CITY,SUM(SALES) AS CITY_SALES
FROM SAMPLESUPERSTORE
GROUP BY CITY) AS CITY_TOTALS)
ORDER BY TOTAL_SALES DESC;

-- Subqueries – 16 to 18
-- Question 16:Find all transactions where the Sales amount is greater than the overall average Sales.
SELECT *
FROM SAMPLESUPERSTORE
WHERE SALES>(SELECT 
             AVG(SALES)
FROM SAMPLESUPERSTORE
);

-- Question 17:Find the Sub-Category with the highest total Profit using a subquery.
SELECT SUBCATEGORY,SUM(PROFIT) AS SUBCATEGORY_TOTAL
FROM SAMPLESUPERSTORE
GROUP BY SUBCATEGORY
HAVING SUM(PROFIT)=(SELECT MAX(SUBCATEGORY_TOTAL)
FROM (SELECT SUBCATEGORY,SUM(PROFIT) AS SUBCATEGORY_TOTAL
FROM SAMPLESUPERSTORE
GROUP BY SUBCATEGORY)AS SUBCATEGORY_TOTAL);

-- Question 18:Find all States whose total Sales are greater than the average total Sales of all States.
SELECT STATE,SUM(STATE) AS TOTAL_STATE
FROM SAMPLESUPERSTORE
GROUP BY STATE
HAVING SUM(SALES)>(SELECT AVG(STATE_SALES)
FROM (SELECT STATE,SUM(STATE) AS STATE_SALES
      FROM SAMPLESUPERSTORE
	  GROUP BY STATE) AS STATE_TOTALS);
	
-- Joins – 19 to 21
-- Question 19:Using a JOIN, display each Category along with its total Sales and total Profit.
SELECT S.CATEGORY,S.TOTAL_SALES,P.TOTAL_PROFIT
FROM (SELECT CATEGORY,SUM(SALES) AS TOTAL_SALES
FROM SAMPLESUPERSTORE
GROUP BY CATEGORY) AS S
JOIN (SELECT CATEGORY,SUM(PROFIT) AS TOTAL_PROFIT
FROM SAMPLESUPERSTORE
GROUP BY CATEGORY) AS P
ON S.CATEGORY=P.CATEGORY;

-- Question 20:Using a JOIN, compare the total Sales of each Region with the overall total Sales and calculate each Region's percentage contribution to total Sales.
SELECT R.REGION,R.TOTAL_SALES,T.OVERALL_SALES,
ROUND((R.TOTAL_SALES/T.OVERALL_SALES)*100,2) AS PERCENTAGE_SALES
FROM (SELECT REGION,SUM(SALES) AS TOTAL_SALES
FROM SAMPLESUPERSTORE
GROUP BY REGION
) AS R
JOIN 
(SELECT REGION,SUM(SALES) AS OVERALL_SALES
FROM SAMPLESUPERSTORE
GROUP BY REGION
) AS T;

-- Question 21:Using a JOIN, identify the Product Types that have both total Sales greater than 100,000 and total Profit greater than 10,000.
SELECT S.SUBCATEGORY,S.TOTAL_SALES,T.TOTAL_PROFIT
FROM (SELECT SUBCATEGORY,SUM(SALES) AS TOTAL_SALES
FROM SAMPLESUPERSTORE
GROUP BY SUBCATEGORY
) AS S
JOIN
( SELECT SUBCATEGORY,SUM(PROFIT) AS TOTAL_PROFIT
FROM SAMPLESUPERSTORE
GROUP BY SUBCATEGORY
) AS T
ON S.SUBCATEGORY=T.SUBCATEGORY
WHERE S.TOTAL_SALES>100000
AND T.TOTAL_PROFIT>10000
ORDER BY S.TOTAL_SALES DESC;

-- Set Operators – 22 to 23
-- Question 22:Using UNION, create a single list containing all Cities and States from the dataset, without duplicate values.
SELECT CITY AS LOCATION 
FROM SAMPLESUPERSTORE
UNION
SELECT STATE AS LOCATION
FROM SAMPLESUPERSTORE;

-- Question 23:Using a set operator such as INTERSECT, find the Cities that appear in both the Consumer and Corporate segments.
SELECT CITY
FROM SAMPLESUPERSTORE
WHERE SEGMENT='CONSUMER'
INTERSECT
SELECT CITY
FROM SAMPLESUPERSTORE
WHERE SEGMENT='CORPORATE';

-- Question 24:Use the ROW_NUMBER() window function to assign a row number to each transaction based on Sales in descending order. Display Sales, Profit, and the row number.
SELECT SALES,PROFIT,
ROW_NUMBER () OVER(ORDER BY SALES DESC)
FROM SAMPLESUPERSTORE;

-- Question 25:Use the RANK() window function to rank transactions based on Profit in descending order. Display Sales, Profit, and the Profit Rank.
SELECT SALES,PROFIT,
RANK() OVER(ORDER BY PROFIT DESC)
FROM SAMPLESUPERSTORE;













       
    











   





-- 

