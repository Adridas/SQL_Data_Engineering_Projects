-- SELECT *
-- LIMIT 10
-- FROM job_postings_fact;

EXPLAIN ANALYZE
SELECT 

    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id)> 500
ORDER BY posting_count DESC
LIMIT 10;