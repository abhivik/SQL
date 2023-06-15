/*MySQL Exercise 3: Formatting Selected Data*/

/*1. Use AS to change the titles of the columns in your output*/
/*Question 1: How would you change the title of the "start_time" 
field in the exam_answers table to "exam start time" in a query output? */
SELECT start_time AS "exam start time" 
FROM exam_answers;

/*2. Use DISTINCT to remove duplicate rows*/
/*Question 2: How would you list all the possible combinations of test names and 
subcategory names in complete_tests table? (If you do not limit your output, you 
should retrieve 45 possible combinations)*/
SELECT DISTINCT test_name, subcategory_name
FROM complete_tests;

/*3. Use ORDER BY to sort the output of your query*/
/*Question 3: Below, try executing a query that would sort the same output as described 
above by membership_type first in descending order, and state second in ascending order:*/
SELECT DISTINCT user_guid, state, membership_type
FROM users
WHERE country = 'US' AND state IS NOT NULL AND membership_type IS NOT NULL
ORDER BY membership_type DESC, state ASC;

/*4. Export your query results to a text file*/
breed_list = %sql SELECT DISTINCT breed FROM dogs ORDER BY breed;
breed_list.csv('breed_list.csv')

/*using AS, DISTINCT, and ORDER BY */
/*Question 4: How would you get a list of all the subcategories of Dognition tests, 
in alphabetical order, with no test listed more than once (if you do not limit your output, 
you should retrieve 16 rows)?*/
SELECT DISTINCT subcategory_name
FROM complete_tests
ORDER BY test_name ASC;

/*Question 5: How would you create a text file with a list of all the non-United States 
countries of Dognition customers with no country listed more than once?*/
non_US_countries= %sql SELECT DISTINCT country FROM users WHERE country != 'US';
non_US_countries.csv('non_US_countries')

/*Question 6: How would you find the User ID, Dog ID, and test name of the first 10 tests 
to ever be completed in the Dognition database?*/
SELECT user_guid, dog_guid, test_name, created_at
FROM complete_tests
ORDER BY created_at DESC
LIMIT 10;

/*Question 7: How would create a text file with a list of all the customers with yearly memberships 
who live in the state of North Carolina (USA) and joined Dognition after March 1, 2014, sorted so that 
the most recent member is at the top of the list?*/
customer_list = %sql %sql SELECT DISTINCT user_guid, state, country, created_at 
FROM users 
WHERE country='US' AND state='NC' AND membership_type >= 2 AND created_at>'2014-03-01' 
ORDER by created_at DESC;
customer_list.csv('customer_list.csv')

/* Question 8: output all of the distinct breed names in UPPER case. Create a query that would 
output a list of these names in upper case, sorted in alphabetical order.*/
SELECT DISTINCT(UPPER(breed)) AS dist_breed
FROM dogs
ORDER BY dist_breed ASC;

