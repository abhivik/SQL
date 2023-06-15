/*MySQL Exercise 7: Joining Tables with Inner Joins*/

/*Questions 1-4: How many unique dog_guids and user_guids are there in the reviews and dogs table independently?*/
SELECT COUNT(DISTINCT dog_guid)
FROM reviews;

SELECT COUNT(DISTINCT user_guid)
FROM reviews;

SELECT COUNT(DISTINCT dog_guid)
FROM dogs;

SELECT COUNT(DISTINCT user_guid)
FROM dogs;

/*Question 5: How would you extract the user_guid, dog_guid, breed, breed_type, and breed_group for 
all animals who completed the "Yawn Warm-up" game (you should get 20,845 rows if you join on dog_guid only)?*/
SELECT d.user_guid, d.dog_guid, d.breed, d.breed_type, d.breed_group, c.test_name
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid AND c.test_name = "Yawn Warm-up";

/*Question 6: How would you extract the user_guid, membership_type, and dog_guid of all the golden retrievers 
who completed at least 1 Dognition test (you should get 711 rows)?*/
SELECT DISTINCT(d.user_guid) AS userid, u.membership_type, d.dog_guid AS dogid, d.breed
FROM dogs d, complete_tests c, users u
WHERE d.dog_guid = c.dog_guid 
    AND d.user_guid = u.user_guid 
    AND d.breed = "golden retriever";

/*Question 7: How many unique Golden Retrievers who live in North Carolina are there in the Dognition 
database (you should get 30)?*/
SELECT u.state, d.breed, COUNT(DISTINCT d.dog_guid) AS dog_count
FROM users u, dogs d
WHERE d.user_guid = u.user_guid AND d.breed = "golden retriever"
GROUP BY u.state
HAVING u.state = "NC";

/*Question 8: How many unique customers within each membership type provided reviews (there should be 2900 
in the membership type with the greatest number of customers, and 15 in the membership type with the fewest 
number of customers if you do NOT include entries with NULL values in their ratings field)?*/
SELECT u.membership_type, COUNT(DISTINCT r.user_guid) AS user_count, r.rating
FROM users u, reviews r
WHERE u.user_guid = r.user_guid AND r.rating IS NOT NULL
GROUP BY u.membership_type;

/*Question 9: For which 3 dog breeds do we have the greatest amount of site_activity data, (as defined by non-NULL 
values in script_detail_id)(your answers should be "Mixed", "Labrador Retriever", and "Labrador Retriever-Golden 
Retriever Mix"?*/
SELECT d.breed, COUNT(s.script_detail_id) AS activity_count
FROM site_activities s, dogs d
WHERE s.dog_guid = d.dog_guid AND s.script_detail_id IS NOT NULL
GROUP BY d.breed
ORDER BY activity_count DESC
LIMIT 3;


