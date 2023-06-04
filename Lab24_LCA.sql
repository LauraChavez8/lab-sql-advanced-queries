USE sakila;

SELECT DISTINCT a1.actor_id, ac1.first_name, ac1.last_name, a2.actor_id, ac2.first_name, ac2.last_name
FROM sakila.film_actor a1
JOIN sakila.film_actor a2
JOIN sakila.actor ac1 ON a1.actor_id = ac1.actor_id
JOIN sakila.actor ac2 ON a2.actor_id = ac2.actor_id
WHERE a1.actor_id <> a2.actor_id
ORDER BY a1.actor_id;

CREATE TEMPORARY TABLE actor_film
SELECT actor_id, COUNT(film_id) AS Numfilm
FROM sakila.film_actor
GROUP BY actor_id;

CREATE TEMPORARY TABLE list_film
SELECT film_id, a.actor_id, Numfilm, 
RANK() OVER (PARTITION BY film_id ORDER BY Numfilm DESC) as 'RankT'
FROM sakila.film_actor f
JOIN actor_film a ON f.actor_id = a.actor_id
ORDER BY film_id, RankT;

SELECT title, first_name, last_name, Numfilm FROM list_film l
JOIN sakila.film f ON l.film_id = f.film_id
JOIN sakila.actor a ON l.actor_id = a.actor_id
WHERE RankT = 1;