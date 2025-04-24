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

/* 2. Crear un SP que reciba un orderNumber y la borre. Previamente debe eliminar todos los
ítems de la tabla orderDetails asociados a él. Tiene que devolver 0 si no encontró filas para
ese orderNumber, o la cantidad ítems borrados si encontró el orderNumber. */ 

delimiter //
create procedure cant_items(inout order_number int, out cantidad int)
begin
    SELECT count(*) INTO cantidad FROM orderdetails WHERE orderNumber = order_number;
end //
delimiter ;

delimiter //
create procedure borrar_orden (in order_number int, out cantidad int)
begin
	call cant_items(@order_number, @cantidad);
	select @cantidad;
	DELETE FROM orderdetails WHERE orderNumber = order_number;
	DELETE FROM orders WHERE orderNumber = order_number ;
    IF (NOT EXISTS(SELECT * FROM orders WHERE orderNumber = order_number)) THEN
		set @cantidad = 0;
	END IF;	
end //
delimiter ;

set @order_number = 10110;
call borrar_orden(@order_number, @cant);
select @cant;

/* 3. Crear un SP que borre una línea de productos de la tabla Productlines. Tenga en cuenta que la línea 
de productos no podrá ser borrada si tiene productos asociados. El procedure debe devolver un mensaje: 
“La línea de productos fue borrada” "La línea de productos no pudo borrarse porque contiene productos asociados”.
Utilizar la función del punto 4. */ 

#### error : operand should contain 1 column

delimiter //
create procedure borrar_linea(out mensaje text)
begin
	IF (SELECT * FROM productlines JOIN products 
		ON productlines.productLine = products.productLine IS NULL) 
	THEN
		DELETE FROM productlines ;
		set mensaje = "La línea de productos fue borrada";
	ELSE 
		set mensaje = "La línea de productos no pudo borrarse porque contiene productos asociados";
    END IF;
end //
delimiter ;

call borrar_linea(@mensaje);
select @mensaje;

/* 4. Realizar un SP que liste la cantidad de órdenes que hay por estado. */

delimiter //
create procedure cant_ordenes()
begin
	SELECT count(*) FROM orders GROUP BY orders.status;
end //
delimiter ;
call cant_ordenes();

/* 5. Realice un SP que liste para cada empleado con gente subordinada, cuántos empleados
tiene a cargo. */ 

delimiter //
create procedure cantidad_de_empleados()
begin
	SELECT count(*), jefe.lastname FROM employees as empleado
    JOIN employees as jefe ON jefe.employeeNumber = empleado.employeeNumber
    GROUP BY empleado.reportsTo;
end //
delimiter ;

drop procedure cantidad_de_empleados;
call cantidad_de_empleados();

/* 6. Realice un SP que liste el número de orden y su precio total. */ 
delimiter //
create procedure orden_y_precio (inout numorden int, out precioTotal float)
begin
	SELECT sum(quantityOrdered * priceEach) into precioTotal
    FROM orderdetails WHERE orderNumber = numorden;
end //
delimiter ;

call orden_y_precio(@numorden, @precioTotal);
set @numorden = 10120;
select @numorden, @precioTotal;

/* 7. Crear un SP que liste el número de cliente y nombre, junto con las órdenes asociadas a ese
cliente y el total por orden. */ 

delimiter //
create procedure ordenes_de_clientes(in numcliente int, out total int, out nombre text)
begin
	SELECT customerName INTO nombre FROM customers WHERE customerNumber = numcliente;
	SELECT sum(quantityOrdered * priceEach) into total FROM orderdetails
    JOIN orders ON orders.orderNumber = orderdetails.orderNumber
    JOIN customers ON orders.customerNumber = customers.customerNumber 
    WHERE customers.customerNumber = numcliente;
end //
delimiter ;

call ordenes_de_clientes(@numcliente, @total, @nombre);
set @numcliente = 124;
select @nombre, @numcliente, @total;

/* 8. Realizar un SP que modifique el campo comments de la tabla orders. El procedimiento
recibe un orderNumber y el comentario. El procedimiento devuelve 1 si se encontró la
orden y se modificó, y 0 en caso contrario. */

delimiter //
create procedure modificar_comment(in numorden int, in comentario text, out num int)
begin
	IF (EXISTS(SELECT orderNumber FROM orders WHERE orderNumber = numorden)) THEN
		UPDATE orders SET comments = comentario;
        set num = 1;
	ELSE 
		set num = 0;
    END IF;
end //
delimiter ;

call modificar_comment(@numorden, @comentario, @num);
set @numorden = 10103;
set @comentario = "comentario nuevo";
select @num;
