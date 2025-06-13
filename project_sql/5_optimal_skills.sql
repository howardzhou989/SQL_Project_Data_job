with skills_demand as(
    select 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count
    from job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE   job_title_short = 'Data Analyst'AND
            salary_year_avg IS NOT NULL and
            job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
),average_salary as (
    select 
        skills_job_dim.skill_id,
        round(AVG(salary_year_avg),0) AS avg_salary
    from job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE   job_title_short = 'Data Analyst'AND
            salary_year_avg IS NOT NULL and
            job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

select  
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
from
    skills_demand
inner join average_salary on skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count desc,
    avg_salary DESC
LIMIT 25;

