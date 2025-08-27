# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis    
**Database**: `retail_analysis_project`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named ` retail_analysis_project `.
- **Table Creation**: A table named ` RETAIL_ANALYSIS ` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_analysis_project;

CREATE TABLE RETAIL_ANALYSIS
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE NOT NULL,	
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,	
    gender VARCHAR(10) NOT NULL,
    age INT NOT NULL,
    category VARCHAR(35) NOT NULL,
    quantity INT NOT NULL,
    price_per_unit FLOAT NOT NULL,	
    cogs FLOAT NOT NULL,
    total_sale FLOAT NOT NULL
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM RETAIL_ANALYSIS;
SELECT COUNT(DISTINCT customer_id) FROM RETAIL_ANALYSIS;
SELECT DISTINCT category FROM RETAIL_ANALYSIS;

SELECT * FROM RETAIL_ANALYSIS
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM RETAIL_ANALYSIS
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **HOW MANY SALES WE HAVE**:
```sql
SELECT COUNT(*) AS TOTAL_SALES
FROM RETAIL_ANALYSIS;
```

2. **HOW MANY UNIQUE CUSTOMERS WE HAVE**:
```sql
SELECT COUNT(customer_id) AS TOTAL_CUSTOMERS
FROM RETAIL_ANALYSIS;
```

3. **TOTAL NO OF CATEGORY WE HAVE**:
```sql
SELECT DISTINCT category
FROM RETAIL_ANALYSIS;
```

4. **SALES MADE ON '2022-11-05**:
```sql
SELECT *
FROM RETAIL_ANALYSIS
WHERE sale_date = '2022-11-05';
```

5. **RETRIEVE ALL TRANSACTIONS,CATEGORY IS CLOTHING & QUANTITY IS MORE THAN 4 IN MONTH OF NOV-2022**:
```sql
SELECT *
FROM RETAIL_ANALYSIS
WHERE category = 'Clothing' AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'AND quantiy>=4;
```

6. **CALCULATE THE TOTAL SALES FOR EACH CATEGORY**:
```sql
SELECT category,SUM(total_sale) as net_sale,COUNT(*) AS total_orders
FROM RETAIL_ANALYSIS
GROUP BY 1;
```

7. **FIND AVG OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'BEAUTY CATEGORY'**:
```sql
SELECT ROUND(AVG(age),2) as AVG_AGE
FROM RETAIL_ANALYSIS
WHERE category ='Beauty';
```

8. **FIND ALL TRANSACTIONS WHERE THE TOTAL_SALE > 1000 **:
```sql
SELECT *
FROM RETAIL_ANALYSIS
WHERE total_sale>1000;
```

9. **FIND TOTAL NUMBER OF TRANSACTIONS(TRANSACTION_ID) MADE BY EACH GENDER IN EACH CATEGORY**:
```sql
SELECT gender,category,COUNT(*) as TOTAL_TRANS
FROM RETAIL_ANALYSIS
GROUP BY category,gender
ORDER BY 1;
```

10. **CALCULATE THE AVG SALE FOR EACH MONTH AND FIND OUT THE BEST SELLING MONTH IN EACH YEAR -- USE EXTRACT FRUNCTION TO GET YEAR , MONTH  & WINDOW FUNCTION FOR RANKING**:
```sql
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
```
11. **FIND THE TOP 5 CUSTOMERS BASED ONN THE HIGHEST TOTAL SALE**
```sql
SELECT customer_id,SUM(total_sale) as total_sale
FROM RETAIL_ANALYSIS
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```
12. **FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEM FOR EACH CATEGORY**
```sql
SELECT category,COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER
FROM RETAIL_ANALYSIS
GROUP BY category;
```
13. **CREATE EACH SHIFT AND NUMBER OF ORDERS(EXAMPLE MORNING <=12,AFTERNOON BETWEEN 12& 17,EVENING >17) -- USE CASE STATEMENT and CTE(COMMON TABLE EXPRESSION)**
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.



