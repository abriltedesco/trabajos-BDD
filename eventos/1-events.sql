/* 1. Crear un evento que se ejecute diariamente y cambie el estado de los pedidos cuya
fecha de entrega ya pasó pero aún están marcados como "In Process" a "Delayed". */
UPDATE estado SET nombre = "Delayed" WHERE idEstado = 2;

delimiter //
create event cambiarEstadoPedidos on schedule 
every 1 day starts now() do
begin
	UPDATE orders SET status = "Delayed"
    	WHERE status = "In process" AND requiredDate < current_date() ;
end //
delimiter ;


/* 2. Crear un evento que cada mes elimine los pagos realizados hace más de 5 años. */
delimiter //
create event eliminePagosRealizados on schedule 
every 1 month starts now() do
begin
	DELETE FROM payments WHERE year(paymentDate) < 2020;
end //
delimiter ;

/* 3. Crea un evento que cada mes identifique a los clientes que han realizado más de 10
pedidos en el último año y les agregue un 10% de crédito extra en creditLimit. Esto se
debe realizar hasta el año que viene. */
delimiter //
create event clientesMas10Pedidos on schedule 
every 1 month starts now() ends now() + interval 1 year do
begin
	UPDATE customers SET creditLimit = clienteLimit + (clienteLimit * 0.1)
    	WHERE customerNumber IN (SELECT customerNumber FROM orders 
    	WHERE orderDate > "2025-05-29"
	GROUP BY customerNumber HAVING count(*) > 10);
end //
delimiter ;

/* 4. Crear un evento que a partir del día de mañana a las 7AM y una vez por semana, revise
si hay pagos pendientes de verificar y los marque como "Confirmed" si han pasado más
de 7 días. */
delimiter //
create event modificarPagosPend on schedule 
every 1 week starts now() + interval 1 day do
begin
	-- no comprendo como se verifican pagos pendientes, y donde se marca como confirmed? en status? comments?
end //
delimiter ;

/* 5. Crear un evento que realice un reporte diario de ventas. Para esto se debe crear una
tabla de reportes que contenga, id del reporte, fecha del mismo y total de ventas. El
evento debe generar un reporte de ventas todos los días a las 23:59, pero solo durante
el próximo trimestre. */
CREATE TABLE reportes (
	id int not null auto_increment primary key,
    fecha date,
    totalVentas int
);

delimiter //
create function cantVentasPorDia() returns int deterministic
begin
	declare cantidad int default 0;
    SELECT count(*) into cantidad FROM orders WHERE orderDate = current_date();
    return cantidad;
end //
delimiter ;

delimiter //
create event reporteVentas on schedule 
every 1 day starts now() ends now() + interval 3 month do
begin
	INSERT INTO reportes VALUE (null, current_date(), cantVentasPorDia());
end //
delimiter ;

/* 6. Crear un evento que cada 6 meses reduzca un 5% el precio de los productos que no
tengan ventas recientes. Debe iniciar el 1 de julio de 2025 */ 
delimiter //
create event reducirPrecios on schedule
every 6 month starts "2025-07-01" do
begin
	UPDATE products SET buyPrice = buyPrice - (buyPrice * 0.05) WHERE productCode IN (SELECT productCode FROM orderdetails
    JOIN orders ON orders.orderNumber = orderdetails.orderNumber
    WHERE orderDate < "2025-05-08");
end //
delimiter ;
