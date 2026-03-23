# HEADING 1
## HEADING 2
### HEADING 3
Normal text  
**BOLD**  
*Italic Text*   
  `This is code`    
- Bullet 1
- BUllet 2

1. number 1
2. mumber 2

[Link Text](www.google.lt)   

![Project 1 Overview](../1_EDA\images\1_1_Project1_EDA.png) 


```sql
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
```
