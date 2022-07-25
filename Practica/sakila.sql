#Ejercicio 1. a. Películas Ordenadas por duración de mayor a menor.[Tittle,release_year].
select f.title, f.release_year from film f order by f.length desc;
#Ejercicio 1 b. Toda la información de los clientes ordenada por Nombre y apellido alfabéticamente. [ solo de la tabla customer]
select * from customer c order by c.last_name, c.last_name asc;
#Ejercicio 1 c. Apellidos de los actores ordenados por ID de actor de menor a mayor. [Actor_id,last_name]
select a.actor_id, a.last_name from actor a order by a.actor_id asc;
#Ejercicio 2. a. Actores Cuyos nombres Empiezan con la letra “w” [first_name].
select a.first_name from actor a where a.first_name like 'W%';
#Ejercicio 2 b. Actores cuyos nombres empiecen con la letra “A” y contengan en alguna parte la cadena “EL”. [first_name]
select a.first_name from actor a where a.first_name like 'A%' and a.first_name like '%EL%';
#Ejercicio 2 c. Actores cuyos Nombres contengan solo 5 letras. [first_name]
select a.first_name from actor a where a.first_name like '_____';
#Ejercicio 3. a. Nombres de las categorías existentes, ordenadas alfabéticamente al revés. solo debe aparecer 
#una vez el nombre de la categoría, es decir si hay 3 categorías el resultset debe contener 3 filas solamente. [name,category_id].
select c.name, c.category_id  from category c order by c.name desc;
#Ejercicio 3 b. Cantidad de Categorías que hay. [Cantidad] (La función count cuenta cuantas veces se repite un valor en la tabla)
select count(category_id) Cantidad from category c;
#Ejercicio 4. a. Nombre del cliente, teléfono y dirección en la que vive [First_name,address,phone]
select c.first_name, a.address, a.phone from customer c, address a where c.address_id = a.address_id;
#Ejercicio 4 b. Ciudades en las que viven los clientes cuyos países son Afghanistan y Argentina [Country,City] (Sacado de las resoluciones)
select co.country, ci.city from city ci, country co where ci.country_id = co.country_id and country in('ARGENTINA', 'AFGHANISTAN');
#Ejercicio 5 a. Nombre del Actor y películas en las que se encuentra, Ordenadas por actor Alfabéticamente [first_name,tittle]
select a.first_name, f.title from actor a, film f, film_actor fa where a.actor_id = fa.actor_id and fa.film_id = f.film_id order by a.first_name asc;
#Ejercicio 5 b. Miembros del staff que son manager, en alguna tienda. [first_name,active,store,address,address2]
select s.first_name, s.active, stor.store_id, a.address, a.address2 from address a, staff s, store stor 
where a.address_id = s.address_id and s.staff_id = stor.manager_staff_id;
#Ejercicio 6 Cantidad de Dinero recaudado por las ventas en el tercer trimestre del año 2005 (formato de fecha yyyy/mm/dd hh/mm/ss) [Monto] (between = "Entre")
select sum(p.amount) from payment p where year(p.payment_date) = '2005' and month(p.payment_date) between 8 and 12;
#Ejercicio 7. Películas que han sido alquiladas alguna vez [Title]
select f.title 
from film f inner join inventory i on f.film_id = i.film_id
	inner join rental r on r.inventory_id = i.inventory_id
group by f.film_id;
#Ejercicio 8: Clientes No Activos ordenados por Ciudad alfabéticamente [First_name,City]
select c.first_name, co.country 
from customer c inner join address a on c.address_id = a.address_id
	inner join city ci on ci.city_id = a.city_id
    inner join country co on co.country_id = ci.country_id
where c.active = 0 order by co.country;
#Ejercicio 9: Las 4 películas más alquiladas en orden Descendente. [Cantidad_de_alquileres,Title]
select count(f.film_id) Cantidad_de_alquileres, f.title 
from film f inner join inventory i on f.film_id = i.film_id
	inner join rental r on r.inventory_id = i.inventory_id
group by f.title order by Cantidad_de_alquileres desc limit 4;
#Ejercicio 10: Película que nunca ha sido alquilada [Film_id,Title] 
select f.film_id, f.title 
from film f 
where f.title not in 
	(select f.title
	from film f inner join inventory i on f.film_id = i.film_id
		inner join rental r on i.inventory_id = r.inventory_id
	group by f.title);
#Ejercicio 11: Cantidad de copias de cada película Por película Ordenadas en orden de cantidad de
#películas de mayor a menor. [Film_id,Cantidad]
select f.film_id, count(i.inventory_id) Cantidad 
from film f inner join inventory i on f.film_id = i.film_id
group by f.film_id order by Cantidad desc;
#Ejercicio 12: Películas que fueron devueltas Fuera de fecha.(Películas que han pagado
#recargo) .[Title, Rental_date, rental_duration, payment_date ,Return_date, amount,
#replacement_cost, inventori_id]
select f.title, r.rental_date, f.rental_duration, p.payment_date, r.return_date, p.amount, f.replacement_cost, i.inventory_id 
from film f inner join inventory i on f.film_id = i.film_id
	inner join rental r on i.inventory_id = r.inventory_id
    inner join payment p on r.rental_id = p.rental_id
where datediff(date_add(r.rental_date, interval f.rental_duration day), coalesce(r.return_date, now())) < 0;
-- Ejercicio 13: Cantidad de películas por categoría indicando su precio promedio. [Name,Promedio]
select c.name, count(f.film_id) Cantidad, avg(f.rental_rate) Precio_Promedio
from film f inner join film_category fc on f.film_id = fc.film_id
	inner join category c on fc.category_id = c.category_id
group by c.category_id;
-- Ejercicio 14: Lista de precios conteniendo 4 columnas: 1) precio del alquiler 2) precio del alquiler
-- + 10% del mismo por retraso de 1 DIA 2) precio del alquiler + 20% del mismo por
-- retraso de mas de 1 días . La lista debe estar ordenada por titulo y categoría
select f.title, c.name, f.rental_rate Alquiler, f.rental_rate*1.1 Alquiler_1Dia_Retraso, f.rental_rate*1.2 Alquiler_Retraso
from film f inner join film_category fc on f.film_id = fc.film_id
	inner join category c on fc.category_id = c.category_id
order by c.name, f.title;
-- Ejercicio 15: Países los cuales poseen clientes los cuales nunca han alquilado una película [country]
select co.country
from country co inner join city ci on co.country_id = ci.country_id
	inner join address a on ci.city_id = a.city_id 
    inner join customer c on a.address_id = c.address_id
where c.customer_id not in (
	select r.customer_id 
    from rental r);
-- Ejercicio 16: Paises en los cuales nunca se ha alquilado una película. [country]
select country
from country
where country_id not in (
	select co.country_id 
    from country co inner join city ci on co.country_id = ci.country_id
		inner join address a on ci.city_id = a.city_id
        inner join customer c on a.address_id = c.address_id
        inner join rental r on c.customer_id = r.customer_id);	
-- Ejercicio 17: Descripción de las películas con todos sus actores [First_name,Title,description]
select a.first_name, f.title, f.description 
from film f inner join film_actor fa on f.film_id = fa.film_id
	inner join actor a on fa.actor_id = a.actor_id;
-- Ejercicio 18: Películas cuyo precio de alquiler supere el promedio del costo de las películas para mayores de 13 años. [Title,Rental_Rate]
select f.title, f.rental_rate 
from film f
where(
	select avg(f.rental_rate) Promedio 
	from film f
    where f.rating = 'PG-13') < f.rental_rate;
-- Ejercicio 19. a: Cree una tabla que se llame películas_divertidas e inserte en ella todas las películas que como 
-- special_features (Características especiales) contengan Deleted Scenes (escenas borradas)
create table peliculas_divertidas select * from film where special_features = 'Deleted Scenes';
-- Ejercicio 19. b: Cree una tabla que se llame películas _ nuevas con los siguientes campos:
-- nombre: varchar(45)
-- precio: int
-- Tiempo_de_alquiler:int
create table paliculas_nuevas (nombre varchar(45) not null primary key, precio int, tiempo_de_alquiler int);
-- Ejercicio 20: Sume al film_id 1000, aumente el precio de alquiler de las mismas un 25% y agregue una día mas a la duración de alquiler
update film
set 
	rental_rate = rental_rate*1.25,
    rental_duration = rental_duration +1
where film_id = 1000;
-- Ejercicio 21: Elimine las películas cuyo rating sea ‘G’ ¿Se puede?, ¿Por qué?
delete from peliculas_nuevas where rating = 'G';
-- Ejercicio 22: 



















