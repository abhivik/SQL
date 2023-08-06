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