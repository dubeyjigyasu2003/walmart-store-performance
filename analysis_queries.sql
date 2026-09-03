-- =====================================================================
-- Walmart Store Performance Analysis
-- Tables: store_info, walmart_sales (load from data/*.csv)
-- =====================================================================

CREATE TABLE store_info (
    store_id        VARCHAR(5) PRIMARY KEY,
    store_type      VARCHAR(30),
    region          VARCHAR(10),
    store_size_sqft INT
);

CREATE TABLE walmart_sales (
    store_id           VARCHAR(5),
    sale_date            DATE,
    weekly_sales         DECIMAL(10,2),
    markdown              DECIMAL(8,2),
    is_holiday            TINYINT,
    temperature_f         DECIMAL(5,1),
    fuel_price             DECIMAL(4,2),
    cpi                     DECIMAL(6,2),
    unemployment_rate      DECIMAL(4,2),
    FOREIGN KEY (store_id) REFERENCES store_info(store_id)
);

-- 1. Total revenue and average daily sales by store
SELECT
    s.store_id,
    si.store_type,
    si.region,
    ROUND(SUM(s.weekly_sales), 2) AS total_sales,
    ROUND(AVG(s.weekly_sales), 2) AS avg_daily_sales
FROM walmart_sales s
JOIN store_info si ON s.store_id = si.store_id
GROUP BY s.store_id, si.store_type, si.region
ORDER BY total_sales DESC;

-- 2. Store ranking by sales volume and margin proxy (window function)
SELECT
    store_id,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM (
    SELECT store_id, SUM(weekly_sales) AS total_sales
    FROM walmart_sales
    GROUP BY store_id
) t
ORDER BY sales_rank;

-- 3. Seasonal demand pattern — average sales by month
SELECT
    MONTH(sale_date) AS month_num,
    ROUND(AVG(weekly_sales), 2) AS avg_sales
FROM walmart_sales
GROUP BY month_num
ORDER BY month_num;

-- 4. Holiday vs non-holiday sales lift
SELECT
    is_holiday,
    ROUND(AVG(weekly_sales), 2) AS avg_sales,
    COUNT(*) AS days
FROM walmart_sales
GROUP BY is_holiday;

-- 5. Regional performance comparison
SELECT
    si.region,
    ROUND(SUM(s.weekly_sales), 2) AS total_sales,
    ROUND(AVG(s.weekly_sales), 2) AS avg_sales,
    COUNT(DISTINCT s.store_id) AS store_count
FROM walmart_sales s
JOIN store_info si ON s.store_id = si.store_id
GROUP BY si.region
ORDER BY total_sales DESC;

-- 6. Markdown effectiveness: sales on markdown days vs. non-markdown days
SELECT
    CASE WHEN markdown > 0 THEN 'Markdown Applied' ELSE 'No Markdown' END AS markdown_flag,
    ROUND(AVG(weekly_sales), 2) AS avg_sales
FROM walmart_sales
GROUP BY markdown_flag;

-- 7. Top-performing store per region (window function: ROW_NUMBER)
SELECT store_id, region, total_sales, region_rank
FROM (
    SELECT
        s.store_id,
        si.region,
        SUM(s.weekly_sales) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY si.region ORDER BY SUM(s.weekly_sales) DESC) AS region_rank
    FROM walmart_sales s
    JOIN store_info si ON s.store_id = si.store_id
    GROUP BY s.store_id, si.region
) ranked
WHERE region_rank = 1;

-- 8. Running (cumulative) sales trend by month
SELECT
    month,
    monthly_sales,
    SUM(monthly_sales) OVER (ORDER BY month) AS cumulative_sales
FROM (
    SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month, SUM(weekly_sales) AS monthly_sales
    FROM walmart_sales
    GROUP BY month
) t
ORDER BY month;

-- 9. Correlation check inputs: economic factors vs. average sales (for external analysis)
SELECT
    ROUND(unemployment_rate, 1) AS unemployment_bucket,
    ROUND(AVG(weekly_sales), 2) AS avg_sales
FROM walmart_sales
GROUP BY unemployment_bucket
ORDER BY unemployment_bucket;
