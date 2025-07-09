/* 1) trigger que ante cada fila insertada en Pedido_Producto modifique la tabla
IngresoStock_Producto restando la cant de esta tabla la cant informada en Pedido_Producto. */

delimiter //
create trigger after_insert_pedProducto after insert on pedido_producto for each row
begin
	UPDATE ingresostock_producto SET cantidad = cantidad - new.cantidad 
    WHERE Producto_codProducto = new.Producto_codProducto;
end //
delimiter ;

INSERT INTO pedido_producto VALUE (16, 5, 170.00, 1, 12);

/* 2) trigger que antes de borrar en la tabla IngresoStock borre todas las filas de la tabla
IngresoStock_Producto. */
delimiter //
create trigger before_delete_IngresoStock before delete on ingresostock for each row
begin
	delete from ingresostock_producto where IngresoStock_idIngreso = (old.idIngreso);
end //
delimiter ;

DELETE FROM ingresostock where idIngreso = 34;

/* 3) Imaginando que agregamos una columna categoría en clientes, hacer un trigger que, cada vez
que se agrega un pedido, se calcule el monto total gastado por ese cliente en los últimos dos años y
actualice la categoría del cliente. Las categorías son “bronce” hasta $50.000 inclusive,
 “plata” de $50.000 a $100.000 inclusive y “oro” más de $100.000. */

drop procedure categoriaCliente;
ALTER TABLE cliente add COLUMN categoria VARCHAR(15) NULL ;

delimiter //
create procedure categoriaCliente(in idCliente int)
begin
	declare hayFilas boolean default 1;
    declare cantGastoObtenido int default 0;
    
    declare gastoCursor CURSOR FOR 
		SELECT sum(cantidad * precioUnitario) FROM pedido 
        JOIN pedido_producto ON Pedido_idPedido = idPedido
		GROUP BY Cliente_codCliente HAVING Cliente_codCliente = idCliente ;
    declare continue handler for not found set hayFilas = 0;
    
    open gastoCursor;
    gloop:loop
		fetch gastoCursor into cantGastoObtenido;
			if hayFilas = 0 then
				leave gloop;
            end if;
            
			if cantGastoObtenido <= 5000 then
				UPDATE cliente SET categoria = "Bronce" WHERE codCliente = idCliente;
            else if (cantGastoObtenido > 5000 AND cantGastoObtenido  < 10000) then
				UPDATE cliente SET categoria = "Plata" WHERE codCliente = idCliente;
			else
				UPDATE cliente SET categoria = "Oro" WHERE codCliente = idCliente;
            end if;
            end if;
            
	end loop;
    close gastoCursor;
end //
delimiter ;

call categoriaCliente(2);

delimiter //
create trigger after_insert_pedido after insert on pedido for each row
begin
	call categoriaCliente(new.Cliente_codCliente);
end //
delimiter ;

INSERT INTO pedido VALUE (36, current_date(), 3, "3");

/* 4) Realizar un trigger que después de insertar una fila en la tabla de IngresoStock_Producto incremente la
columna stock de la tabla de productos con la cantidad ingresada de la tabla IngresoStock_Producto. */
delimiter //
create trigger after_insert_ingStockProd after insert on ingresostock_producto for each row
begin
	UPDATE producto SET stock = stock + (new.cantidad) WHERE codProducto = (new.Producto_codProducto);
end //
delimiter ;
INSERT INTO ingresostock_producto VALUE (3,10,1,1);

/* 5) Si las tablas de la bdd estuvieran todas definidas con claves foráneas con restricción delete no
action ¿qué sucedería si quisiera borrar un pedido? Traten de solucionar esta situación mediante un
trigger que me permita llevar a cabo la acción de borrado en la tabla de pedidos. Planteen y desarrollen
cuáles serían otras alternativas de solución que se les ocurra, como por ejemplo utilizando una función o
definiendo cambio de restricciones, alguna otra característica que le parezca contemplar. */

delimiter //
create trigger before_delete_pedidos before delete on pedido for each row
begin
	DELETE FROM pedido_producto where Pedido_idPedido = (old.idPedido);
end //
delimiter ;

DELETE FROM pedido WHERE idPedido = 8;
 
-- sin triggers seria con delete cascade o una funcion o procedure q pongas id y te borre directamente en todas las tablas con ese id
