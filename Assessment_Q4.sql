-- Q4: Customer Lifetime Value (CLV) Estimation
-- Objective: Estimate CLV using tenure and successful transaction volume.


WITH user_txns AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_transaction_value
    FROM savings_savingsaccount s
    WHERE LOWER(s.transaction_status) IN ('success', 'successful')
      AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),
user_tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        DATEDIFF(CURRENT_DATE, u.date_joined) / 30 AS tenure_months
    FROM users_customuser u
),
clv_calc AS (
    SELECT 
        u.customer_id,
        u.name,
        u.tenure_months,
        COALESCE(t.total_transactions, 0) AS total_transactions,
        COALESCE(t.total_transaction_value, 0) AS total_transaction_value,
        CASE 
            WHEN u.tenure_months > 0 AND t.total_transactions > 0 THEN 
                ROUND((t.total_transactions / u.tenure_months) * 12 * (0.001 * t.total_transaction_value / t.total_transactions), 2)
            ELSE 0
        END AS estimated_clv
    FROM user_tenure u
    LEFT JOIN user_txns t ON u.customer_id = t.owner_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
