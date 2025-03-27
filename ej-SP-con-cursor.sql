/* 9. SP que utilice cursor para recorrer offices y que genere lista con ciudades q hay oficinas. */
delimiter //
create procedure get_ciudades_offices (out listadoCiudades varchar(4000))
begin
	declare hayFilas boolean default 1;
	declare ciudadOficina varchar(45) default "";
	declare officesCursor cursor for SELECT city FROM offices ;
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
10. Agregue una tabla llamada CancelledOrders con el mismo diseño que la tabla de Orders.
SP que recorra orders y cuente la cant de órdenes en estado cancelled. Insertar fila
en la tabla CancelledOrders por cada orden cancelada y tiene que devolver la cantidad de órdenes canceladas.
*/

delimiter // 
create procedure insertCancelledOrders()
begin
	declare hayFilas boolean default 1;
    declare cantOrdenesCanceladas int default 0;
    declare ordersCursor cursor for ;
end //
delimiter ;

/*
11. Realizar un SP que reciba el customerNumber y para todas las órdenes de ese
customerNumber, si el campo comments esta vacío que lo complete con el siguiente
comentario: “El total de la orden es … “ Y el total de la orden tendrá que calcularlo el
procedimiento sumando todos los productos incluidos en la orden de la tabla OrderDetails.
*/

delimiter // 
create procedure alterCommentOrder()
begin
	declare hayFilas boolean default 1;
end //
delimiter ;

/*
12. Crear un SP que devuelva en un parámetro de salida los mails de los clientes que
cancelaron una orden y no volvieron a comprar.
*/

delimiter // 
create procedure salidaMails()
begin
	declare hayFilas boolean default 1;
end //
delimiter ;