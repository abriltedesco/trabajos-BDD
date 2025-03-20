/* 1- Crear una funcion que dado un empleado devuelva "Nivel 3" si esta a cargo de mas de 20 empleados,
"Nivel 2" si esta a cargo de mas de 10 pero menos de 20, y "Nivel 1" si esta a cargo de menos de 10 */

delimiter // 
create function devuelveNivel (empleado int) returns text deterministic
begin 
	declare nivel text;
    declare cantE int default 0 ;
    SELECT count(*) INTO cantE FROM customers 
    JOIN employees ON salesRepEmployeeNumber = employeeNumber 
    WHERE employeeNumber = empleado;
		IF (cantE > 20) THEN
			set nivel = "Nivel 3";
		ELSE IF (cantE < 10) THEN
			set nivel = "Nivel 1";
		ELSE 
			set nivel = "Nivel 2";
		END IF;
        END IF;
    return nivel;
end //
delimiter ; 

SELECT devuelveNivel(1501);

/* 2- Crear una funcion que reciba dos fechas (orderDate y shippedDate) y devuelva la cantidad
de dias que pasaron entre ambas. */

delimiter //
create function cantDias(fechaOrden date, fechaEnvio date) returns int deterministic
begin
	declare cantidad int default 0;
    SELECT DATEDIFF(fechaOrden, fechaEnvio) INTO cantidad;
    return cantidad;
end //
delimiter ;

SELECT cantDias("2024-08-25","2024-09-25");
     
/* 3- Crear una funcion que modifique el estado de las ordenes. Si pasaron mas de 10 dias entre la 
orderDate y la shippedDate el estado debe pasar a Cancelled y debe devolver la cantidad de ordenes
modificadas. Utilizar la función del ejercicio anterior. */

delimiter //
create function ordenesModificadas() returns int deterministic
begin
    declare cant_modificadas int default 0;
	SELECT count(*) INTO cant_modificadas FROM orders 
    WHERE cantDias(orderDate, shippedDate) > 10;
    UPDATE orders SET status = "Cancelled" WHERE cantDias(orderDate,shippedDate) > 10;
	return cant_modificadas;
end //
delimiter ;

SELECT ordenesModificadas();

/* 4- Crear una funcion que elimine cierto producto de una orden. Debe devolver la cantidad de
unidades de ese producto que habia en la orden.*/

delimiter //
create function eliminarProd(cod_producto text, num_orden int) returns int deterministic
begin
	declare cant_unidades int;
    set cant_unidades = (SELECT quantityOrdered FROM orderdetails 
    WHERE productCode = cod_producto and orderNumber = num_orden);
    DELETE FROM orderdetails WHERE productCode = cod_producto;
    return cant_unidades;
end //
delimiter ;

SELECT eliminarProd("S18_2248", 10100);

/* 5- Crear una función que reciba un código de producto (productCode) y devuelva "Sobrestock"
si la cantidad en stock (quantityInStock) es mayor a 5000,"Stock Adecuado" si está entre 1000
y 5000, y "Bajo Stock" si es menor a 1000. */

delimiter //
create function devuelveStock(cod_producto text) returns text deterministic
begin
	declare stock text default "Stock Adecuado";
    declare cant int default 0;
    SELECT quantityInStock INTO cant FROM products WHERE productCode = cod_producto;
		IF (cant > 5000) THEN 
			set stock = "Sobrestock";
		ELSE IF (cant < 1000) THEN 
			set stock = "Bajo Stock";
		END IF;
        END IF;
    return stock;
end //
delimiter ;

SELECT devuelveStock("S10_1678");

/* 6- Crear una función que reciba un año y devuelva el top 3 productos más vendidos (por
cantidad de unidades) en ese año, concatenados en un solo string separados por comas.*/

delimiter //
create function topVendidos (anio int) returns text deterministic
begin
	declare resultado text ;
    declare top1, top2, top3 text;
    
    SELECT sum(quantityOrdered) as cantT, productName INTO top1 FROM products
	JOIN orderdetails ON products.productCode = orderdetails.productCode 
	JOIN orders ON orderdetails.orderNumber = orders.orderNumber WHERE year(orderDate) = anio
	GROUP BY products.productCode ORDER BY cantT DESC LIMIT 1;

	SELECT sum(quantityOrdered)as cantT, productName INTO top2 FROM products
	JOIN orderdetails ON products.productCode = orderdetails.productCode 
	JOIN orders ON orderdetails.orderNumber = orders.orderNumber WHERE year(orderDate) = anio
	GROUP BY products.productCode ORDER BY cantT DESC LIMIT 2 OFFSET 2;

	SELECT sum(quantityOrdered) as cantT, productName INTO top FROM products
	JOIN orderdetails ON products.productCode = orderdetails.productCode 
	JOIN orders ON orderdetails.orderNumber = orders.orderNumber WHERE year(orderDate) = anio
	GROUP BY products.productCode ORDER BY cantT DESC LIMIT 3,3;
    
    set resultado = concat_ws(" , " , top1, top2, top3); 
    return resultado;
end // 
delimiter ;
SELECT topVendidos("2003");


	SELECT sum(quantityOrdered) as cantTotal, products.productCode, productName FROM products
	JOIN orderdetails ON products.productCode = orderdetails.productCode 
	JOIN orders ON orderdetails.orderNumber = orders.orderNumber where year(orderDate) = "2003"
	GROUP BY products.productCode ORDER BY cantTotal DESC LIMIT 3 offset 3;