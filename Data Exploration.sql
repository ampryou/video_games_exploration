/*
Video Games Sales Data Exploration Project
*/

-- 1. looking at some of the top selling video games of all time

SELECT *
FROM video_games_exploration..game_sales
ORDER BY Total_Shipped DESC
LIMIT 10

-- 2. finding missing review scores

SELECT COUNT(*)
FROM games_sale.game_sales AS g
LEFT JOIN video_games_exploration..reviews AS r
USING (name)
WHERE r.critic_score IS NULL AND r.user_score IS NULL

--3. exploring years that video game critics loved

SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
ORDER BY avg_critic_score DESC
LIMIT 10

--4. finding out the number of games published in top years for critics

SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
HAVING COUNT(*) > 4
ORDER BY avg_critic_score DESC
LIMIT 10

--5. finding years that dropped off the critics' favorites list

SELECT year, avg_critic_score
FROM (SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
ORDER BY avg_critic_score DESC)
EXCEPT
SELECT year, avg_critic_score
FROM (SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
HAVING COUNT(*) > 4
ORDER BY avg_critic_score DESC)
ORDER BY avg_critic_score DESC

--6. finding years video game players loved

SELECT year, ROUND(AVG(user_score), 2) AS avg_user_score, COUNT(*) AS num_games
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
HAVING COUNT(*) > 4
ORDER BY avg_user_score DESC
LIMIT 10

--7. finding years that both players and critics loved

SELECT year
FROM (SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
HAVING COUNT(*) > 4
ORDER BY avg_critic_score DESC)
INTERSECT
SELECT year
FROM (SELECT year, ROUND(AVG(user_score), 2) AS avg_user_score, COUNT(*) AS num_games
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
HAVING COUNT(*) > 4
ORDER BY avg_user_score DESC)

--8. Sales in the best video game years

SELECT year, SUM(total_shipped) AS total_games_sold
FROM game_sales
WHERE year IN (SELECT year
FROM (SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
HAVING COUNT(*) > 4
ORDER BY avg_critic_score DESC)
INTERSECT
SELECT year
FROM (SELECT year, ROUND(AVG(user_score), 2) AS avg_user_score, COUNT(*) AS num_games
FROM games_sale.game_sales AS g
INNER JOIN games_sale.reviews AS r
USING (name)
GROUP BY year
HAVING COUNT(*) > 4
ORDER BY avg_user_score DESC))
GROUP BY year
ORDER BY total_games_sold DESC
