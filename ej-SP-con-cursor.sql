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
delimiter;
CREATE PROCEDURE salidaMails(out mails text) BEGIN
    DECLARE noHayFilas INT DEFAULT FALSE;
    DECLARE mailObtenido VARCHAR(100);
    
    DECLARE mailCursor CURSOR FOR 
      SELECT emails FROM customers WHERE customers.customerNumber NOT IN (
      SELECT o.customerNumber FROM orders o WHERE status != 'Cancelled' 
      AND orderDate > (
        SELECT MAX(orderDate) FROM orders o2
        WHERE o.customerNumber = o2.customerNumber 
        AND status = 'Cancelled')
        );

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET noHayFilas = TRUE;

    SET mails = '';

    OPEN mailCursor;

    mailLoop: LOOP
        FETCH mailcursor INTO mailObtenido;
        IF noHayFilas THEN
            LEAVE mailLoop;
        END IF;

        SET mails = CONCAT(mails, mailObtenido, ', ');
    END LOOP;

    CLOSE mailCursor;
    SET mails = TRIM(TRAILING ', ' FROM mails);
END //

DELIMITER ;

select @mails;
call salidaMails(@mails);

/* 13. columna comisión en employees. SP que actualice la comisión de cada empleado.
Si tiene ventas > $100,000, comisión = 5%, ventas entre $50,000 y $100,000, 3%. Si tiene <
$50,000 en ventas, no recibe comisión. */ 
delimiter //

create procedure alterarComision() begin
  DECLARE noHayFilas INT DEFAULT FALSE;
  DECLARE totalObtenido FLOAT DEFAULT 0;
  DECLARE numEmpleado INT;

  ALTER TABLE employees ADD COLUMN IF NOT EXISTS comision FLOAT ;

  DECLARE totalCursor CURSOR FOR
    SELECT SUM(totalPedido) AS totalPorEmpleado, salesRepEmployeeNumber
    FROM (
      SELECT SUM(quantityOrdered * priceEach) AS totalPedido,
             orders.customerNumber, orders.salesRepEmployeeNumber
      FROM orderdetails
      JOIN orders ON orders.orderNumber = orderdetails.orderNumber
      JOIN customers ON customers.customerNumber = orders.customerNumber
      GROUP BY orders.customerNumber
    ) AS tP
    GROUP BY salesRepEmployeeNumber;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET noHayFilas = TRUE;

  OPEN totalCursor;

  totalLoop:loop
    FETCH totalCursor INTO totalObtenido, numEmpleado;
    IF noHayFilas THEN 
      LEAVE totalLoop;
    END IF;
 
 /* como todas las ventas daban +300k meti otros valores para hacer la comprobación*/
  DECLARE ventasConComision FLOAT;
  IF (totalObtenido > 500000) THEN
    SET ventasConComision = totalObtenido + (totalObtenido * 0.5);
  ELSE IF (totalObtenido < 100000) THEN 
    SET ventasConComision = totalObtenido;
  ELSE
    SET ventasConComision = totalObtenido + (totalObtenido * 0.3);
  END IF;

  
    UPDATE employees SET comision = ventasConComision 
    WHERE employeeNumber = numEmpleado; 
    
  END loop;
  CLOSE totalCursor;
END //

delimiter ;

CALL alterarComision();
SELECT employeeNumber, comision FROM employees;

/* 14. Crear un stored procedure que le asigne un empleado a los clientes que no tengan ninguno
asignado. El empleado asignado debe ser el que actualmente atienda a la menor cantidad
de clientes.. */

delimiter //
create function minimoCant () returns int deterministic
begin
   declare minima_cantidad int default 0; 
   SELECT min(cant) INTO minima_cantidad FROM 
   	(SELECT count(*) as cant, salesRepEmployeeNumber 
	FROM customers WHERE salesRepEmployeeNumber IS NOT NULL
	GROUP BY salesRepEmployeeNumber) AS SS;
    return minima_cantidad;
end //
delimiter ;

delimiter //
create procedure asignarEmpleados() 
begin
  declare hayFilas boolean default 1;
  declare numCliente int;
  declare empleadoObtenido int;
  declare minimo int default 0;
  SET minimo = SELECT minimoCant(); 
  
  DECLARE clientesCursor CURSOR FOR
    SELECT customerNumber FROM customers WHERE salesRepEmployeeNumber IS NULL;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET hayFilas = 0;
  
  OPEN clientesCursor;
  clientesLoop : loop
    FETCH clientesCursor INTO numCliente;
    IF hayFilas = 0 THEN
      LEAVE clientesLoop
    END IF;
    
    SELECT ss.salesRepEmployeeNumber INTO empleadoObtenido FROM
      (SELECT salesRepEmployeeNumber, count(*) as cant FROM customers
      WHERE salesRepEmployeeNumber IS NOT NULL GROUP BY salesRepEmployeeNumber) 
    as ss WHERE ss.cant = minimo LIMIT 1;
    
    UPDATE customers SET salesRepEmployeeNumber = empleadoObtenido 
    WHERE customerNumber = numCliente;
    
  END loop;
  CLOSE clientesCursor;
  
  
  
end //
delimiter ;
