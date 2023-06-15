/*MySQL Exercise 4: Summarizing your Data*/

/*1. The COUNT function*/
/*Question 1: Try combining this query with a WHERE clause to find how many individual 
dogs completed tests after March 1, 2014 (the answer should be 13,289): */
SELECT COUNT(DISTINCT dog_guid), created_at
FROM complete_tests
WHERE created_at > '2014-03-01';

/*Question 2: To observe the second difference yourself first, count the number of 
rows in the dogs table using COUNT(*):*/
SELECT COUNT(*)
FROM dogs;

/*Question 3: Now count the number of rows in the exclude column of the dogs table:*/
SELECT COUNT(exclude)
FROM dogs;

/*2. The SUM Function*/
/*Try counting the number of NULL values in the exclude column:*/
SELECT COUNT(ISNULL(exclude))
from dogs;

/*3. The AVG, MIN, and MAX Functions*/
/*Question 5: What is the average, minimum, and maximum ratings given to 
"Memory versus Pointing" game? (Your answer should be 3.5584, 0, and 9, respectively)*/
SELECT AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM reviews
WHERE test_name  = 'Memory versus Pointing';

/*Question 7: Include a column for Dog_Guid, start_time, and end_time in your query, and 
examine the output. Do you notice anything strange?*/
SELECT dog_guid, start_time, end_time, TIMESTAMPDIFF(minute,start_time,end_time) AS duration
FROM exam_answers
LIMIT 500;

/*Question 8: What is the average amount of time it took customers to complete all of the tests 
in the exam_answers table, if you do not exclude any data (the answer will be approximately 587 minutes)?*/
SELECT AVG(TIMESTAMPDIFF(minute,start_time, end_time)) AS avg_time
FROM exam_answers;

/*Question 9: What is the average amount of time it took customers to complete the "Treat Warm-Up" test, 
according to the exam_answers table (about 165 minutes, if no data is excluded)?*/
SELECT test_name, AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS duration
FROM exam_answers
WHERE test_name = 'Treat Warm-Up';

/*Question 10: How many possible test names are there in the exam_answers table?*/
SELECT COUNT(Distinct test_name)
FROM exam_answers;

/*Question 11: What is the minimum and maximum value in the Duration column of your query that 
included the data from the entire table?*/
SELECT MIN(TIMESTAMPDIFF(minute,start_time,end_time)) AS min_duration, 
	   MAX(TIMESTAMPDIFF(minute,start_time,end_time)) AS max_duration
FROM exam_answers;

/*Question 12: How many of these negative Duration entries are there? (the answer should be 620)*/
SELECT COUNT(TIMESTAMPDIFF(minute,start_time,end_time)) AS duration
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time) < '0';

/*Question 13: How would you query all the columns of all the rows that have negative durations so 
that you could examine whether they share any features that might give you clues about what caused 
the entry mistake?*/
SELECT *
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time) <0;

/*Question 14: What is the average amount of time it took customers to complete all of the tests in 
the exam_answers table when the negative durations are excluded from your calculation (you should get 11233 minutes)?*/
SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) As avg_duration
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time) > 0;
