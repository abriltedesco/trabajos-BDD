/* 1) Crear una función que devuelva la cantidad de órdenes con determinado estado en el
rango de dos fechas (orderDate). La función recibe por parámetro las fechas desde, hasta
y el estado. */ 

delimiter // 
create function cantOrdenes(fechaI date, fechaF date, estado text) returns int deterministic
begin
	declare cantidad int default 0;
    SELECT count(*) INTO cantidad FROM orders 
    WHERE orders.status = "Shipped" and orderDate between fechaI and fechaF ; 
    return cantidad;
end // 
delimiter ; 

SELECT cantOrdenes("2003-05-13", "2004-01-02", "Shipped"); 

/* 2) Crear una función que reciba por parámetro dos fechas de envío (shippedDate) desde,
hasta y devuelve la cantidad de órdenes entregadas. */

delimiter // 
create function cantOrdenesE (fechaI date, fechaF date) returns int deterministic
begin
	declare cantidad int default 0;
    SELECT count(*) INTO cantidad FROM orders 
    WHERE shippedDate between fechaI and fechaF ; 
    return cantidad;
end // 
delimiter ; 

SELECT cantOrdenesE("2004-01-01", "2004-12-31"); 

/* 3) Crear una función que reciba un número de cliente y devuelva la ciudad a la que
corresponde el empleado que lo atiende. */

delimiter // 
create function ciudadEmpleado (numCliente text) returns text deterministic
begin
	declare ciudadE text default "-";
    SELECT offices.city INTO ciudadE FROM offices  
	JOIN employees ON offices.officeCode = employees.officeCode
    JOIN customers ON salesRepEmployeeNumber = employeeNumber
	WHERE customers.phone = numCliente;  
    return ciudadE;
end // 
delimiter ; 

SELECT ciudadEmpleado(6505555787); 

/* 4) Crear una función que reciba una productline y devuelva la cantidad de productos
existentes en esa línea de producto. */

delimiter // 
create function cantProductos (product_line text) returns int deterministic
begin
	declare cantidad int default 0;
    SELECT count(*) INTO cantidad FROM products 
	WHERE products.productLine = product_line;
    return cantidad;
end // 
delimiter ; 

SELECT cantProductos("Planes"); 

/* 5) Crear una función que reciba un officeCode y devuelva la cantidad de clientes que tiene la
oficina. */

delimiter // 
create function clientesPorOficina (codigoOficina int) returns int deterministic
begin
	declare cantClientes int default 0;
	SELECT count(*) INTO cantClientes FROM customers 
	JOIN employees ON salesRepEmployeeNumber = employeeNumber 
    JOIN offices ON employees.officeCode = offices.officeCode
    GROUP BY employees.officeCode HAVING employees.officeCode = codigoOficina;
    return cantClientes;
end // 
delimiter ; 

SELECT clientesPorOficina(4);

/* 6) Crear una función que reciba un officeCode y devuelva la cantidad de órdenes que se
hicieron en esa oficina. */

delimiter // 
create function ordenesPorOficina (codigoOficina int) returns int deterministic
begin
	declare cantOrdenes int default 0;
	SELECT count(*) INTO cantOrdenes FROM orders 
    JOIN customers ON customers.customerNumber = orders.customerNumber
	JOIN employees ON salesRepEmployeeNumber = employeeNumber 
    GROUP BY employees.officeCode HAVING employees.officeCode = codigoOficina;
    return cantOrdenes;
end // 
delimiter ; 

SELECT ordenesPorOficina(4);

/* 7) Crear una función que reciba un nro de orden y un nro de producto, y devuelva el beneficio
obtenido con ese producto. El beneficio debe calcularse como priceEach – buyPrice. */

delimiter // 
create function calcularBeneficio (nroOrden int, nroProd text) returns float deterministic
begin
	declare beneficio float default 0;
	SELECT ( priceEach - buyPrice ) INTO beneficio FROM orderdetails
	JOIN products ON products.productCode = orderdetails.productCode
	WHERE orderdetails.orderNumber = nroOrden AND products.productCode = nroProd; 
    return beneficio;
end //
delimiter ;

SELECT calcularBeneficio(10107,"S10_1678");

/* -- 8) Crear una función que reciba un orderNumber y si el mismo está en estado cancelado devuelva -1, sino 0. */
drop function devolverNumero;
delimiter // 
create function devolverNumero (nroOrden int) returns int deterministic
begin
	declare estado text;
    declare numero int default 0;
    SELECT status INTO estado FROM orders WHERE orderNumber = nroOrden;
		IF (estado = "Cancelled") THEN
			set numero = -1;
		END IF;
    return numero;
end //
delimiter ;

SELECT devolverNumero(10107);

/* 9) Crear una función que devuelva la fecha de la primera orden hecha por ese cliente. Recibe
el nro de cliente por parámetro. */

delimiter // 
create function fechaPrimerOrden (nroCliente int) returns date deterministic
begin
    declare fecha date;
		SELECT min(orderDate) as dateOrder FROM customers 
		JOIN orders ON customers.customerNumber = orders.customerNumber
		WHERE customers.customerNumber = nroCliente;
    return fecha;
end //
delimiter ;

SELECT fechaPrimerOrden(103);

/* --- 10) Crear una SF que reciba un código de producto y devuelva el porcentaje de veces 
que el producto se vendió por debajo de dicho precio. */

delimiter // 
create function porcentajeVecesVendido (codProd text) returns int deterministic
begin
	declare porcentaje, precioVendido, precioMSRP float;
    declare cantVecesVP, cantVecesVP_total, CVVPT int default 0;
	SELECT COUNT(*) INTO cantVecesVP_total FROM
    (SELECT priceEach, MSRP INTO precioVendido, precioMSRP FROM products
	JOIN orderdetails ON orderdetails.productCode = products.productCode 
	WHERE products.productCode = codProd) as c;
		WHILE(CVVPT > 0) DO /* para q chequee cada una antes de calcular porcentaje*/
			IF (precioVendido < precioMSRP) THEN
				set cantVecesVP = cantVecesVP + 1; /* suma cant veces vendido por menor precio */
			END IF;
        END WHILE;
	set porcentaje = (cantVecesVP * 100) / cantVecesVP_total;
    return porcentaje;
end //
delimiter ;

SELECT porcentajeVecesVendido ("S10_3380"); 

-- SELECT orderNumber, products.productCode, quantityOrdered, MSRP, priceEach FROM products
-- JOIN orderdetails ON orderdetails.productCode = products.productCode;

/* 11) Crear una función que reciba un código de producto y devuelva la última fecha en la que
fue pedido el mismo. */

delimiter // 
create function ultFechaPedido (codProd text) returns date deterministic
begin
	declare fecha date;
	SELECT min(orderDate) INTO fecha FROM orders
	JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
	WHERE productCode = codProd;
    return fecha;
end // 
delimiter ; 

SELECT ultFechaPedido ("S24_2300");

/* 12) Crear una SF que reciba dos fechas desde, hasta y un código de producto. Si el producto
fue ordenado en alguna orden entre esas fechas que devuelva el mayor precio. Si el
producto no fue ordenado en esas fechas que devuelva 0. */

delimiter // 
create function ordenado_o_no (fecha1 date, fecha2 date, codProd text) returns date deterministic
begin
	
end // 
delimiter ; 

SELECT ordenado_o_no("","","");

/* 13) Crear una SF que reciba el número de empleado y devuelva la cantidad de clientes que
atiende. */

delimiter // 
create function cantClientes (numEmp int) returns int deterministic
begin
	declare cantidad int default 0;
	SELECT count(*) INTO cantidad FROM customers
    JOIN employees ON salesRepEmployeeNumber = employeeNumber
    WHERE employeeNumber = numEmp;
    return cantidad;
end // 
delimiter ; 

SELECT cantClientes("1165");

/* 14) Crear una SF que reciba un número de empleado y devuelva el apellido del empleado al
que reporta. */

delimiter // 
create function apellidoEmp (numEmp int) returns text deterministic
begin
	declare apellido text default "-";
		SELECT lastName FROM employees WHERE employeeNumber = numEmp;
    return apellido;
end // 
delimiter ; 

SELECT apellidoEmp(1165);