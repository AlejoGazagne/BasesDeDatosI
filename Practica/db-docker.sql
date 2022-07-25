#Ejercicio 1: Clientes inhabilitados, ordenados alfabéticamente [Cliente, Zona]
select c.Cliente, z.Zona from clientes c inner join zonas z on c.idZona = z.idZona where c.cuentaHabilitada = 0 order by c.Cliente;
#Ejercicio 2: Zonas cuyo nombre contenga el digito 9, ordenadas alfabéticamente descendente. [Zona]
select Zona from zonas where Zona like '%9%' order by Zona;
#Ejercicio 3: Clientes cuyo nombre termine con el digito 7. [Cliente, Zona]
select c.Cliente, z.Zona from clientes c inner join zonas z on c.idZona = z.idZona where c.cliente like '%7';
#Ejercicio 4: Productos en cuyo nombre se encuentre el digito 3, en cualquier parte. [Producto]
select Producto from productos p where p.Producto like '%3%';
#Ejercicio 5: Facturas anuladas en el año 2008, ordenadas por fecha [Nº de Factura, Fecha, Cliente, Zona, Vendedor]
select f.numero, f.fecha, c.Cliente, z.Zona, v.Vendedor
from facturacabecera f inner join clientes c on f.idCliente = c.idCliente
	inner join zonas z on c.idZona = z.idZona 
	inner join vendedores v on f.idVendedor = v.idVendedor
where year(f.fecha) = 2008 and f.anulada = 1
order by f.fecha, c.Cliente;
#Ejercicio 6: Los 4 Vendedores que tengan mayor comisión. [Vendedor, comisión]
#con limit podemos hacer 2,2. te paras en el primer valor y de ahi me mostras la cantidad de datos despues de la coma(me paro en 2 y te muestro los otros 2)
select v.Vendedor, v.Comision from vendedores v order by v.Comision desc limit 4;
#Ejercicio 7: Lista de precios conteniendo 4 columnas: 1) precio base, 2) precio base + 10%, 3) precio base + 30%, 4) precio base + 40%.
#La lista debe estar ordenada por rubro y producto. [Rubro, Producto, PrecioBase, PrecioMayorista, PrecioConDescuento, PrecioPublico]
select r.Rubro, p.Producto, p.precio PrecioBase, p.precio*1.1 PrecioMayorista, p.precio*1.3 PrecioConDescuento, p.precio*1.4 PrecioPublico
from rubros r inner join productos p on r.idRubro = p.idRubro order by r.Rubro, p.Producto;
#Ejercicio 8: Lista de los 8 Productos más caros, ordenados alfabéticamente [Producto, Proveedor, Rubro, Precio] 
select * from (select p.Producto, pr.Proveedor, r.Rubro, p.precio
from proveedores pr, productos p, rubros r
where p.idRubro = r.idRubro and p.idProveedor = pr.idProveedor order by p.precio desc limit 8) k order by k.Producto;
#Ejercicio 9: Lista de Productos de los Rubros 2,5,8,16 y 18 con un 15% de aumento, ordenados alfabéticamente [Producto, Proveedor, Rubro, Precio con un 15%]
select p.Producto, prov.Proveedor, r.Rubro, p.precio+(p.precio*.15) PrecioAumentado
from productos p, rubros r, proveedores prov
where p.idProveedor=prov.idProveedor and p.idRubro=r.idRubro and r.idRubro in(2, 5, 8, 16, 18) order by p.Producto asc;
#Ejercicio 10: Lista de los productos cuyo precio supere el promedio de precio de todos los productos. [Producto, Precio]
select p.Producto, p.precio from productos p where p.precio > (select avg(p.precio) from productos p);
#Ejercicio 11: Cantidad de clientes con la cuenta habilitada. [Cantidad]
select count(c.idCliente) Cantidad from clientes c where c.cuentaHabilitada = 1;
#Ejercicio 12: Proveedores que nunca proveyeron Productos, ordenados alfabéticamente [Proveedor]
select prov.Proveedor
from proveedores prov
where not exists(
    select prov.idProveedor
    from productos p
	where prov.idProveedor = p.idProducto);

select prov.proveedor
from proveedores prov
where prov.idProveedor not in (
    select prov.idProveedor
	from proveedores prov inner join productos p on prov.idProveedor = p.idProveedor);
#Ejercicio 13: Cantidad de Productos por Rubro y precio promedio, ordenados alfabéticamente [Rubro, Cantidad de Productos, Precio Promedio]
select r.Rubro, count(p.Producto), avg(p.precio) 
from rubros r inner join productos p on r.idRubro = p.idRubro 
group by r.idRubro order by r.Rubro;
#Ejercicio 14: Todas las Facturas emitidas en el 1er Trimestre año 2008, ordenadas alfabéticamente [Nº de Factura, Fecha, Cliente, Vendedor, Total]
select fc.numero, fc.fecha, c.Cliente, v.Vendedor, sum(p.precio*fd.cantidad)
from facturacabecera fc inner join clientes c on fc.idCliente = c.idCliente
	inner join facturadetalle fd on fc.idFactura = fd.idFactura
	inner join vendedores v on v.idVendedor = fc.idVendedor
	inner join productos p on p.idProducto = fd.idProducto
where year(fc.fecha) = 2008 and month(fc.fecha) <= 4 and fc.anulada = 0 
group by fc.idFactura order by c.Cliente;
#Ejercicio 15: Detalle de la Factura 12, ordenada por Producto [Nº de Factura, Fecha, Cliente, Vendedor, Rubro, Proveedor,
#Producto, Cantidad, Precio, Subtotal]
select fc.numero, fc.fecha, c.Cliente, v.Vendedor, r.Rubro, prov.Proveedor
from rubros r inner join productos p on p.idRubro = r.idRubro
    inner join proveedores prov on p.idProveedor = prov.idProveedor
	inner join facturadetalle fd on p.idProducto = fd.idProducto
	inner join facturacabecera fc on fc.idFactura = fd.idFactura
	inner join vendedores v on v.idVendedor = fc.idVendedor
	inner join clientes c on fc.idCliente = c.idCliente
where fc.numero = 12
order by p.Producto;
#Ejercicio 16: Importe Total facturado por Cliente hasta el 06/03/2014, ordenado por importe descendente [Cliente, Importe facturado]
select c.Cliente, sum(p.precio*fd.cantidad) importeFacturado
from clientes c inner join facturacabecera fc on c.idCliente = fc.idCliente
   			 inner join facturadetalle fd on fd.idFactura = fc.idFactura
   			 inner join productos p on p.idProducto = fd.idProducto
where fc.anulada = 0 and fc.fecha between '2007-01-01' and '2014-06-03' 
group by c.idCliente 
order by importeFacturado desc;
#Ejercicio 17: Los 3 productos más vendidos ordenados alfabéticamente [Rubro, Proveedor, Producto, Cantidad Vendida, Precio, Total]
select * from (
	select r.Rubro, prov.Proveedor, p.Producto, sum(fd.cantidad) CantidadVendida, p.precio, sum(p.precio*fd.cantidad) Total
	from rubros r inner join productos p on p.idRubro = r.idRubro
   	 inner join proveedores prov on prov.idProveedor = p.idProveedor
   	 inner join facturadetalle fd on fd.idProducto = p.idProducto
   	 inner join facturacabecera fc on fc.idFactura = fd.idFactura
	group by p.idProducto order by CantidadVendida desc limit 3) k
order by k.Producto;
#Ejercicio 18: Lista de los productos cuyo precio supere el 90% del producto mas caro, ordenado descendente por precio. [Producto, Precio]
select p.Producto, p.precio 
from productos p 
where p.precio > (select max(p.precio) from productos p)*0.9 
order by p.precio desc;
#Ejercicio 19: Nombre del Vendedor que más a vendido [Vendedor, Importe vendido]
select v.Vendedor, sum(p.precio*fd.cantidad) importeVendido
from vendedores v inner join facturacabecera fc on v.idVendedor = fc.idVendedor
    inner join facturadetalle fd on fc.idFactura = fd.idFactura
	inner join productos p on p.idProducto = fd.idProducto
group by v.idVendedor order by importeVendido desc limit 1;
#Ejercicio 20: Productos que no ha vendido nunca el Vendedor 5, ordenados alfabéticamente [Rubro, Proveedor, Producto, Precio]
select r.Rubro, prov.Proveedor, p.Producto, p.precio
from rubros r inner join productos p on r.idRubro = p.idRubro
    inner join proveedores prov on p.idProveedor = prov.idProveedor
where not exists(
    select p.idProducto
	from vendedores v inner join facturacabecera fc on v.idVendedor = fc.idVendedor
   	 inner join facturadetalle fd on fd.idFactura = fc.idFactura
    where v.idVendedor = 5 and p.idProducto = fd.idProducto)
order by p.Producto;

select r.Rubro, prov.Proveedor, p.Producto, p.precio
from rubros r inner join productos p on r.idRubro = p.idRubro
    inner join proveedores prov on prov.idProveedor = p.idProveedor
where p.idProducto not in(
    select p.idProducto 
    from productos p inner join facturadetalle fd on p.idProducto = fd.idProducto
		inner join facturacabecera fc on fc.idFactura = fd.idFactura
		inner join vendedores v on v.idVendedor = fc.idVendedor
	where v.idVendedor = 5)
order by p.Producto asc;
#Ejercicio 21: Importe a pagar por Vendedor en concepto de comisión por el mes de julio/2008, ordenados por Vendedor [Vendedor, Importe]
select v.Vendedor, sum(fd.cantidad*p.precio)*v.Comision Importe
from vendedores v inner join facturacabecera fc on v.idVendedor = fc.idVendedor
    inner join facturadetalle fd on fd.idFactura = fc.idFactura
    inner join productos p on p.idProducto = fd.idProducto
where year(fc.fecha) = 2008 and month(fc.fecha) = 07
group by v.idVendedor order by v.Vendedor;
#Ejercicio 22: Zonas en las que nunca se vendió, ordenadas alfabéticamente [Zona]
select *
from zonas
where not exists
    (select z.idZona
	from zonas z inner join clientes c on z.idZona = c.idZona
   	 inner join facturacabecera fc on fc.idCliente = c.idCliente)
order by Zona;

select z.Zona
from zonas z
where z.idZona not in(
    select z.idZona
	from zonas z inner join clientes c on z.idZona = c.idZona
   	 inner join facturacabecera fc on fc.idCliente = c.idCliente)
order by z.Zona;
#Ejercicio 23: Cliente al que más cantidad de productos se le ha facturado. [Cliente, Zona, Cantidad]
select c.Cliente, z.Zona, sum(fd.cantidad) Cantidad
from clientes c inner join zonas z on c.idZona = z.idZona
    inner join facturacabecera fc on fc.idCliente = c.idCliente
	inner join facturadetalle fd on fd.idFactura = fc.idFactura
where fc.anulada = 0 
group by c.idCliente 
order by Cantidad desc limit 1;
#Ejercicio 24: Proveedor del cual se han vendido más Productos. [Proveedor, Cantidad]
select prov.Proveedor, sum(fd.cantidad) Cantidad
from proveedores prov inner join productos p on p.idProveedor = prov.idProveedor
    inner join facturadetalle fd on fd.idProducto = p.idProducto
group by prov.idProveedor order by Cantidad desc limit 1;
#Ejercicio 25: Promedio de totales por Factura del año 2008. [Promedio] – No es el promedio por time facturado sino por Factura
select avg(k.Total) Promedio
from (
    select sum(p.precio*fd.cantidad) Total
    from productos p
   	 inner join facturadetalle fd on p.idProducto = fd.idProducto
   	 inner join facturacabecera fc on fc.idFactura = fd.idFactura
    where year(fc.fecha) = 2008 and fc.anulada = 0 group by fc.idFactura) k;
#Ejercicio 26: Importe facturado por mes del año 2008, ordenado por mes. [Mes/Año, Importe] – Mes/Año en formato Enero/2001 por Ej.
select case a.mes
    when 1 then 'Enero'
    when 2 then 'Febrero'
    when 3 then 'Marzo'
    when 4 then 'Abril'
    when 5 then 'Mayo'
    when 6 then 'Junio'
    when 7 then 'Julio'
    when 8 then 'Agosto'
    when 9 then 'Septiemrbe'
    when 10 then 'Octubre'
    when 11 then 'Noviembre'
    when 12 then 'Diciembre'
    end as mes, a.Importe from (
select month(fc.fecha) mes, sum(p.precio*fd.cantidad) Importe
from facturacabecera fc inner join facturadetalle fd on fc.idFactura = fd.idFactura
    inner join productos p on fd.idProducto = p.idProducto
where fc.anulada = 0 and year(fc.fecha) = 2008 group by month(fc.fecha) order by month(fc.fecha)) a;
#Ejercicio 27: Importe total por año de facturas anuladas, ordenado por año. [Año, Importe]
select year(fc.fecha) Anio, sum(p.precio*fd.cantidad) Importe
from facturacabecera fc inner join facturadetalle fd on fc.idFactura = fd.idFactura
    inner join productos p on p.idProducto = fd.idProducto
where fc.anulada = 1 group by year(fc.fecha) order by year(fc.fecha);
#Ejercicio 28: Productos que nunca se vendieron en la Zona 4, ordenados por Rubro, Proveedor, Producto. [Rubro, Proveedor, Producto, Precio]
select * from(
    select r.Rubro, prov.Proveedor, p.Producto, p.precio
    from rubros r inner join productos p on r.idRubro = p.idRubro
   	 inner join proveedores prov on p.idProveedor = prov.idProveedor
    where not exists(
   	 select p.idProducto
   	 from zonas z inner join clientes c on z.idZona = c.idZona
   		 inner join facturacabecera fc on c.idCliente = fc.idCliente
   		 inner join facturadetalle fd on fc.idFactura = fd.idFactura
   	 where p.idProducto = fd.idProducto and z.idZona = 4
   	 order by p.Producto)
    order by prov.Proveedor) k
order by k.Rubro;

select * from
    (select r.Rubro, prov.Proveedor, p.Producto, p.precio
   	 from productos p inner join rubros r on r.idRubro = p.idRubro
   		 inner join proveedores prov on prov.idProveedor = p.idProveedor
   	 where p.idProducto not in
   	 (select p.idProducto
    	from zonas z inner join clientes c on c.idZona = z.idZona
   		 inner join facturacabecera fc on fc.idCliente = c.idCliente
   		 inner join facturadetalle fd on fd.idFactura = fc.idFactura
   		 inner join productos p on p.idProducto = fd.idProducto
   	 where z.idZona = 4 order by p.Producto)
    order by prov.Proveedor) k
order by k.Rubro;
## Ejercicio 29: Inserte un nuevo Producto
insert into productos (idProducto, idRubro, idProveedor, producto, precio) values (502, 3, 7, concat('Producto ', idProducto), 100);
-- Ejercicio 30: Cree una nueva tabla llamada ProductosTemp con todos los Productos de los rubros 2, 3, 7 y 9. 
-- Para crearla puede utilizar un asistente si lo desea.
create table ProductosTemp as select * from productos p where p.idProducto = 2 or p.idProducto = 3 or p.idProducto = 7 or p.idProducto = 9;
-- Ejercicio 31: A la tabla recientemente creada sume 10000 a los ids de cada producto y aumente los precios un 33%
update ProductosTemp set idProducto = idProducto + 1000, precio = precio*1.33;
-- Ejercicio 32: Inserte los productos de la tabla ProductosTemp en la tabla Productos y luego elimine todos los productos de la Tabla Productos Temp.
insert into productos select * from ProductosTemp;
delete from ProductosTemp;
-- Ejercicio 33: Elimine la Tabla ProductosTemp, puede utilizar un asistente si desea.
drop table ProductosTemp;
-- Ejercicio 34: Modifique los nombres de los clientes con cuenta inhabilitada de tal manera que al final del nombre se agregue el texto 
-- ‘- (Cuenta inhabilitada)’ Ej: Cliente 102 – (Cuenta Inhabilitada)
update clientes c set c.Cliente = concat(c.Cliente, "- (Cuente Inhabilitada)") where c.cuentaHabilitada = 0; 
-- Ejercicio 35: Cambie el nombre del Producto Nº 20 por ‘Producto Modificado’
update productos set Producto = 'Producto modificado' where idProducto = 20;
-- Ejercicio 36: Reduzca un 20% el precio de los productos que nunca fueron vendidos
update productos p set p.precio = (p.precio - p.precio*0.20) 
where p.idProducto not in (
	select fd.idProducto from facturadetalle fd);
-- Ejercicio 37: Elimine toda la información a cerca de las facturas anuladas
delete from facturadetalle fd where fd.idFactura in (select fc.idFactura from facturacabecera fc where fc.anulada = 1);
delete from facturacabecera fc where fc.anulada = 1;
-- Ejercicio 38: Inserte un nuevo cliente e inserte una factura para este cliente, la factura incluye un detalle de al menos 2 productos.

-- Ejercicio 39: Inhabilite las cuentas de los clientes a los que nunca se les ha facturado
update clientes c set c.cuentaHabilitada = 0 where c.idCliente not in (select idCliente from facturacabecera);
-- Ejercicio 40: Elimine las cuentas de los proveedores que nunca proveyeron ningún producto
delete from proveedores where idProveedor not in (select p.idProveedor from productos p);
-- Ejercicio 41: Cree una nueva tabla llamada Saldos con los datos de todos los Clientes, Zona, Saldo actual y una columna pagado en cero. 
-- Para crear la tabla puede utilizar un asistente si lo desea.
create table Saldos select c.idCliente, c.Cliente, z.idZona, z.zona, sum(fd.cantidad*p.precio) SaldoActual, 0 Pagado
from zonas z inner join clientes c on z.idZona = c.idZona
	inner join facturacabecera fc on c.idCliente = fc.idCliente
    inner join facturadetalle fd on fc.idFactura = fd.idFactura
    inner join productos p on fd.idProducto = p.idProducto
group by c.idCliente;