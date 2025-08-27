CREATE TABLE RETAIL_ANALYSIS (
     transactions_id INT PRIMARY KEY,	
	 sale_date DATE NOT NULL,
	 sale_time TIME NOT NULL,
	 customer_id INT NOT NULL,
	 gender	VARCHAR(10) NOT NULL,
	 age INT NOT NULL,	
	 category VARCHAR(50),
	 quantiy INT NOT NULL,	
	 price_per_unit	FLOAT NOT NULL,
	 cogs FLOAT NOT NULL,	
	 total_sale FLOAT NOT NULL

);

SELECT * FROM RETAIL_ANALYSIS;

-- DATA CLEANING 
SELECT *
FROM RETAIL_ANALYSIS
WHERE 
      transactions_id is NULL
      OR
      sale_date is NULL
	  OR
      sale_time is NULL
	  OR
      customer_id is NULL
	  OR
      gender is NULL
	  OR
      age is NULL
	  OR
      category is NULL
	  OR
      quantiy is NULL
	  OR
      price_per_unit is NULL
	  OR
      cogs is NULL
	  OR
      total_sale is NULL
;

DELETE FROM RETAIL_ANALYSIS
WHERE
transactions_id is NULL
      OR
      sale_date is NULL
	  OR
      sale_time is NULL
	  OR
      customer_id is NULL
	  OR
      gender is NULL
	  OR
      age is NULL
	  OR
      category is NULL
	  OR
      quantiy is NULL
	  OR
      price_per_unit is NULL
	  OR
      cogs is NULL
	  OR
      total_sale is NULL;

-- DATA EXPLORATION
SELECT COUNT(*)
FROM RETAIL_ANALYSIS;

-- HOW MANY SALES WE HAVE
SELECT COUNT(*) AS TOTAL_SALES
FROM RETAIL_ANALYSIS;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE
SELECT COUNT(customer_id) AS TOTAL_CUSTOMERS
FROM RETAIL_ANALYSIS;

-- TOTAL NO OF CATEGORY WE HAVE
SELECT DISTINCT category
FROM RETAIL_ANALYSIS;

-- DATA ANALYSIS
-- MY ANALYSIS & FINDINGS

--SALES MADE ON '2022-11-05'
SELECT *
FROM RETAIL_ANALYSIS
WHERE sale_date = '2022-11-05';

-- RETRIEVE ALL TRANSACTIONS,CATEGORY IS CLOTHING & QUANTITY IS MORE THAN 4 IN MONTH OF NOV-2022
SELECT *
FROM RETAIL_ANALYSIS
WHERE category = 'Clothing' AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'AND quantiy>=4;

--CALCULATE THE TOTAL SALES FOR EACH CATEGORY
SELECT category,SUM(total_sale) as net_sale,COUNT(*) AS total_orders
FROM RETAIL_ANALYSIS
GROUP BY 1;

--FIND AVG OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'BEAUTY CATEGORY'
SELECT ROUND(AVG(age),2) as AVG_AGE
FROM RETAIL_ANALYSIS
WHERE category ='Beauty';

-- FIND ALL TRANSACTIONS WHERE THE TOTAL_SALE > 1000
SELECT *
FROM RETAIL_ANALYSIS
WHERE total_sale>1000;

--FIND TOTAL NUMBER OF TRANSACTIONS(TRANSACTION_ID) MADE BY EACH GENDER IN EACH CATEGORY
SELECT gender,category,COUNT(*) as TOTAL_TRANS
FROM RETAIL_ANALYSIS
GROUP BY category,gender
ORDER BY 1;

--CALCULATE THE AVG SALE FOR EACH MONTH AND FIND OUT THE BEST SELLING MONTH IN EACH YEAR
-- USE EXTRACT FRUNCTION TO GET YEAR , MONTH  & WINDOW FUNCTION FOR RANKING
SELECT year,month,avg_sale

FROM
(
    SELECT EXTRACT(year FROM sale_date) as year,
           EXTRACT(month FROM sale_date) as month,
	       AVG(TOTAL_SALE) as avg_sale,
	       RANK() OVER(PARTITION BY EXTRACT(year FROM sale_date) ORDER BY AVG(total_sale) desc) as rank
    FROM RETAIL_ANALYSIS
    GROUP BY 1,2
) AS t1
WHERE rank =1;
-- ORDER BY 1,3 DESC;

--FIND THE TOP 5 CUSTOMERS BASED ONN THE HIGHEST TOTAL SALE
SELECT customer_id,SUM(total_sale) as total_sale
FROM RETAIL_ANALYSIS
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEM FOR EACH CATEGORY
SELECT category,COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER
FROM RETAIL_ANALYSIS
GROUP BY category;

-- CREATE EACH SHIFT AND NUMBER OF ORDERS(EXAMPLE MORNING <=12,AFTERNOON BETWEEN 12& 17,EVENING >17)
-- USE CASE STATEMENT and CTE(COMMON TABLE EXPRESSION)
WITH hourly_sale
as
(
SELECT *,
         CASE
		     WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'Morning'
			 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			 ELSE 'Evening'
		 END AS shift
FROM RETAIL_ANALYSIS
)
SELECT shift,COUNT(*) AS TOTAL_ORDERS
FROM hourly_sale
GROUP BY shift

-- End Of Project
