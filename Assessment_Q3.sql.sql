-- Q3: Account Inactivity Alert
-- Objective: Find active savings and investment accounts with no transactions in the last 365 days.


WITH savings_last_inflow AS (
    SELECT 
		plan_id,
        owner_id,
        'Savings' AS type,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE transaction_status = 'successful' AND confirmed_amount > 0
    GROUP BY plan_id, owner_id
),
investment_last_inflow AS (
    SELECT 
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(last_charge_date) AS last_transaction_date
    FROM plans_plan
    WHERE amount > 0
    GROUP BY id, owner_id
),
combined_last_inflows AS (
    SELECT * FROM savings_last_inflow
    UNION ALL
    SELECT * FROM investment_last_inflow
)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactivity_days
FROM combined_last_inflows
WHERE DATEDIFF(CURRENT_DATE, last_transaction_date) > 365
ORDER BY inactivity_days DESC;
