-- Q2: Transaction Frequency Analysis
-- Objective: Categorize customers by average number of monthly transactions.


WITH customer_txn_summary AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        DATEDIFF(MAX(transaction_date), MIN(transaction_date)) / 30.0 AS active_months
    FROM savings_savingsaccount
    GROUP BY owner_id
),
categorized AS (
    SELECT
        owner_id,
        total_transactions,
        ROUND(total_transactions / NULLIF(active_months, 0), 2) AS transactions_per_month,
        CASE
            WHEN total_transactions / NULLIF(active_months, 0) >= 10 THEN 'High Frequency'
            WHEN total_transactions / NULLIF(active_months, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_txn_summary
)
SELECT 
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category;

