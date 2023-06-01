
/*Number of jobs reviewed: 
 Calculate the number of jobs reviewed per hour per day for November 2020? */
select count(job_id)/(24*30) as number_of_jobs from casestudy_1 
where extract(month from ds) = 11 and extract(year from ds) = 2020;
 
 /*Throughput: Let’s say the above metric is called throughput. 
 Calculate 7 day rolling average of throughput? 
  For throughput, do you prefer daily metric or 7-day rolling and why?*/
select a.* , avg(no_jobs) over(rows between 7 preceding and current row) as rolling_avg from
(select ds,count(job_id) as no_jobs from casestudy_1 group by ds order by 1) a;

/*Percentage share of each language: Calculate the percentage
 share of each language in the last 30 days?*/
 select a.*, num/(select count(language) from casestudy_1)*100 as language_percentage from 
(select language, count(language)as num from casestudy_1 where ds < NOW()-30 group by 1 ) a; 

/*Duplicate rows: Let’s say you see some duplicate rows in the data. 
How will you display duplicates from the table?*/
select job_id, actor_id,count(*) as num from casestudy_1 group by 1,2 having num > 1;

/*User Engagement:  Calculate the weekly user engagement?*/
select event_name, week(occurred_at) as weeks, count(user_id), 
cast(min(occurred_at) as date )as weekstart, cast(max(occurred_at) as date )as weekend
 from mytable
group by 1,2
order by 2,1;


/*User Growth: Calculate the user growth for product?*/
select a.Months, a.num_users - a.prev_num as num_growth from
(select extract(month from created_at) as Months, count(user_id) as num_users, 
lag(count(user_id),1) over() as prev_num
  from table1
group by 1
order by 1)a;

/*Weekly Retention:  Calculate the weekly retention of users-sign up cohort?*/
Select first,
SUM(CASE WHEN week_num = 0 THEN 1 ELSE 0 END) AS week_0,
SUM(CASE WHEN week_num = 1 THEN 1 ELSE 0 END) AS week_1,
SUM(CASE WHEN week_num = 2 THEN 1 ELSE 0 END) AS week_2,
SUM(CASE WHEN week_num = 3 THEN 1 ELSE 0 END) AS week_3,
SUM(CASE WHEN week_num = 4 THEN 1 ELSE 0 END) AS week_4,
SUM(CASE WHEN week_num = 5 THEN 1 ELSE 0 END) AS week_5,
SUM(CASE WHEN week_num = 6 THEN 1 ELSE 0 END) AS week_6,
SUM(CASE WHEN week_num = 7 THEN 1 ELSE 0 END) AS week_7,
SUM(CASE WHEN week_num = 8 THEN 1 ELSE 0 END) AS week_8,
SUM(CASE WHEN week_num = 9 THEN 1 ELSE 0 END) AS week_9 
from   
(select m.user_id,m.login_week,n.first as first,
m.login_week - first as week_num from
(select user_id, extract(week from occurred_at) as login_week
from mytable
group by 1,2)m,
(select user_id, min(extract(week from occurred_at)) as first
from mytable
group by 1) n where
m.user_id = n.user_id)as with_week_number
group by first order by first;


/*Weekly Engagement: Calculate the weekly engagement per device?*/
select device, week(occurred_at) as weeks, count(user_id),
cast(min(occurred_at) as date )as weekstart, cast(max(occurred_at) as date )as weekend
 from mytable
group by 1,2
order by 2,1;

/*Email Engagement:  Calculate the email engagement metrics?*/
 select a.user_id, b.sent, a.seen, (a.seen/b.sent)*100 as engagment_percentage from
 (select user_id, count(action) as seen from email_events 
 where action = 'email_open' group by 1)a
 inner join
 (select user_id, count(action) as sent from email_events 
 where action = 'sent_weekly_digest' group by 1)b on a.user_id = b.user_id

