/*
Question: What are the most optimal skills for data engineers-balancing both demand and salary ?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote DATA ENgineer positions width specified annual salaries.
-Why ?
    - This approach highlights skills that balance market deman and fnancial reword. It weights core skills appro
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demans_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000 , 2) AS optimal_score,
    -- median_salary * demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id 
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL 
    -- AND jpf.job_location = 'Lithuania'
GROUP BY
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY
    -- median_salary DESC
    optimal_score DESC
LIMIT 25;

/*
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demans_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │             5.3 │          0.97 │
│ python     │      135000.0 │         1133 │             7.0 │          0.95 │
│ sql        │      130000.0 │         1128 │             7.0 │          0.91 │
│ aws        │      137320.0 │          783 │             6.7 │          0.91 │
│ airflow    │      150000.0 │          386 │             6.0 │          0.89 │
│ spark      │      140000.0 │          503 │             6.2 │          0.87 │
│ kafka      │      145000.0 │          292 │             5.7 │          0.82 │
│ snowflake  │      135500.0 │          438 │             6.1 │          0.82 │
│ azure      │      128000.0 │          475 │             6.2 │          0.79 │
│ java       │      135000.0 │          303 │             5.7 │          0.77 │
│ scala      │      137290.0 │          247 │             5.5 │          0.76 │
│ kubernetes │      150500.0 │          147 │             5.0 │          0.75 │
│ git        │      140000.0 │          208 │             5.3 │          0.75 │
│ databricks │      132750.0 │          266 │             5.6 │          0.74 │
│ redshift   │      130000.0 │          274 │             5.6 │          0.73 │
│ gcp        │      136000.0 │          196 │             5.3 │          0.72 │
│ hadoop     │      135000.0 │          198 │             5.3 │          0.71 │
│ nosql      │      134415.0 │          193 │             5.3 │          0.71 │
│ pyspark    │      140000.0 │          152 │             5.0 │           0.7 │
│ docker     │      135000.0 │          144 │             5.0 │          0.67 │
│ mongodb    │      135750.0 │          136 │             4.9 │          0.67 │
│ r          │      134775.0 │          133 │             4.9 │          0.66 │
│ go         │      140000.0 │          113 │             4.7 │          0.66 │
│ github     │      135000.0 │          127 │             4.8 │          0.65 │
│ bigquery   │      135000.0 │          123 │             4.8 │          0.65 │
├────────────┴───────────────┴──────────────┴─────────────────┴───────────────┤
│ 25 rows                                                           5 columns │

The ln_demand_count column is the most important design decision. Raw demand ranges from 113 to 1,133 — a 10× spread. Taking the natural log compresses that to 4.7–7.0, a 1.5× spread. This is deliberate: without it, python and sql would dominate the score purely on volume and salary would barely matter.
optimal_score is salary-dominant at the extremes. The scatter1 chart shows a near-vertical cluster around $128–140k where salary barely separates skills — all scored 0.65–0.79. But terraform breaks free at $184k and jumps to 0.97 despite having the 3rd-lowest demand in the entire table (193 jobs). The formula is not truly balanced — high salary can override weak demand entirely.
python vs sql is a clean controlled experiment. They share identical ln_demand (7.0) and differ only by $5k in salary — producing exactly 0.04 score difference (0.95 vs 0.91). This lets you back-calculate that $1k salary ≈ 0.008 score points in this range.
The score floor at 0.65 is artificial. github, bigquery, go, and r all cluster between 0.65–0.67 with very similar salary and ln(demand). Any of these could interchange positions with minor data changes — treat them as statistically equivalent, not ranked.
*/
