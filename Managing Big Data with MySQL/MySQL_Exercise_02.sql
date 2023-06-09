/*MySQL Exercise 2: Using WHERE to select specific data*/

/*Question 1: How would you select the Dog IDs for the dogs in the Dognition 
data set that were DNA tested (these should have a 1 in the dna_tested field of 
the dogs table)? Try it below (if you do not limit your output, your query should 
output data from 1433 dogs):*/
SELECT dog_guid, dna_tested
FROM dogs
WHERE dna_tested = 1
LIMIT 20;

/*Question 2: How would you query the User IDs of customers who bought annual subscriptions, 
indicated by a "2" in the membership_type field of the users table? (If you do not limit the 
output of this query, your output should contain 4919 rows.)*/
SELECT user_guid, membership_type 
FROM users
WHERE membership_type = 2
LIMIT 20;

/*Question 3: How would you query all the data from customers located in the state of 
North Carolina (abbreviated "NC") or New York (abbreviated "NY")? If you do not limit the
output of this query, your output should contain 1333 rows.*/
SELECT *
FROM users
WHERE state = "NC" or state = "NY"
LIMIT 50;

/*Question 4: Now that you have seen how datetime data can be used to impose criteria on the data 
you select, how would you select all the Dog IDs and time stamps of Dognition tests completed before 
October 15, 2015 (your output should have 193,246 rows)?*/
SELECT dog_guid, created_at
FROM complete_tests
WHERE created_at < '2015-10-15'
LIMIT 50;

/*Question 5: How would you select all the User IDs of customers who do not have null values in the 
State field of their demographic information (if you do not limit the output, you should get 17,985 
from this query -- there are a lot of null values in the state field!)?*/
SELECT user_guid, state
FROM users
WHERE state IS NOT NULL;

/*Practice writing your own SELECT and WHERE statements!*/
/*Question 6: How would you retrieve the Dog ID, subcategory_name, and test_name fields, in that order, 
of the first 10 reviews entered in the Reviews table to be submitted in 2014?*/
SELECT dog_guid, subcategory_name, test_name, created_at
FROM reviews
WHERE YEAR(created_at)='2014'
LIMIT 10;

/* Question 7: How would you select all of the User IDs of customers who have female dogs whose breed 
includes the word "terrier" somewhere in its name (if you don't limit your output, you should have 1771 
rows in your output)? */
SELECT user_guid, gender, breed
FROM dogs
WHERE gender = 'female' AND breed LIKE ('%terrier%');

/*Question 8: How would you select the Dog ID, test name, and subcategory associated with each completed test 
for the first 100 tests entered in October, 2014?*/
SELECT dog_guid, test_name, subcategory_name
FROM complete_tests
WHERE YEAR(created_at) = '2014' AND MONTH(created_at)='10'
LIMIT 100;

