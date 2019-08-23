
-- Query 1
-- Count the total number of events. 
SELECT count(*) from github_events; 


-- Query 2
-- Find the total number of commits per hour. 
SELECT date_trunc('hour', created_at) AS hour, 
       sum((payload->>'distinct_size')::int) AS num_commits 
FROM   github_events 
WHERE  event_type = 'PushEvent' 
GROUP BY hour 
ORDER BY hour; 


-- Query 3
-- Join query. 
-- Find the top 10 users who created the most number of repositories. 
SELECT 	login, count(*) 
FROM  	github_events ge 
JOIN	github_users gu ON ge.user_id = gu.user_id 
WHERE   event_type = 'CreateEvent'
    AND payload @> '{"ref_type": "repository"}' 
GROUP BY login 
ORDER BY count(*) DESC 
LIMIT 10; 


-- Query 4
-- Insert user
INSERT INTO github_users (user_id, url)
    VALUES (1, 'newuser.com');

SELECT *
FROM github_users
WHERE user_id = 1;

--***********

-- Query 5
-- Find the number of commits to the postgres repo on master per hour. 

--SELECT count(*) from github_events_10x;

SELECT date_trunc('hour', created_at) AS hour, 
       sum((payload->>'distinct_size')::int) AS num_commits 
FROM   github_events_100x
WHERE  event_type = 'PushEvent' AND 
       repo @> '{"name":"postgres/postgres"}' AND 
       payload @> '{"ref":"refs/heads/master"}' 
GROUP BY hour 
ORDER BY hour; 


UPDATE github_events_100x
SET event_public = FALSE
WHERE user_id = 85


-- Cleanup
-- Delete new user
DELETE FROM github_users
WHERE user_id = 1;

UPDATE github_events_100x
SET event_public = TRUE
WHERE user_id = 85