use metric_spike;

select * from users;

select * from events;

select * from email_events;

/* query to calculate the weekly user engagement. */

    
select 
    extract(week from occurred_at) as week_no,
    count(distinct user_id) as weekly_active_users
from events group by week_no;

/* query to calculate the user growth for the product. */

select
    year,
    week_no,
    no_of_active_users,
    SUM(no_of_active_users) over (order by year, week_no) AS cum_active_users
FROM (
    SELECT
        year(activated_at) AS year,
        week(activated_at) AS week_no,
        count(distinct user_id) as no_of_active_users
    FROM users
    GROUP BY year, week_no
) subquery
ORDER BY year, week_no;

    
/* query to calculate the weekly retention of users based on their sign-up cohort. */

select
    distinct user_id,
    count(user_id) as user_count,
    sum(case when retention_week = 1 then 1 else 0 end) as per_week_retention
from (
    select
        signups.user_id,
        signups.signup_week,
        engagements.engagement_week,
        engagements.engagement_week - signups.signup_week as retention_week
    from (
        select distinct user_id, week(occurred_at) as signup_week 
        from events
        where event_type = 'signup_flow'
        and event_name = 'complete_signup'
    ) as signups
    left join (
        select distinct user_id, week(occurred_at) as engagement_week 
        from events
        where event_type = 'engagement'
    ) as engagements
    on signups.user_id = engagements.user_id
) as user_retention
group by user_id;




/* query to calculate the weekly engagement per device. */

select
    YEAR(occurred_at) as year_no,
    week(occurred_at) as week_no,
    device,
    count(distinct user_id) AS no_of_users
from events
where event_type = 'engagement'
group by  year_no, week_no, device
ORDER by year_no, week_no, device;

/* query to calculate the email engagement metrics. */

select 
    extract(week from ee.occurred_at) AS week_start,
    count(ee.action) AS email_events_count,
    sum(case when ee.action = 'email_open' then 1 else 0 end) as email_opened,
    sum(case when ee.action = 'email_clickthrough' then 1 else 0 end) as email_clickthrough
from 
    email_events ee
group by 
    week_start
order by 
    week_start;





