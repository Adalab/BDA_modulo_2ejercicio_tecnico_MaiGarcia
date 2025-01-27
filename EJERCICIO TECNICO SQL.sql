-- EJERCICIO TECNICO MAI GARCIA-- 

USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title 
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title 
FROM film 
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM film 
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title, length
FROM film 
WHERE length > 120
ORDER BY length ASC;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.

SELECT * FROM actor;

SELECT CONCAT(first_name,' ', last_name) AS nombre_actor 
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT CONCAT(first_name,' ', last_name) AS nombre_actor 
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT CONCAT(first_name,' ', last_name) AS nombre_actor, actor_id
FROM actor
WHERE actor_id BETWEEN 10 AND 20
ORDER BY actor_id ASC;


-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".

SELECT title, rating
FROM film
WHERE rating NOT IN ('R', 'PG-13');


-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.


SELECT rating AS clasificacion, COUNT(film_id) AS cantidad_pelis
FROM film
GROUP BY rating;


-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.


SELECT * FROM customer;

SELECT * FROM rental;


SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS cantidad
FROM customer c
INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT c.customer_id, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS cantidad     -- la opcion en la que en el GROUP BY aparece todo lo que hay en SELECT, excepto la agregada.
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, nombre, apellido;


-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT *
FROM category;
SELECT *
FROM film_category;
SELECT *
FROM inventory;
SELECT *
FROM rental;

SELECT c.name AS categoria, COUNT(r.rental_id) AS cantidad
FROM rental r
INNER JOIN inventory i
ON i.inventory_id = r.inventory_id
INNER JOIN film_category f
ON i.film_id = f.film_id
INNER JOIN category c
ON f.category_id = c.category_id
GROUP BY categoria;


-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT * FROM film;

SELECT rating, AVG(length) AS duracion
FROM film
GROUP BY rating;


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT * FROM film;

SELECT * FROM actor;

SELECT * FROM film_actor;


SELECT a.first_name AS nombre, a.last_name AS apellido, f.title AS titulo
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'indian love';


-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title, description
FROM film 
WHERE description LIKE '%dog%' OR description LIKE '%cat%';


-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.´

SELECT * FROM actor;

SELECT * FROM film_actor;

SELECT a.actor_id, a.first_name AS nombre, a.last_name AS apellido
FROM actor a
LEFT JOIN film_actor f
ON a.actor_id = f.actor_id
WHERE f.actor_id IS NULL;
               -- No hay ninguno nulo porque todos aparecen en alguna pelicula.

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT * FROM film;

SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;


-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT * FROM film;

SELECT * FROM film_category;

SELECT * FROM category;

SELECT f.title AS titulo, c.name AS categoria
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'family';


-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT * FROM actor;

SELECT *FROM film_actor;

SELECT a.first_name AS nombre, a.last_name AS apellido, COUNT(f.film_id) AS numero_pelis
FROM actor a
INNER JOIN film_actor f
ON a.actor_id = f.actor_id
GROUP BY a.actor_id
HAVING numero_pelis > 10;


-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT * FROM film;

SELECT title AS titulo, rating AS clasificacion, length AS duracion
FROM film
WHERE rating = 'R' AND length >120;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT * FROM film;

SELECT * FROM film_category;

SELECT * FROM category;


SELECT c.name AS categoria, AVG(f.length) AS duracion_media
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id
INNER JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING duracion_media >120;


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT * FROM actor;

SELECT* FROM film_actor;

SELECT a.first_name AS nombre, a.last_name AS apellido, COUNT(film_id) AS cantidad_pelis
FROM actor a
INNER JOIN film_actor fa
ON  a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING cantidad_pelis >=5
ORDER BY cantidad_pelis ASC;


-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona 
       -- las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_final, fecha_inicial)
       
SELECT * FROM film;

SELECT * FROM rental;

SELECT * FROM inventory;
       
       
SELECT f.title AS titulo     
FROM film f
WHERE f.film_id IN (     -- la columna de WHERE y la de SELECT DE LA SUBCONSULTA son la misma columna pero de diferente tabla.
	SELECT i.film_id
    FROM inventory i
    INNER JOIN rental r
    ON i.inventory_id = r.inventory_id
    WHERE DATEDIFF(r.return_date, r.rental_date) >5
    );

              
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en 
        -- películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
        
SELECT * FROM actor;

SELECT * FROM film_actor;

SELECT* FROM film_category;

SELECT* FROM category;


SELECT a.first_name AS nombre, a.last_name AS apellido 
FROM actor a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc
    ON fa.film_id = fc.film_id
    INNER JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name = 'horror'
    );



-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.


SELECT * FROM film;

SELECT * FROM film_category;

SELECT * FROM category;



SELECT f.title AS titulo, f.length AS duracion
FROM film f
WHERE f.film_id IN (
	SELECT fc.film_id
    FROM film_category fc
    INNER JOIN category c
    ON fc.category_id = c.category_id
    WHERE c.name = 'comedy'
    ) AND f.length >180;



-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que 
              -- han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un alias diferente.
              

SELECT * FROM actor;

SELECT * FROM film_actor;


SELECT CONCAT(a1.first_name,' ', a1.last_name) AS nombre_apellido1, CONCAT(a2.first_name,' ', a2.last_name) AS nombre_apellido2, COUNT(f1.film_id) AS cantidad_pelis
FROM film_actor f1
JOIN  film_actor f2
ON f1.film_id = f2.film_id
INNER JOIN actor a1
ON f1.actor_id = a1.actor_id
INNER JOIN actor a2
ON f2.actor_id = a2.actor_id
WHERE a1.actor_id != a2.actor_id
GROUP BY nombre_apellido1, nombre_apellido2
HAVING cantidad_pelis > 0;








              
              
              