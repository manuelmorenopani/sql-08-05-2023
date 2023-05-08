--distinct

-- Se quiere saber a qué paises se les vende usar la tabla de clientes
select distinct country
from public.customers;
-- Se quiere saber a qué ciudades se les vende usar la tabla de clientes
select distinct city
from public.customers;
-- Se quiere saber a qué ciudades se les ha enviado una orden
select distinct ship_city
from public.orders;
--Se quiere saber a qué ciudades se les vende en el pais USA usar la tabla de clientes
select distinct city
from public.customers
where country = 'USA';
--Agrupacion

-- Se quiere saber a qué paises se les vende usar la tabla de clientes nota hacerla usando group by
select country from public.customers group by country;
--Cuantos clientes hay por pais
select country, count(*) as numeroclientess 
from public.customers
group by country;
--Cuantos clientes hay por ciudad en el pais USA
select city, count(*) as numcliente
from customers
where country='USA'
group by city;
--Cuantos productos hay por proveedor de la categoria 1
select supplier_id, count (*) as numeroproductos
from public.products
where category_id=1
group by supplier_id;
--Filtro con having

-- Cuales son los proveedores que nos surten más de 1 producto, mostrar el proveedor mostrar la cantidad de productos
select supplier_id, count(*) as numeroproductos
from products
group by supplier_id
having count(*)>1;
-- Cuales son los proveedores que nos surten más de 1 producto, mostrar el proveedor mostrar la cantidad de productos, pero únicamente de la categoria 1
select supplier_id, count(*) as numeroproductos
from products
where category_id = 1
group by supplier_id
having count(*)>1;
--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES USA, CANADA, SPAIN (ShipCountry) MOSTRAR UNICAMENTE LOS EMPLEADOS CUYO CONTADOR DE ORDENES SEA MAYOR A 20
select employee_id, count(*) as num
from public.orders
where ship_country in ('USA', 'CANADA', 'SPAIN')
group by employee_id
having count(*)> 20;
--OBTENER EL PRECIO PROMEDIO DE LOS PRODUCTOS POR PROVEEDOR UNICAMENTE DE AQUELLOS CUYO PROMEDIO SEA MAYOR A 20
select product_id, avg(unit_price) as promedio
from public.products
group by product_id
HAVING avg(unit_price) > 20;
--OBTENER LA SUMA DE LAS UNIDADES EN EXISTENCIA (UnitsInStock) POR CATEGORIA, Y TOMANDO EN CUENTA UNICAMENTE LOS PRODUCTOS CUYO PROVEEDOR (SupplierID) SEA IGUAL A 17, 19, 16 DICIONALMENTE CUYA SUMA POR CATEGORIA SEA MAYOR A 300--
select category_id, sum(units_in_stock) as sumaunidades
from public.products
where supplier_id in (16,17,19)
group by category_id
having sum (units_in_stock) > 300;
--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES (ShipCountry) SA, CANADA, SPAIN cuYO CONTADOR SEA MAYOR A 25
select employee_id , count(order_id) as orders_quantity 
from public.orders
where ship_country in ('USA', 'Canada', 'Spain') 
group by employee_id
having count(order_id) > 25;
----OBTENER LAS VENTAS (Quantity * UnitPrice) AGRUPADAS POR PRODUCTO (Orders details) Y CUYA SUMA DE VENTAS SEA MAYOR A 50.000
select order_id, sum(quantity * unit_price)as ventas
from public.order_details
group by order_id 
having sum(quantity*unit_price)>50000;


--Mas de una tabla 

--OBTENER EL NUMERO DE ORDEN, EL ID EMPLEADO, NOMBRE Y APELLIDO DE LAS TABLAS DE ORDENES Y EMPLEADOS
select o.order_id, o.employee_id, e.first_name, e.last_name
from public.orders o
join public.employees e on o.employee_id=e.employee_id;
--OBTENER EL PRODUCTID, PRODUCTNAME, SUPPLIERID, COMPANYNAME DE LAS TABLAS DE PRODUCTOS Y PROVEEDORES (SUPPLIERS)
select pr.product_id, pr.product_name, pr.supplier_id, s.company_name
from public.products pr
join public.suppliers s on pr.supplier_id=s.supplier_id;
--OBTENER LOS DATOS DEL DETALLE DE ORDENES CON EL NOMBRE DEL PRODUCTO DE LAS TABLAS DE DETALLE DE ORDENES Y DE PRODUCTOS
select od.order_id, pr.product_id,od.unit_price, od.quantity, od.discount
from public.order_details od
join public.products pr on od.product_id=pr.product_id;
--OBTENER DE LAS ORDENES EL ID, SHIPPERID, NOMBRE DE LA COMPAÑÍA DE ENVIO (SHIPPERS)
select O.order_id, S.shipper_id, S.company_name 
from orders O 
inner join shippers S on O.ship_via = S.shipper_id;
--Obtener el número de orden, país de envío (shipCountry) y el nombre del empleado de la tabla ordenes y empleados Queremos que salga el Nombre y Apellido del Empleado en una sola columna.

--Combinando la mayoría de conceptos

--CONTAR EL NUMERO DE ORDENES POR EMPLEADO OBTENIENDO EL ID EMPLEADO Y EL NOMBRE COMPLETO DE LAS TABLAS DE ORDENES Y DE EMPLEADOS join y group by / columna calculada

--OBTENER LA SUMA DE LA CANTIDAD VENDIDA Y EL PRECIO PROMEDIO POR NOMBRE DE PRODUCTO DE LA TABLA DE ORDERS DETAILS Y PRODUCTS
select pr.product_name, sum(od.quantity) as total, avg (od.unit_price)
from public.order_details od
join public.products pr on od.product_id = pr.product_id
group by pr.product_name;
--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR CLIENTE DE LAS TABLAS ORDER DETAILS, ORDERS
select cu.customer_id, sum(od.quantity * od.unit_price)as ventas
from public.customers cu
join public.orders o on cu.customer_id=o.customer_id
join public.order_details od on o.order_id=od.order_id
group by cu.customer_id;
--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR EMPLEADO MOSTRANDO EL APELLIDO (LASTNAME)DE LAS TABLAS EMPLEADOS, ORDENES, DETALLE DE ORDENES
select e.last_name, sum(od.quantity * od.unit_price)as ventas
from public.employees e
join public.orders o on e.employee_id=o.employee_id
join public.order_details od on o.order_id=od.order_id
group by e.last_name;