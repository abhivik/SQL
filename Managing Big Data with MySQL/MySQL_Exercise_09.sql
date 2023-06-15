/*MySQL Exercise 9: Subqueries and Derived Tables*/

/*Question 1: How could you use a subquery to extract all the data from exam_answers that had test durations 
that were greater than the average duration for the "Yawn Warm-Up" game? Start by writing the query that gives 
you the average duration for the "Yawn Warm-Up" game by itself (and don't forget to exclude negative values; 
your average duration should be about 9934):*/
SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS avg_time
FROM exam_answers
WHERE test_name = "Yawn Warm-Up" AND TIMESTAMPDIFF(minute,start_time,end_time) > 0;

/*Question 2: Once you've verified that your subquery is written correctly on its own, incorporate it into a 
main query to extract all the data from exam_answers that had test durations that were greater than the average 
duration for the "Yawn Warm-Up" game (you will get 11059 rows):*/
SELECT *
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time) >
    (SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS avg_time
     FROM exam_answers
     WHERE test_name = "Yawn Warm-Up" AND TIMESTAMPDIFF(minute,start_time,end_time) > 0);
     
/*Question 3: Use an IN operator to determine how many entries in the exam_answers tables are from the "Puzzles", 
"Numerosity", or "Bark Game" tests. You should get a count of 163022.*/
SELECT COUNT(*)
FROM exam_answers
WHERE subcategory_name IN ( "Puzzles", "Numerosity", "Bark Game");

/*Question 4: Use a NOT IN operator to determine how many unique dogs in the dog table are NOT in the "Working", 
"Sporting", or "Herding" breeding groups. You should get an answer of 7961.*/
SELECT COUNT(DISTINCT dog_guid)
FROM dogs
WHERE breed_group NOT IN ("Working", "Sporting", "Herding");

/*Question 5: How could you determine the number of unique users in the users table who were NOT in the dogs 
table using a NOT EXISTS clause? You should get the 2226, the same result as you got in Question 10 of MySQL 
Exercise 8: Joining Tables with Outer Joins.*/
SELECT DISTINCT u.user_guid
FROM users u
WHERE NOT EXISTS (SELECT d.user_guid FROM dogs d WHERE u.user_guid = d.user_guid);

/*Question 6: Write a query using an IN clause and equijoin syntax that outputs the dog_guid, breed group, 
state of the owner, and zip of the owner for each distinct dog in the Working, Sporting, and Herding breed groups. 
(You should get 10,254 rows; the query will be a little slower than some of the others we have practiced)*/
SELECT DISTINCT(d.dog_guid), d.breed_group, u.state, u.zip
FROM dogs d, users u
WHERE breed_group IN ('Working', 'Sporting', 'Herding') AND d.user_guid = u.user_guid;

/*Question 7: Write the same query as in Question 6 using traditional join syntax.*/
SELECT DISTINCT(d.dog_guid), d.breed_group, u.state, u.zip
FROM dogs d JOIN users u ON d.user_guid = u.user_guid
WHERE d.breed_group IN ('Working', 'Sporting', 'Herding');

/**/