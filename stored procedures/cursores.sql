/* 1. Crear un Stored Procedure que actualice el stock de los productos teniendo en cuenta los
ingresos de esta semana. */
delimiter //
create procedure actualizarStock()
begin
    declare hayFilas boolean default 1;
    declare prodObtenido int default 0;
    declare cantObtenida int default 0;
    declare prodCursor CURSOR FOR SELECT Producto_codProducto, sum(cantidad) as cant
    FROM ingresostock_producto 
    JOIN ingresostock ON idIngreso = IngresoStock_idIngreso
    WHERE fecha > "2025-05-01" GROUP BY Producto_codProducto ;
    declare continue handler for not found set hayFilas = 0;
    
    open prodCursor;
    ploop:loop
	fetch prodCursor into prodObtenido, cantObtenida;
		if hayFilas = 0 then
			leave ploop;
                end if;
        UPDATE producto SET stock = stock + cantObtenida WHERE codProducto = prodObtenido;
	end loop;
    close prodCursor;
end //
delimiter ;

call actualizarStock();

/*  2. Crear un Stored Procedure que reduzca el precio de los productos en un 10% si no se
vendieron más de 100 unidades en la semana. */
delimiter //
create procedure reducirPrecio()
begin
    declare hayFilas boolean default 1;
    declare prodObtenido int default 0;
    declare cantObtenida int default 0;
    declare prodCursor CURSOR FOR SELECT Producto_codProducto, sum(cantidad) as c
    FROM pedido_producto 
    JOIN pedido ON idPedido = Pedido_idPedido
    WHERE fecha > "2025-05-01" GROUP BY Producto_codProducto ;
    declare continue handler for not found set hayFilas = 0;
    
    open prodCursor;
    ploop:loop
	fetch prodCursor into prodObtenido, cantObtenida;
		if hayFilas = 0 then
			leave ploop;
        	end if;
            
        if cantObtenida < 100 then
             UPDATE producto SET precio = precio - (precio * 0.1) WHERE codProducto = prodObtenido;
        end if;
    end loop;
    close prodCursor;
end //
delimiter ;

call reducirPrecio();

/*  3. Crear un Stored Procedure que actualice el precio de los productos. Debe ser un 10% más
que el mayor precio al que lo proveen los proveedores. */

delimiter //
create procedure actualizarPrecio()
begin
    declare hayFilas boolean default 1;
    declare prodObtenido int default 0;
    declare maxObtenido int default 0;
    declare prodCursor CURSOR FOR SELECT Producto_codProducto, max(precio) as maximo
    FROM producto_proveedor GROUP BY Producto_codProducto;
    declare continue handler for not found set hayFilas = 0;
    
    open prodCursor;
    ploop:loop
	fetch prodCursor into prodObtenido, maxObtenido;
		if hayFilas = 0 then
			leave ploop;
                end if;
			
	UPDATE producto SET precio = precio + maxObtenido + (maxObtenido * 0.1) 
        WHERE codProducto = prodObtenido;
    end loop;
    close prodCursor;
end //
delimiter ;

call actualizarPrecio();

/*  4. Suponiendo que agregamos una columna llamada “nivel” en la tabla de proveedores, se
pide realizar un procedimiento que calcule la cantidad de ingresos por proveedor en los
últimos 2 meses y actualice el nivel del proveedor. Los niveles son “Bronce” hasta 50
ingresos inclusive, “Plata” de 50 a 100 ingresos inclusive y “Oro” más de 100. */


delimiter //
create procedure crearNivel()
begin
    declare hayFilas boolean default 1;
    declare provObtenido int default 0;
    declare cantIngresos int default 0;
    declare provCursor CURSOR FOR SELECT Proveedor_idProveedor, count(*) as cant
    FROM ingresostock GROUP BY Proveedor_idProveedor;
    declare continue handler for not found set hayFilas = 0;
    ALTER TABLE proveedor ADD COLUMN nivel varchar(15) null;
    
    open provCursor;
    ploop:loop
	fetch provCursor into provObtenido, cantIngresos;
		if hayFilas = 0 then
			leave ploop;
                end if;
            
	if cantIngresos <= 50 then
		UPDATE proveedor SET nivel = "Bronce" WHERE idProveedor = provObtenido;
        else if (cantIngresos > 50 AND cantIngresos < 100) then
		UPDATE proveedor SET nivel = "Plata" WHERE idProveedor = provObtenido;
	else
		UPDATE proveedor SET nivel = "Oro" WHERE idProveedor = provObtenido;
        end if;
        end if;
            
    end loop;
    close provCursor;
end //
delimiter ;

call crearNivel();

/*  5. Realice un procedimiento que actualice el precio unitario de los productos que están en
pedidos pendientes de pago, al precio actual del producto */

delimiter //
create procedure actualizarPrecioUnit()
begin
    declare hayFilas boolean default 1;
    declare prodObtenido int default 0;
    declare precioObtenido int default 0;
    declare idPedObtenido int default 0;
    declare prodCursor CURSOR FOR 
		SELECT Producto_codProducto, idPedido, precio FROM pedido
		JOIN pedido_producto ON idPedido = Pedido_idPedido
		JOIN estado ON Estado_idEstado = idEstado
		WHERE estado.nombre = "Pago Pendiente";
    declare continue handler for not found set hayFilas = 0;
    
    open prodCursor;
    ploop:loop
	   fetch prodCursor into prodObtenido, idPedObtenido, precioObtenido;
		if hayFilas = 0 then
			leave ploop;
                end if;
                        
            UPDATE pedido_producto SET precioUnitario = precioUnitario + precioObtenido
            WHERE Producto_codProducto = prodObtenido AND Pedido_idPedido = idPedObtenido;
    end loop;
    close prodCursor;
end //
delimiter ;

call actualizarPrecioUnit();
