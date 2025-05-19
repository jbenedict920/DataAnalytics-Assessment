-- Q1: High-Value Customers with Multiple Products
-- Objective: Find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.


WITH savings_data AS (
    SELECT 
        owner_id,
        COUNT(id) AS savings_count,
        SUM(CASE WHEN transaction_status = 'successful' THEN confirmed_amount ELSE 0 END) AS total_savings_amount
    FROM savings_savingsaccount
    GROUP BY owner_id
),
investment_data AS (
    SELECT 
        owner_id,
        COUNT(id) AS investment_count,
        SUM(amount) AS total_investment_amount
    FROM plans_plan
    GROUP BY owner_id
)
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    COALESCE(s.total_savings_amount, 0) + COALESCE(i.total_investment_amount, 0) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_data s ON u.id = s.owner_id
LEFT JOIN investment_data i ON u.id = i.owner_id
WHERE COALESCE(s.savings_count, 0) > 0 
  AND COALESCE(i.investment_count, 0) > 0
ORDER BY total_deposits DESC;
