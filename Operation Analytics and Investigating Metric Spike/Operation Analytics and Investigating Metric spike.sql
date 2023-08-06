/*Case Study 1 (Job Data)

Below is the structure of the table with the definition of each column that you must work on:
ds	        job_id	actor_id	event	   language	 time_spent	org
2020-11-30	 21	      1001	    skip	    English	     15	     A
2020-11-30	 22	      1006	    transfer	Arabic	     25	     B
2020-11-29	 23	      1003	    decision	Persian	     20	     C
2020-11-28	 23	      1005	    transfer	Persian	     22	     D
2020-11-28	 25	      1002	    decision	Hindi	     11	     B
2020-11-27	 11	      1007	    decision	French	     104	 D
2020-11-26	 23	      1004	    skip	    Persian	     56	     A
2020-11-25	 20	      1003	    transfer	Italian	     45	     C


    Table-1: job_data
        job_id: unique identifier of jobs
        actor_id: unique identifier of actor
        event: decision/skip/transfer
        language: language of the content
        time_spent: time spent to review the job in seconds
        org: organization of the actor
        ds: date in the yyyy/mm/dd format. It is stored in the form of text and we use presto to run. 
        no need for date function*/
        
/*Throughput: It is the no. of events happening per second.
Your task: Let’s say the above metric is called throughput. Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7-day rolling and why?
Percentage share of each language: Share of each language for different contents.
Your task: Calculate the percentage share of each language in the last 30 days?
Duplicate rows: Rows that have the same value present in them.
Your task: Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?
*/

CREATE DATABASE holadb;
USE holadb;
CREATE TABLE job_data(
	job_id INT,
    actor_id INT,
    even_t VARCHAR(20),
    lan_guage VARCHAR(10),
    time_spent VARCHAR(5),
    org VARCHAR(20),
    ds DATETIME
);

INSERT INTO job_data VALUES (21, 1001, "skip", "English", 15, "A", "2020-11-30"),
	(22,1006, "transfer", "Arabic", 25, "A", "2020-11-30"),
    (23,1003, "decision", "Persian", 20, "C", "2020-11-29"),
    (23,1005, "transfer", "Persian", 22, "D", "2020-11-28"),
    (25,1002, "decision", "Hindi", 11, "B", "2020-11-28"),
    (11,1007, "decision", "French", 104, "D", "2020-11-27"),
    (23,1004, "skip", "Persian", 56, "A", "2020-11-26" ),
    (20,1003, "transfer", "Italian", 45, "C", "2020-11-25");
    
SELECT * FROM job_data;

/*Number of jobs reviewed: Amount of jobs reviewed over time.
Your task: Calculate the number of jobs reviewed per hour per day for November 2020?*/

SELECT DATE(ds) AS 'date', ROUND((COUNT(job_id)/(SUM(time_spent/60)))) AS job_viewed_per_hour_per_day
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-31'
GROUP BY ds;

/*Throughput: It is the no. of events happening per second.
Your task: Let’s say the above metric is called throughput. 
Calculate 7 day rolling average of throughput? For throughput, 
do you prefer daily metric or 7-day rolling and why?*/
SELECT date, job_viewed_hours_per_day, 
		AVG(job_viewed_hours_per_day) OVER (PARTITION BY date) AS rolling_average_throughput
FROM (SELECT DATE(ds) AS 'date', ROUND(COUNT(job_id)/SUM(time_spent/60)) AS job_viewed_hours_per_day
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-31'
GROUP BY ds) AS throughput;

/*Percentage share of each language: Share of each language for different contents.
Your task: Calculate the percentage share of each language in the last 30 days?*/
SELECT DATE(ds) AS date, lan_guage, SUM(time_spent) AS total_time_mins,
		COUNT(job_id) AS job_count, count(job_id)*100 / sum(count(*)) OVER() as percentage_share
FROM job_data
WHERE ds BETWEEN '2020-11-01' AND '2020-11-31'
GROUP BY lan_guage
ORDER BY ds;


/*Duplicate rows: Rows that have the same value present in them.
Your task: Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?*/
SELECT ds, job_id, actor_id, even_t, lan_guage, time_spent, org,
    CASE WHEN COUNT(*) > 1 THEN 'Duplicate' ELSE 'No Duplicate' END AS Duplicate
FROM job_data
GROUP BY ds, job_id, actor_id, even_t, lan_guage, time_spent, org;

##################################################################################################################

create database case_2;
use case_2;
/*Case Study 2 (Investigating metric spike)*/
/*A. User Engagement: To measure the activeness of a user. 
Measuring if the user finds quality in a product/service.
Your task: Calculate the weekly user engagement?*/
SELECT WEEK(occurred_at) AS week, COUNT(DISTINCT user_id) AS user_engagement
FROM events
GROUP BY week;


/*B. User Growth: Amount of users growing over time for a product.
Your task: Calculate the user growth for product?*/
SELECT DATE(created_at) AS date, COUNT(*) AS user_count,
       COUNT(*) - (SELECT COUNT(*)
                   FROM users AS prev
				   WHERE DATE(prev.created_at) < DATE(curr.created_at)) AS user_growth
FROM users AS curr
GROUP BY DATE(created_at)
ORDER BY DATE(created_at);

/*C. Weekly Retention: Users getting retained weekly after signing-up for a product.
Your task: Calculate the weekly retention of users-sign up cohort?*/

# Step 1: Identify the sign-up cohort for a specific week
SELECT WEEK(created_at) AS cohort_week, COUNT(DISTINCT user_id) AS cohort_size
FROM users
GROUP BY cohort_week
ORDER BY cohort_week;

# Step 2: Calculate the weekly retention for each subsequent week
SELECT cohort_week, retention_week, COUNT(DISTINCT user_id) AS retained_users,
	   COUNT(DISTINCT user_id) / (SELECT COUNT(DISTINCT user_id) FROM users WHERE WEEK(created_at) = cohort_week) * 100 AS retention_rate
FROM (SELECT WEEK(u.created_at) AS cohort_week, WEEK(e.occurred_at) AS retention_week, u.user_id
	 FROM users u
	 INNER JOIN events e ON u.user_id = e.user_id
	 WHERE e.occurred_at > u.created_at
	 GROUP BY cohort_week, retention_week, u.user_id
    ) AS retention_data
GROUP BY cohort_week, retention_week
ORDER BY cohort_week, retention_week;
    
/*D. Weekly Engagement: To measure the activeness of a user. 
Measuring if the user finds quality in a product/service weekly.
Your task: Calculate the weekly engagement per device?*/
SELECT YEARWEEK(occurred_at) AS week, device, COUNT(*) AS engagement_count
FROM events
GROUP BY YEARWEEK(occurred_at), device
ORDER BY week, device;

/*E. Email Engagement: Users engaging with the email service.
Your task: Calculate the email engagement metrics?*/
SELECT WEEK(occurred_at) AS week,
    COUNT(DISTINCT CASE WHEN action = 'email_open' THEN user_id END) AS unique_users_email_opened,
    COUNT(DISTINCT CASE WHEN action = 'email_clickthrough' THEN user_id END) AS unique_users_email_clicked,
    COUNT(DISTINCT CASE WHEN action = 'sent_weekly_digest' THEN user_id END) AS unique_sent_weekly_digest,
    COUNT(DISTINCT CASE WHEN action = 'sent_reengagement_email' THEN user_id END) AS unique_sent_reengagement_email
FROM email_events
GROUP BY week(occurred_at)
ORDER BY week(occurred_at);

