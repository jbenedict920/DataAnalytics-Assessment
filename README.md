# DataAnalytics-Assessment
This repository showcases solutions to an SQL assessment aimed at evaluating data analysis and query optimization abilities using practical banking-related datasets.

---

**Assessment Questions & Approaches**

**Q1: High-Value Customers with Multiple Products**
**Objective:**
Identify customers who have both at least one funded savings plan and one funded investment plan. Sort the results by their total deposit amounts (savings + investments).

**Approach:**

- Used savings_savingsaccount to count savings accounts and sum successful confirmed_amount.

- Used plans_plan to count investment plans and sum the amount field.

- Joined both datasets with users_customuser to get full customer details.

- Filtered only customers with at least one savings and one investment plan.

- Sorted by total deposits in descending order.

**Challenges:**
- Clarifying what "funded" meant required checking transaction status and positive amounts. Ensuring null values didn’t affect the sums or counts was handled with COALESCE.

---

**Q2: Transaction Frequency Analysis**
**Objective:**
- Calculate average monthly transactions per customer and group them into frequency categories:

- High Frequency (≥10/month)

- Medium Frequency (3–9/month)

- Low Frequency (≤2/month)

**Approach:**

- Calculated the active months for each customer using the difference between the max and min transaction dates.

- Computed transaction rate per month.

- Categorized customers based on transaction frequency.

- Aggregated counts and average transaction rates per category.

**Challenges:**
- Handling division by zero.
- Handling inconsistent transaction activity.
  
**Solution:** 
- Used 'DATEDIFF' to estimate active months and ensured no division by zero.
- Division by zero was resolved using NULLIF on the active months field. Rounding and clean aggregation ensured readability.
---

**Q3: Account Inactivity Alert**
**Objective:**
Identify accounts with no inflow transactions in the past 365 days across both savings and investment accounts.

**Approach:**

- Extracted last successful transaction date from both savings_savingsaccount and plans_plan.

- Used UNION ALL to combine the inflow records.

- Filtered results for those with inactivity greater than 365 days.

- Calculated inactivity days and presented them in descending order.

**Challenges:**
- Identifying "no activity" using transaction dates.

**Solution:**
- Used 'HAVING' clause to filter out plans inactive for 365+ days.


---

**Q4: Customer Lifetime Value (CLV) Estimation**
**Objective:**
Estimate CLV based on customer tenure and transaction volume using a simplified formula.

**Formula Used:**

CLV = (total_transactions / tenure_in_months) * 12 * avg_profit_per_transaction
where avg_profit_per_transaction = 0.1% of average transaction value

**Approach:**

- Calculated total transactions and total transaction value from savings_savingsaccount where status is 'success' or 'successful'.

- Computed tenure from date_joined.

- Used the given formula to estimate CLV.

- Ordered customers by estimated CLV in descending order.

**Challenges:**
- Some customers had no transactions or zero tenure; these edge cases were handled using conditional logic and COALESCE.
- CLV going null due to missing or filtered transactions.

**Solution:**
Fixed logic to account for both `'success'` and `'successful'` transaction statuses.

Notes
All SQL scripts are clean, commented, and optimized for readability and performance.

Only successful inflow transactions were considered for financial accuracy.

All values remain in their original units without conversion.
