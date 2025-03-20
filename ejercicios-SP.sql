/* 1. Crear un SP que liste todos los productos que tengan un precio de compra mayor al precio
promedio y que devuelva la cantidad de productos que cumplan con esa condición. */ 

delimiter //
create procedure cant_productos(out cant_prod int)
begin
	SELECT count(*) as cant FROM (SELECT productCode FROM products
	WHERE buyPrice > (SELECT avg(priceEach) FROM orderdetails) 
	group by productCode) as s1;
end //
delimiter ;

call cant_productos(@cant_prod);
select @cant_prod;

/* 2. Crear un SP que reciba un orderNumber y la borre. Previamente debe eliminar todos los
ítems de la tabla orderDetails asociados a él. Tiene que devolver 0 si no encontró filas para
ese orderNumber, o la cantidad ítems borrados si encontró el orderNumber. */ 

delimiter //
create procedure borrar_orden (in order_number int)
begin
	DELETE FROM orderdetails WHERE orderNumber = order_number;
	DELETE FROM orders WHERE orderNumber = order_number ;
end //
delimiter ;

call borrar_orden(@order_number);

/* 3. Crear un SP que borre una línea de productos de la tabla Productlines. Tenga en cuenta que
la línea de productos no podrá ser borrada si tiene productos asociados. El procedure debe
devolver un mensaje que contenga una de las siguientes leyendas:
“La línea de productos fue borrada”
“La línea de productos no pudo borrarse porque contiene productos asociados”.
Utilizar la función del punto 4. */ 

delimiter //
create procedure borrar_lina_prod()
begin

	
end //
delimiter ;

/* 4. Realizar un SP que liste la cantidad de órdenes que hay por estado. */

delimiter //
create procedure cantidad_ordenes (out cant_orden int)
begin
	SELECT count(*) INTO cant_orden FROM orders GROUP BY status;
end //
delimiter ;

call cantidad_ordenes(@cant_orden);
select @cant_orden;

/* 5. Realice un SP que liste para cada empleado con gente subordinada, cuántos empleados
tiene a cargo. */

delimiter //
create procedure cant_empleados (out cantE int)
begin
	SELECT count(*) INTO cantE FROM customers 
    JOIN employees ON salesRepEmployeeNumber = employeeNumber 
    GROUP BY employeeNumber;
end //
delimiter ;

call cant_empleados(@cantE);

/* 6. Realice un SP que liste el número de orden y su precio total. */ 

delimiter //
create procedure orden_y_precio ()
begin

end //
delimiter ;

/* 7. Crear un SP que liste el número de cliente y nombre, junto con las órdenes asociadas a ese
cliente y el total por orden. */ 

delimiter //
create procedure ordenes_clientes ()
begin
	
end //
delimiter ;

/* 8. Realizar un SP que modifique el campo comments de la tabla orders. El procedimiento
recibe un orderNumber y el comentario. El procedimiento devuelve 1 si se encontró la
orden y se modificó, y 0 en caso contrario. */

delimiter //
create procedure modificar_comments()
begin

	
end //
delimiter ;