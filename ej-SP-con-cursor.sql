/* 9. SP que utilice cursor para recorrer offices y que genere lista con ciudades q hay oficinas. */
delimiter //
create procedure get_ciudades_offices (out listadoCiudades varchar(4000))
begin
	declare hayFilas boolean default 1;
	declare ciudadOficina varchar(45) default "";
	declare officesCursor cursor for SELECT city FROM offices;
	declare continue handler for not found set hayFilas = 0;
	set listadoCiudades = "";
	OPEN officesCursor;
		officesLoop:loop
		FETCH officesCursor INTO ciudadOficina;
		IF hayFilas = 0 THEN
			LEAVE officesLoop;
		END IF;
		SET listadoCiudades = concat(ciudadOficina, ", ", listadoCiudades);
		end loop officesLoop;
	CLOSE officesCursor;
end//
delimiter ;

call get_ciudades_offices(@listadoCiudades);
select @listadoCiudades;

/* 
10. Agregar tabla CancelledOrders con el mismo diseño que Orders. SP que recorra orders y cuente la cant
de órdenes en estado cancelled. Insertar fila en la tabla CancelledOrders por cada orden cancelada
y tiene que devolver la cantidad de órdenes canceladas.
*/

CREATE TABLE CancelledOrders(
	order_number int
);
drop procedure insert_CancelledOrders;
delimiter // 
create procedure insert_CancelledOrders(out cant int)
begin
	declare hayFilas boolean default 1;
    declare ordenObtenida int;
    DECLARE ordersCursor CURSOR FOR SELECT orderNumber FROM orders WHERE orders.status = "Cancelled";
	declare continue handler for not found set hayFilas = 0;
	OPEN ordersCursor;
		ordersLoop:loop
			FETCH ordersCursor INTO ordenObtenida;
				IF hayFilas = 0 THEN
					LEAVE ordersLoop;
				END IF;
			INSERT INTO CancelledOrders VALUE (ordenObtenida);
		end loop ordersLoop;
	CLOSE ordersCursor;
    SELECT count(*) INTO cant FROM CancelledOrders;
end //
delimiter ;

call insert_CancelledOrders(@cant);
select @cant;


/*
11. SP que reciba el customerNumber y para todas las órdenes de ese, si el campo comments esta vacío 
que lo complete con el siguiente comentario: “El total de la orden es … “ Y el total de la orden tendrá 
que calcularlo el procedimiento sumando todos los prods incluidos en la orden de la tabla OrderDetails.
*/
delimiter // 
create procedure alterCustomer(in numCliente int)
begin
	declare hayFilas boolean default 1;
    declare ordenObtenida int;
    declare totalOrden float default 0;
    
    DECLARE ordersCursor CURSOR FOR 
		SELECT orderNumber FROM orders WHERE comments IS NULL AND customerNumber = numCliente;
	declare continue handler for not found set hayFilas = 0;
    
	OPEN ordersCursor;
		ordersLoop:loop
			FETCH ordersCursor INTO ordenObtenida;
					IF hayFilas = 0 THEN
						LEAVE ordersLoop;
					END IF;
                    
                SET totalOrden = (SELECT sum(quantityOrdered * priceEach) 
								  FROM orderdetails WHERE orderNumber = ordenObtenida);
                UPDATE orders SET comments = concat("El total de la orden es:", totalOrden)
                WHERE orderNumber = ordenObtenida;
		end loop ordersLoop;
	CLOSE ordersCursor;
end //
delimiter ;

call alterCustomer(181);

/*
12. SP que devuelva mails de los clientes que cancelaron una orden y no volvieron a comprar.
*/
delimiter // 
create procedure salidaMails(out mails text)
begin
	declare hayFilas boolean default 1;
    declare ordenObtenida varchar(45) default "";
    
    DECLARE ordersCursor CURSOR FOR
	SELECT orderNumber FROM orders WHERE orders.status = "Cancelled";
    
	declare continue handler for not found set hayFilas = 0;
	OPEN ordersCursor;
		ordersLoop:loop
			FETCH ordersCursor INTO ordenObtenida;
				IF hayFilas = 0 THEN
					LEAVE ordersLoop;
				END IF;
                
                SELECT email INTO mails FROM customers c WHERE c.customerNumber IN
                (SELECT customerNumber, orderDate as ult_fecha FROM orders WHERE orderNumber = ordenObtenida) ;
		end loop ordersLoop;
	CLOSE ordersCursor;
end //
delimiter ;

select @mails;
call salidaMails(@mails);

/* 13. columna comisión en employees. SP que actualice la comisión de cada empleado.
Si tiene ventas > $100,000, comisión = 5%, ventas entre $50,000 y $100,000, 3%. Si tiene <
$50,000 en ventas, no recibe comisión. */
delimiter //
create procedure alterarComision() 
begin
	
end //
delimiter ;

ALTER TABLE employees ADD COLUMN comision float;
 
SELECT sum(quantityOrdered * priceEach) as totalPedido, orders.customerNumber, salesRepEmployeeNumber FROM orderdetails
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
JOIN customers ON customers.customerNumber = orders.customerNumber
GROUP BY orders.customerNumber;

/* 14. Crear un stored procedure que le asigne un empleado a los clientes que no tengan ninguno
asignado. El empleado asignado debe ser el que actualmente atienda a la menor cantidad
de clientes.. */

delimiter //
create function minimoCant () returns int deterministic
begin
	declare minima_cantidad int default 0; 
    SELECT min(cant) INTO minima_cantidad FROM (SELECT count(*) as cant, salesRepEmployeeNumber 
	FROM customers GROUP BY salesRepEmployeeNumber) AS SS;
    return minima_cantidad;
end //
delimiter ;

delimiter //
create procedure asignarEmpleados() 
begin
	declare hayFilas boolean default 1;
    declare empCursor CURSOR for SELECT em
end //
delimiter ;


UPDATE customers SET salesRepEmployeeNumber = empleadoObtenido WHERE 
(SELECT customerNumber FROM customers WHERE salesRepEmployeeNumber IS NULL);
(SELECT employeeNumber FROM employees WHERE employeeNumber =
 (SELECT count(*) as cant FROM customers GROUP BY salesRepEmployeeNumber)
 );
 
 SELECT COUNT(*) as cant, salesRepEmployeeNumber FROM customers
GROUP BY salesRepEmployeeNumber having cant = minimoCant() LIMIT 1;