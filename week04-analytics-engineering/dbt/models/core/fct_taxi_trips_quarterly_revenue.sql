{{
    config(
        materialized='view'
    )
}}

WITH cte_detail AS
(
    SELECT service_type,
        period_year,
        period_year_quarter,
        period_quarter,
        SUM(total_amount) AS total_amount
    FROM {{ref("fact_trips")}}
    GROUP BY service_type,
        period_year,
        period_year_quarter,
        period_quarter
)
SELECT c1.service_type,
    c1.period_year,
    c1.period_quarter,
    c1.period_year_quarter,
    (c1.total_amount - c2.total_amount)/c1.total_amount * 100 AS rev_growth
FROM cte_detail AS c1
INNER JOIN cte_detail AS c2
ON CAST(c1.period_year AS integer) = CAST(c2.period_year AS integer) + 1
AND c1.period_quarter = c2.period_quarter
AND c1.service_type = c2.service_type
ORDER BY c1.service_type,
    c1.period_year,
    rev_growth DESC
