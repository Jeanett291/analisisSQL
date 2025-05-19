-- Ejercicio Practico SQL

/*Contexto : El restaurante "Sabores del Mundo", es conocido por su auténtica cocina 
y su ambiente acogedor.Este restaurante lanzó un nuevo menú a principios de año y ha 
estado recopilando información detallada sobre las transacciones de los clientes para 
identificar áreas de oportunidad y aprovechar al máximo sus datos para optimizar las ventas*/

/*Objetivo: Identificar cuáles son los productos del menú que han tenido más éxito y cuales 
son los que menos han gustado a los clientes*/
-- Pasos a seguir:

-- A) Crear la base de datos con el archivo create_restaurant_db.sql

CREATE TABLE order_details (
  order_details_id SMALLINT NOT NULL,
  order_id SMALLINT NOT NULL,
  order_date DATE,
  order_time TIME,
  item_id SMALLINT,
  PRIMARY KEY (order_details_id)
);

CREATE TABLE menu_items (
  menu_item_id SMALLINT NOT NULL,
  item_name VARCHAR(45),
  category VARCHAR(45),
  price DECIMAL(5,2),
  PRIMARY KEY (menu_item_id)
);


-- B) Explorar la tabla “menu_items” para conocer los productos del menú
Select * from menu_items limit 5


/*1.- Realizar consultas para contestar las siguientes preguntas:*/  
-- Encontrar el número de artículos en el menú: 
-- Respuesta: Son 32 el número de artículos
Select count (*) as numero_articulos 
from menu_items

-- ¿Cuál es el artículo menos caro y el más caro en el menú? 
-- Respuesta: El artículo de mayor precio es Shrimp Scampi 
-- con un precio de $19.95, El artículo de menor precio es Edamame 
-- con un precio de $5.00
Select item_name as articulo, price as precio
from menu_items 
order by 2 asc limit 1 

Select item_name as articulo, price as precio
from menu_items 
order by 2 desc limit 1 

-- ¿Cuántos platos americanos hay en el menú?
-- Respuesta: Son 6 platos americanos
Select count (category) as plato
from menu_items
where category = 'American'

-- ¿Cuál es el precio promedio de los platos?
-- Respuesta: El precio promedio de los platos es $13.29 
Select round(AVG(price),2) as precio_promedio
from menu_items

/*C) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
1.- Realizar consultas para contestar las siguientes preguntas:*/
Select * from order_details limit 10

-- ¿Cuántos pedidos únicos se realizaron en total?
-- Respuesta: Son 5,370 pedidos únicos
select count (distinct order_id) as pedidos_unicos
from order_details

-- ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
-- Respuesta: Son las ordenes con el ID; 440 con 14 articulos, 2675 con 
-- 14 articulos 3473 con 14 articulos, 4305 con 14 articulos y 443 con 
-- articulos. 

select order_id, count (*) as num_articulos 
from order_details
group by order_id
order by num_articulos desc
limit 5;


-- ¿Cuándo se realizó el primer pedido y el último pedido?
-- Respuesta: El primer pedido fue el 01/01/2023, el último pedido fue
-- 31/03/2023
select min(order_date) as primer_pedido,
max(order_date) as ultimo_pedido
from order_details

-- ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
-- Respuesta: Son 308 pedidos entre el 01/01/20203 a 05/01/2023
select count(distinct order_id)
from order_details
Where order_date between '2023-01-01' and '2023-01-05'


/*D) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.
1.- Realizar un left join entre entre order_details y menu_items con el identificador 
item_id(tabla order_details) y menu_item_id(tabla menu_items)*/
select * 
from order_details od
left join menu_items mi
on od.item_id = mi.menu_item_id
limit 10

/*E) Una vez que hayas explorado los datos en las tablas correspondientes y respondido 
las preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. 
El objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del 
restaurante en el lanzamiento de su nuevo menú. Para ello, crea tus propias consultas y 
utiliza los resultados obtenidos para llegar a estas conclusiones*/

-- 1. ¿Qué artículos del menú se venden más, pero que son mayores a 500 en ventas?
Select mi.item_name, count(*) as articulos_vendidos
from order_details od
join menu_items mi 
on od.item_id = mi.menu_item_id
group by mi.item_name
having count(*) >500
order by articulos_vendidos desc

-- 2. ¿Cuál es el ingreso que genera cada uno de los platillos?
Select mi.item_name, sum(mi.price) as ingresos
from order_details od
join menu_items mi
on od.item_id = mi.menu_item_id
group by mi.item_name
order by ingresos desc

-- 3. ¿Cuáles son los platillos menos vendidos?
select mi.item_name, count(od.item_id) as ventas
from order_details od
join menu_items mi
on od.item_id = mi.menu_item_id
group by mi.item_name
order by ventas asc

-- 4. ¿En qué horario se realizan más pedidos?
select date_part('hour',order_time) as hora,
count(distinct order_id) as pedidos
from order_details
group by hora
order by pedidos desc

-- 5. ¿Qué categoría del menú genera más ingresos?
select mi.category, sum(mi.price) as ingresos_totales
from order_details od
join menu_items mi
on od.item_id= mi.menu_item_id
group by mi.category
order by ingresos_totales desc

--- Consulta adicional, ¿qué categoría vendió más en que temporada?
SELECT 
  mi.category,
  od.order_date,
  COUNT(*) AS total_vendidos
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.category, od.order_date
ORDER BY mi.category, od.order_date DESC;

--CONCLUSIÓN--

/*El análisis de ventas del restaurante "Sabores del Mundo" muestra que, aunque 
la hamburguesa es el platillo con mayor volumen de venta, los ingresos más 
altos provienen de categorías como la Italiana y la Asiática, especialmente por 
el desempeño del Korean Beef Bowl, Spaghetti & Meatballs y Tofu Pad Thai. 
Estos platillos destacan no solo por su popularidad, sino también por su valor, 
lo que sugiere una oportunidad clara para impulsar estas categorías con estrategias 
promocionales específicas. 
Por otra parte, la comida Americana y Mexicana, muestran un menor rendimiento general 
y podrían beneficiarse al ser integradas en promociones cruzadas, tambien se identifican
algunos patrones de consumo por temporada, donde la preferencia por categorías cambia mes a mes; comida 
mexicana en enero, italiana en febrero, finalmente asiática y americana en marzo, esto permitiría 
adaptar la oferta según la época del año. 
Además, el mayor volumen de ventas se concentra entre las 12:00 y 19:00 horas, esto coincide 
con horarios laborales y escolares, representa una excelente ventana para reforzar menús especiales o combos 
durante esas horas. */

