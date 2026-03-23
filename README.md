# Walmart Sales Analysis Using Python And MySQL

## 📊 Project Overview
This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. I utilized Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. The project is ideal for data analysts looking to develop skills in data manipulation, SQL querying, and data pipeline creation.

---

## 🛠️ Tools & Technologies I Used

* **Visual Studio Code (VS Code)** – My primary IDE for writing code, managing files, and running queries.
* **Python** – Used for data cleaning, processing, and connecting with the database.
* **MySQL** – Used as the main database for storing, querying, and analyzing structured data.

---

## 🎯 Project Goal

In this project, I focused on creating a **clean, organized, and scalable development environment** inside VS Code.
My goal was to make sure that all components — Python, MySQL, and data files — work smoothly together.

I wanted to:

* Organize my project in a professional way
* Handle real-world datasets efficiently
* Perform data analysis using SQL and Python
* Build a strong foundation for future data projects

---

## 🧱 Project Structure

I followed a structured approach to keep everything clean and easy to manage:

```bash
project-root/
│
├── data/
│   ├── raw/              # Original dataset (unchanged)
│   └── processed/        # Cleaned data
│
├── notebooks/            # Jupyter notebooks for analysis
│
├── scripts/              # Python scripts
│
├── sql/                  # SQL queries and scripts
│
├── env/                  # Virtual environment
│
├── requirements.txt      # Dependencies
└── README.md
```

This structure helped me:

* Separate raw and processed data
* Keep SQL queries organized
* Write reusable Python scripts

---

## 🔌 MySQL Integration

I connected Python with MySQL using **SQLAlchemy + PyMySQL**.

This allowed me to:

* Run SQL queries directly from Python
* Load data into MySQL
* Perform analysis using both SQL and Python

---

## 🔄 Project Workflow

### 📥 1. Data Collection

* Downloaded dataset (Kaggle)

---

### 🧹 2. Data Cleaning

* Handled null values and duplicate values
* Converted data types 
* Fixed formatting issues

---

### 🗄️ 3. Data Storage (MySQL)

* Created database and tables
* Imported cleaned data into MySQL
* Verified row counts and structure

---

### 📊 4. Data Analysis

I performed various SQL operations like:

* Aggregations 
* Grouping
* Filtering
* Ranking using window functions
---
## 🛠️ Business Analysis

#### 1. Find different payment method and no. of transactions, no. of qty sold
```sql
SELECT 
	payment_method,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_quantity
FROM walmart
	GROUP BY payment_method;
```
#### 2. Identify the highest rated category in each branch, displaying the branch, category -- AVG RATING
```sql
SELECT *
FROM
( SELECT
	Branch,
	category,
    AVG(rating) AS rating,
    RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) AS Ranking
FROM walmart
	GROUP BY Branch, category
) t -- temporary table name (alias)
WHERE Ranking = 1;
```
#### 3. Identify the busiest day for each branch based on no. of transactions
```sql
SELECT * FROM
(
SELECT 
	Branch,
    DAYNAME((str_to_date(date,'%d/%m/%Y'))) AS day_name,
    COUNT(*) AS no_of_transactions,
    RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) as Ranking
    FROM walmart
GROUP BY 1,2
) t
WHERE Ranking = 1;
```
#### 4. Total no. of quantity sold per payment method. List payment method and total quantity
```sql
SELECT
	payment_method,
    SUM(quantity) AS no_of_quantity
FROM walmart
GROUP BY 1;
```
#### 5. Determine the average, minimum and maximum rating of category  for each city. List city, average_rating, min_rating and max_rating
```sql
SELECT 
	city,
    Category,
    AVG(rating) AS avg_rating,
	MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
    FROM walmart
GROUP BY 1,2; 
```
#### 6. Total Profit For Each Cetegory. List category and total_profit, ordered from highest to lowest
```sql
SELECT 
	category,
    SUM(total * profit_margin) AS profit_margin
FROM walmart
GROUP BY 1;
```
#### 7. Determine the most common payment method for each Branch. Display Branch and Preferred_payment_method
```sql
WITH cte -- Temporary Table
AS
(SELECT 
	Branch,
    payment_method,
    COUNT(*) AS total_transactions,
    RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS Ranking
FROM walmart
	GROUP BY 1, 2
)
SELECT * FROM cte 
	WHERE Ranking = 1;
```
#### 8. Categorize sales into 3 groups MORNING,AFTERNOON,EVENING by shift and no. of invoices
```sql
SELECT 
	CASE 
    WHEN HOUR(time) < 12 THEN 'Morning'
    WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS Shift,
	COUNT(*) AS no_of_orders
FROM walmart
GROUP BY Shift;
```
#### 9. Identify 5 branch with highest decrease ratio in revenue compare to last year
```sql
-- Revenue Decrease Ratio Logic == lastyear_rev-curryear_rev/lastyear_rev*100
WITH revenue_2022
AS (
SELECT 
    branch,
    SUM(total) AS revenue
FROM walmart
	WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022 -- Revenue 2022
GROUP BY branch
),
revenue_2023
AS (
SELECT 
    branch,
    SUM(total) AS revenue
FROM walmart
	WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023 -- Revenue 2023
GROUP BY branch
)
SELECT 
	ls.branch,
    ls.revenue as last_yr_revenue,
    cr.revenue as curr_yr_revenue,
ROUND(((ls.revenue - cr.revenue)/ls.revenue) *100,2) AS decreased_ratio -- Finding decreased revenue ratio
	FROM revenue_2022 as ls
JOIN
	revenue_2023 as cr
ON ls.branch = cr.branch
  WHERE ls.revenue > cr.revenue 
ORDER BY 4 DESC
  LIMIT 5;
```
---

## 🧠 Key Learnings

Through this project, I learned:

* How to properly **structure a real-world data project**
* Importance of **data cleaning and typecasting**
* How to debug common SQL errors
* How to integrate Python with databases

---

## ⭐ Final Thoughts

This project helped me move from **basic queries to real-world data analysis**.
I focused not just on writing code, but on **building a complete workflow** that can scale in the future.

---
