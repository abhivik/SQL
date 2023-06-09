/* A)	Marketing: The marketing team wants to launch some campaigns, 
and they need your help with the following*/ 

use ig_clone;

/*1.	Rewarding Most Loyal Users: People who have been using the platform for the longest time. 
Your Task: Find the 5 oldest users of the Instagram from the database provided */

SELECT id, username, created_at 
FROM users
ORDER BY created_at DESC
LIMIT 5;
 
/* 2.	Remind Inactive Users to Start Posting: By sending them promotional emails to post their 1st photo. 
Your Task: Find the users who have never posted a single photo on Instagram*/ 

SELECT u.username, p.created_dat
FROM users as u
LEFT JOIN  photos as p on u.id = p.user_id
WHERE created_dat IS NULL;

/*3.	Declaring Contest Winner: The team started a contest and the user who gets the most likes on a 
single photo will win the contest now they wish to declare the winner. 
Your Task: Identify the winner of the contest and provide their details to the team */

SELECT u.id, u.username, p.id AS photoid, p.image_url, COUNT(*) AS likecount
FROM photos AS p
JOIN likes as l ON l.photo_id = p.id
JOIN users as u ON p.user_id = u.id
GROUP BY p.id 
ORDER BY likecount DESC;

/*4.	Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach 
the most people on the platform. 
Your Task: Identify and suggest the top 5 most commonly used hashtags on the platform */

SELECT t.tag_name, COUNT(t.tag_name) AS tagcount 
FROM tags AS t
JOIN photo_tags AS pt ON t.id = pt.tag_id
GROUP BY t.id
ORDER BY tagcount DESC
LIMIT 5;

/*5.	Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs. 
Your Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign*/

SELECT DAYNAME(created_at) AS registeration_day, COUNT(created_at) AS daycount 
FROM users
GROUP BY registeration_day
ORDER BY daycount DESC;

/*B) Investor Metrics: Our investors want to know if Instagram is performing well and is not becoming 
redundant like Facebook, they want to assess the app on the following grounds 
1.	User Engagement: Are users still as active and post on Instagram or they are making fewer posts 
Your Task: Provide how many times does average user posts on Instagram. Also, provide the total number 
of photos on Instagram/total number of users*/ 

SELECT (SELECT COUNT(*) AS photocount FROM photos) / 
    (SELECT COUNT(*) AS usercount FROM users) AS average_posts;

/*2.	Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts 
Your Task: Provide data on users (bots) who have liked every single photo on the site (since any normal user 
would not be able to do this).*/

SELECT u.id, u.username, u.created_at, COUNT(*) AS like_count 
FROM users AS u
JOIN likes as l ON u.id = l.user_id
GROUP BY u.id
HAVING like_count = (SELECT COUNT(*) FROM photos);