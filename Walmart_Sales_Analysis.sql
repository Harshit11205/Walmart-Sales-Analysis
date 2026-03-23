SELECT * FROM walmart;

-- Business Problems
-- 1. Find different payment method and no. of transactions, no. of qty sold?
SELECT 
	payment_method,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_quantity
FROM walmart
	GROUP BY payment_method;
    
-- 2. Identify the highest rated category in each branch, displaying the branch, category -- AVG RATING
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

-- 3. Identify the busiest day for each branch based on no. of transactions
-- Converting date to DD-MM-YYYY format
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

-- Total no. of quantity sold per payment method. List payment method and total quantity
SELECT
	payment_method,
    SUM(quantity) AS no_of_quantity
FROM walmart
GROUP BY 1;

-- Determine the average, minimum and maximum rating of category  for each city.
-- List city, average_rating, min_rating and max_rating
SELECT 
	city,
    Category,
    AVG(rating) AS avg_rating,
	MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
    FROM walmart
GROUP BY 1,2; -- Average Rating

-- Total Profit For Each Cetegory. List category and total_profit, ordered from highest to lowest
SELECT 
	category,
    SUM(total * profit_margin) AS profit_margin
FROM walmart
GROUP BY 1;

-- Determine the most common payment method for each Branch. Display Branch and Preferred_contact_method
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
    
-- Categorize sales into 3 groups MORNING,AFTERNOON,EVENING by shift and no. of invoices
SELECT 
	CASE 
    WHEN HOUR(time) < 12 THEN 'Morning'
    WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS Shift,
	COUNT(*) AS no_of_orders
FROM walmart
GROUP BY Shift;

-- Identify 5 branch with highest decrease ratio in revenue compare to last year
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
    ROUND(((ls.revenue - cr.revenue)/ls.revenue) *100,2) AS decreased_ratio -- Finding decreased revenue
	FROM revenue_2022 as ls
JOIN
	revenue_2023 as cr
ON ls.branch = cr.branch
WHERE ls.revenue > cr.revenue 
ORDER BY 4 DESC
LIMIT 5;

-- END OF PROJECT --