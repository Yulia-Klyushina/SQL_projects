-- Food Delivery App Data Analysis
-- Zomato is one of the most used food ordering platforms. 
-- This project aims on cleaning the dataset, analyze the given dataset, 
-- and mining informational quality insights.


-- DROP DATABASE IF EXISTS db_zomato;
-- create database db_zomato;

-- For a high-level overview of the hotels, 
-- provide us the top 5 most voted hotels in the delivery category.
select name, votes, rating from db_zomato.zomatocleaned1 where type = 'Delivery'
order by votes desc limit 5;

-- The rating of a hotel is a key identifier in determining a restaurant’s performance. 
-- Hence for a particular location called Banashankari 
-- find out the top 5 highly rated hotels in the delivery category.
select name, rating, location, type from db_zomato.zomatocleaned1 
where location = 'Banashankari' and type = 'Delivery'
order by rating desc limit 5;

-- compare the ratings of the cheapest and most expensive hotels in Indiranagar.
with
tempmin as (SELECT rating as rating1, 
                CAST(REPLACE(approx_cost, ',', '') AS UNSIGNED) as approx_cost1 
            FROM db_zomato.zomatocleaned1 order by approx_cost limit 1),
tempmax as (SELECT rating as rating2, 
                CAST(REPLACE(approx_cost, ',', '') AS UNSIGNED) as approx_cost2 
            FROM db_zomato.zomatocleaned1 order by approx_cost DESC limit 1)
select rating1,rating2 from tempmin, tempmax;

-- Online ordering of food has exponentially increased over time. 
-- Compare the total votes of restaurants that provide online ordering services 
-- and those who don’t provide online ordering service.
select sum(votes) as total_votes, online_order from db_zomato.zomatocleaned1
group by online_order;

-- Number of votes defines how much the customers are involved with the service provided by the restaurants For each Restaurant type, find out the number of restaurants, total votes, and average rating. 
-- Display the data with the highest votes on the top
-- ( if the first row of output is NA display the remaining rows).
select type, count(name) as number_of_restaurants,sum(votes) as total_votes, avg(rating) avg_rating from db_zomato.zomatocleaned1
where type <> 'NA'
group by type
order by total_votes desc;

-- What is the most liked dish of the most-voted restaurant on Zomato
-- (as the restaurant has a tie-up with Zomato, 
-- the restaurant compulsorily provides online ordering and delivery facilities).
select name, dish_liked, max(rating) as max_rating, max(votes) as max_votes
from db_zomato.zomatocleaned1
group by name, dish_liked
order by max_rating desc, max_votes desc
limit 1;

-- To increase the maximum profit, Zomato is in need to expand its business. 
-- For doing so Zomato wants the list of the top 15 restaurants 
-- which have min 150 votes, have a rating greater than 3, 
-- and is currently not providing online ordering. 
-- Display the restaurants with highest votes on the top.
select name, votes, rating, online_order from db_zomato.zomatocleaned1
where votes >= 150 and rating > 3 and online_order ='No'
order by votes desc limit 15;
