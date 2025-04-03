# EXAMEN 2023 - 1 
/* 1- Crear una SF que reciba un id de cliente e indique si es o no frecuente. Es
frecuente si realizó al menos un 5% de las compras totales, en los últimos 6 meses. */
delimiter //
CREATE FUNCTION es_frecuente (idcliente int) returns text deterministic
begin
	declare cant_compras_totales int default 0;
	declare porcentaje float default 0;
    declare devolucion text default "el cliente no es frecuente";
    SELECT count(*) into cant_compras_totales FROM pedido;
    set porcentaje = ( 5 * cant_compras_totales) / 100 ;
	IF ( cant_pedidos(idcliente) > porcentaje ) THEN
		set devolucion = "el cliente es frecuente";
    END IF; 
    return devolucion;
end //
delimiter ;

SELECT es_frecuente(2);

delimiter //
create function cant_pedidos (idcliente int) returns int deterministic
begin
	declare cant int default 0;
	SELECT count(*) INTO cant FROM pedido 
    WHERE Cliente_codCliente = idcliente and fecha > "2024-10-03" ; /* 6 meses atrás */
    return cant;
end //
delimiter ;

/* 4- Crear una Stored Function que reciba un id de cliente y devuelva la cantidad de pedidos
pendientes de pago de ese cliente.*/
delimiter //
CREATE FUNCTION cant_pendientes (idcliente int) returns int deterministic
begin
	declare cantidad int default 0;
	SELECT count(*)	INTO cantidad FROM pedido
    JOIN estado ON pedido.Estado_idEstado = estado.idEstado
    WHERE estado.nombre = "Pago pendiente"
    GROUP BY Cliente_codCliente HAVING Cliente_codCliente = idcliente ;
    return cantidad;
end //
delimiter ;

SELECT cant_pendientes(2);

# EXAMEN 2023 - 2
/* 1- Crear una SF que, dado un proveedor, indique si es proveedor frecuente o no. 
Se considera frecuente si al menos proveyó un 5% del total de ingresos en los últimos 2
meses. */

delimiter //
CREATE FUNCTION provFrecuente (idprov int) returns text deterministic
begin
	declare ingresos_totales int default 0;
	declare porcentaje float default 0;
    declare devolucion text default "el proveedor no es frecuente";
    SELECT count(*) INTO ingresos_totales FROM ingresostock;
    SET porcentaje = ( 5 * ingresos_totales) / 100 ;
	IF ( Cantidad_Ingresos(idprov) > porcentaje ) THEN
		SET devolucion = "el proveedor es frecuente";
    END IF; 
    return devolucion;
end //
delimiter ;

SELECT prov_frecuente(3);

delimiter //
create function Cantidad_Ingresos(idprov int) returns int deterministic
begin
	declare cant int default 0;
	SELECT count(*) INTO cant FROM ingresostock 
    WHERE Proveedor_idProveedor = idprov and fecha > "2024-02-03" ; /* 2 meses atrás */
    return cant;
end //
delimiter ;

/* 2- Crear una SF que reciba un cod de prod y devuelva el precio promedio
 al que lo proveen todos los proveedores. */
delimiter //
CREATE FUNCTION precio_prom (cod_prod int) returns int deterministic
begin
	declare prom float default 0;
	SELECT avg(precio) INTO prom FROM producto_proveedor 
    WHERE Producto_codProducto = cod_prod;
    return prom;
end //
delimiter ;

SELECT precio_prom(2);
# EXAMEN 3
/* 1- Crear una SF que dado el id de una función, devuelva la cantidad de entradas
compradas para esa función. */

delimiter //
CREATE FUNCTION cant_compradas(idfuncion int) returns int deterministic
begin 
	declare cant int default 0;
    SELECT sum(cantEntradas) INTO cant FROM compras
    WHERE funcion_idFuncion = idfuncion;
    return cant;
end //
delimiter ;

SELECT cant_compradas(1);

/* 2- Crear una SF que reciba idcliente, calcule y retorne los puntos a favor.
Considerar que los puntos representan el 25% de lo que gastó el mes pasado. */

delimiter //
CREATE FUNCTION puntos_cliente(idcliente int) returns int deterministic
begin
	declare puntos int default 0;
    set puntos = gasto_mensual(idcliente) * 0.25;
    UPDATE cliente SET cliente.puntos = puntos WHERE idCliente = idcliente;
    return puntos;
end //
delimiter ;

delimiter //
CREATE FUNCTION gasto_mensual(idcliente int) returns int deterministic
begin
	declare suma int default 0;
	SELECT sum(valorEntrada * cantEntradas) INTO suma FROM compra
	JOIN funcion ON funcion_idFuncion = idFuncion
	WHERE fecha > "2025-03-01" and fecha < "2025-04-01" AND cliente_idCliente = idcliente;
    return suma;
end //
delimiter ;
