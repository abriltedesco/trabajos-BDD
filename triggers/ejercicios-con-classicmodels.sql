/* 1) a- trigger que se dispare desp de insertar en customers y que inserte info necesaria en customers_audit. */
CREATE TABLE customers_audit (
	idAudit int auto_increment not null primary key,
    operacion varchar(6),
    customer_number int,
    customer_name varchar(30),
    last_date_modified date
);

delimiter // 
create trigger after_insert_customers after insert on customers for each row
begin
	insert into customers_audit values ("insert", new.customerNumber, new.customerName, current_date());
end // 
delimiter ;

INSERT INTO customers VALUE
(497, "lelele", "swift", "taylor", "+1133345", "dsadsd", "Df", "L.A", "California", "1440", "usa", 1370, 35.00);

/* b- antes de una modif en customers que deje los datos antes de ser modif en la tabla customers_audit. */ 

delimiter // 
create trigger before_modif_customers before update on customers for each row
begin
	insert into customers_audit values ("update", old.customerNumber, old.customerName, current_date());
end //
delimiter ;

UPDATE customers SET creditLimit = 0.0 WHERE country = "USA";
/* c- trigger que, antes de borrar una fila en la tabla de customers, inserte los
datos anteriores en la tabla customes_audit. */ 

delimiter // 
create trigger before_delete_customers before delete on customers for each row
begin
	insert into customers_audit values (null, "delete", old.customerNumber, old.customerName, current_date());
end //
delimiter ;

DELETE FROM customers WHERE customerName = "Atelier graphique";

/* 2) Hacer lo mismo con la tabla de empleados. Crear una tabla de audit que contenga los
campos de la tabla employees más un id, operación, usuario y fecha de última modificación.
Definir un trigger para cada operación de insert, delete y update sobre la tabla. */ 
CREATE TABLE empleadosAudit (
	idAudit int auto_increment not null primary key,
    operacion varchar(6),
    employee_number int,
    employee_nombre varchar (30),
    email varchar (50),
    fecha_ult_modif date
);

/* ? */
delimiter //
create trigger before_insert_empleados before insert on employees for each row
begin
	insert into empleadosAudit values ("insert", new.employeeNumber, new.lastName, new.email, current_date());
end //
delimiter ;


delimiter //
create trigger after_insert_empleados after insert on employees for each row
begin
	insert into empleadosAudit values ("insert", new.employeeNumber, new.firstName, new.email, current_date());
end //
delimiter ;

INSERT INTO employees VALUES
(1122, "eilish", "billie", "x5555", "beilish@hotmail.com", 1, 1002, "VP Marketing");

delimiter //
create trigger before_update_empleados before update on employees for each row
begin
	insert into empleadosAudit values ("update", old.employeeNumber, old.firstName, old.email, current_date());	
end //
delimiter ;

delimiter //
create trigger after_update_empleados after update on employees for each row
begin
	insert into empleadosAudit values ("update", new.employeeNumber, new.firstName, new.email, current_date());
end //
delimiter ;

delimiter //
create trigger before_delete_empleados before delete on employees for each row
begin
	insert into empleadosAudit values ("delete", old.employeeNumber, old.firstName, old.email, current_date());	
end //
delimiter ;

delimiter //
create trigger after_delete_empleados after delete on employees for each row
begin
	insert into empleadosAudit values ("delete", old.employeeNumber, old.firstName, old.email, current_date());	
end //
delimiter ;


/* 3) Hacer un trigger que ante el intento de borrar un producto verifique que dicho producto
no exista en las órdenes cuya orderDate sea menor a dos meses. Si existe debe tirar un
error que diga “Error, tiene órdenes asociadas”. */
DROP FUNCTION existe_en_ordenes;
delimiter //
create function existe_en_ordenes(cod_prod text) returns boolean deterministic
begin
    declare existe boolean default false;
	declare codigo text default "000" ;
    SELECT productCode INTO codigo FROM orderdetails 
    WHERE orderNumber IN (SELECT orderNumber FROM orders WHERE orderDate < "2003-04-24")
	AND productCode = cod_prod;
    IF cod_prod = codigo THEN
		set existe =  true;
	END IF;
    return existe;
end //
delimiter ;

delimiter // 
create trigger intento_borrar_prod before delete on products for each row
begin
	IF existe_en_ordenes(old.productCode) THEN
		signal sqlstate '45000' set message_text = "error, tiene ordenes asociadas";
    END IF;
end //
delimiter ;

DELETE FROM products WHERE productCode = "S18_1342";