WITH quarterly_age_group_summary AS (
    SELECT
        CASE
            WHEN ci.age IS NULL THEN 'Unknown'
            WHEN ci.age BETWEEN 0 AND 9 THEN '0-9'
            WHEN ci.age BETWEEN 10 AND 19 THEN '10-19'
            WHEN ci.age BETWEEN 20 AND 29 THEN '20-29'
            WHEN ci.age BETWEEN 30 AND 39 THEN '30-39'
            WHEN ci.age BETWEEN 40 AND 49 THEN '40-49'
            WHEN ci.age BETWEEN 50 AND 59 THEN '50-59'
            WHEN ci.age BETWEEN 60 AND 69 THEN '60-69'
            WHEN ci.age BETWEEN 70 AND 79 THEN '70-79'
            WHEN ci.age >= 80 THEN '80+'
        END AS age_group,
        DATE_TRUNC('quarter', ti.date_new) AS quarter,
        SUM(ti.sum_payment) AS total_amount,
        COUNT(ti.id_check) AS total_transactions
    FROM 
        transactions_info ti
    LEFT JOIN 
        customer_info ci ON ti.id_client = ci.id_client
    WHERE 
        ti.date_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY 
        age_group, quarter
)
SELECT
    age_group,
    quarter,
    AVG(total_amount) AS avg_amount_per_quarter,
    AVG(total_transactions) AS avg_transactions_per_quarter,
    ROUND(100.0 * SUM(total_amount) / (SELECT SUM(ti.sum_payment) FROM transactions_info ti WHERE ti.date_new BETWEEN '2015-06-01' AND '2016-06-01'), 2) AS percent_amount,
    ROUND(100.0 * SUM(total_transactions) / (SELECT COUNT(ti.id_check) FROM transactions_info ti WHERE ti.date_new BETWEEN '2015-06-01' AND '2016-06-01'), 2) AS percent_transactions
FROM 
    quarterly_age_group_summary
GROUP BY 
    age_group, quarter
ORDER BY 
    age_group, quarter;
