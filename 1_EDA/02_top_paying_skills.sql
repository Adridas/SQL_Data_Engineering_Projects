SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id 
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    -- AND jpf.job_location = 'Lithuania'
GROUP BY
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*
┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ terraform  │      184000.0 │         3248 │
│ golang     │      184000.0 │          912 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ bitbucket  │      155000.0 │          478 │
│ django     │      155000.0 │          265 │
│ crystal    │      154224.0 │          129 │
│ atlassian  │      151500.0 │          249 │
│ c          │      151500.0 │          444 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ node       │      150000.0 │          179 │
│ ruby       │      150000.0 │          736 │
│ airflow    │      150000.0 │         9996 │
│ css        │      150000.0 │          262 │
│ redis      │      149000.0 │          605 │
│ ansible    │      148798.0 │          475 │
│ vmware     │      148798.0 │          136 │
│ jupyter    │      147500.0 │          400 │
├────────────┴───────────────┴──────────────┤
│ 25 rows                         3 columns │
└───────────────────────────────────────────┘

*/
/*
**Salary landscape** — the range is surprisingly compressed ($147k–$210k), with most skills clustering around $150k. Rust is a true outlier at $210k, a full $26k above the next tier.

**The demand paradox** — the highest-paying skills are often the rarest in the job market. Rust ($210k) has only 232 postings, while airflow ($150k) dominates with 9,996 — 43× more jobs at a much lower salary.

**The sweet spot** — terraform and kubernetes offer the best career value: top-tier salaries ($184k and $150k) combined with massive demand (3,248 and 4,202 jobs). These are the most hireable high-paying skills.

**Niche premium skills** — rust, neo4j, zoom, and crystal command high salaries precisely because few people have them. High reward, but you're fishing in a smaller pond.

**The baseline cluster** — about half the skills (kubernetes, airflow, redis, ruby, typescript, etc.) have converged at ~$150k. These are the "table stakes" of modern tech — widely demanded but salary-saturated.

**Infrastructure dominates** — terraform, kubernetes, ansible, airflow represent devops/infra tooling and collectively account for the largest demand volume in the dataset, suggesting strong market momentum for cloud-native skills.
*/
/*
Here's what changes when you factor in learning difficulty:
Rust's premium collapses under scrutiny. $210k looks incredible until you account for 18 months of learning and a difficulty of 5/5 — the hardest skill in the dataset. The ROI score drops it well below the leaderboard top.
terraform is the standout winner. Difficulty 2/5, learnable in ~3 months, $184k salary, and 3,248 job openings. It sits firmly in the purple quadrant (high salary, low effort) on the bubble chart. For career investment, nothing comes close.
airflow earns its "best ROI" tag. At $150k it looks middle-of-pack on salary, but with 9,996 jobs and only moderate difficulty (2/5, ~3 months), the sheer volume of opportunity drives an exceptional ROI score — you'll find a job fast.
The effort traps to avoid: crystal, c, and kubernetes sit in the red zone — high difficulty with either low demand or a salary that doesn't compensate for the years of investment. crystal in particular is the worst deal: expert-level difficulty, 129 job postings, and a salary that trails many 2/5 difficulty tools.
The easy wins cluster: gdpr, graphql, fastapi, redis, ansible, and bitbucket all score 2/5 difficulty with learn times of 1–3 months, solid salaries, and reasonable demand. Ideal for rounding out a skillset quickly.
The ROI ranking tab gives the clearest career guidance — toggle to it to see the full ordered list.
*/
