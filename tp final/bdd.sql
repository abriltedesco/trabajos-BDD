CREATE DATABASE DHT;
USE DHT;


CREATE TABLE cliente (
    dni varchar(15) primary key UNIQUE NOT NULL,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    fechaNacimiento date,
	puntos int DEFAULT 0,
    genero enum('M','F','Otro') NOT NULL
);

CREATE TABLE marca (
    idMarca int primary key,
    nombreMarca VARCHAR(100) NOT NULL,
    stockMinimo int DEFAULT 5,
    aceptaDevoluciones BOOLEAN DEFAULT FALSE,
    porcentajeComision DECIMAL(5,2) DEFAULT 10.00,
    gananciasTotales DECIMAL(10,2) DEFAULT 0,
    puntos int DEFAULT 0
);

CREATE TABLE evento (
    idEvento int AUTO_INCREMENT primary key,
    nombreEvento VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fechaHora DATETIME NOT NULL,
    ubicacion VARCHAR(100)
);

CREATE TABLE tela (
    idTela int AUTO_INCREMENT primary key,
    nombreTela VARCHAR(50) NOT NULL
);

CREATE TABLE modeloRopa (
    idModelo int AUTO_INCREMENT primary key,
    idTela int NOT NULL,
    color varchar(30) NOT NULL,
    genero enum('M','F','Unisex') NOT NULL,
    precio decimal(10,2) NOT NULL,
    foreign key(idTela) references tela(idTela)
);

CREATE TABLE prenda (
    idPrenda int AUTO_INCREMENT primary key,
    idModelo int NOT NULL,
    idMarca int NOT NULL,
    stock int DEFAULT 0,
    foreign key(idModelo) references modeloRopa(idModelo),
    foreign key(idMarca) references marca(idMarca)
);

CREATE TABLE metodoPago (
    idMetodo int AUTO_INCREMENT primary key,
    nombreMetodo VARCHAR(50) NOT NULL
);

CREATE TABLE compra (
    idCompra int AUTO_INCREMENT primary key,
    idCliente int NOT NULL,
    datetimeCompra datetime NOT NULL,
    idMetodo int NOT NULL,
    costoTotal decimal(10,2) NOT NULL,
    foreign key(idCliente) references cliente(idCliente),
    foreign key(idMetodo) references metodoPago(idMetodo)
);

CREATE TABLE compra_detalle (
	id int primary key NOT NULL auto_increment,
    idCompra int,
    idPrenda int,
    cantidad int NOT NULL,
    precioUnitario decimal(10,2) NOT NULL,
    foreign key(idCompra) references compra(idCompra),
    foreign key(idPrenda) references prenda(idPrenda)
);

CREATE TABLE devolucion (
    idDevolucion int AUTO_INCREMENT primary key,
    idCompra int NOT NULL,
    idCliente int NOT NULL,
    fechaHora datetime NOT NULL,
    idMetodo int NOT NULL,
    costoTotal decimal(10,2) DEFAULT 0,
    foreign key(idCompra) references compra(idCompra),
    foreign key(idCliente) references cliente(idCliente),
    foreign key(idMetodo) references metodoPago(idMetodo)
);

CREATE TABLE alerta_stock (
    idAlerta int AUTO_INCREMENT primary key,
    idPrenda int NOT NULL,
    fecha datetime NOT NULL,
    motivo varchar(100),
    foreign key(idPrenda) references prenda(idPrenda)
);

CREATE TABLE resenia (
    idResenia int AUTO_INCREMENT primary key,
    idCliente int NOT NULL,
    idPrenda int NOT NULL,
    comentario TEXT,
    estrellas int CHECK (estrellas BETWEEN 1 AND 5),
    fecha date NOT NULL,
    foreign key(idCliente) references cliente(idCliente),
    foreign key(idPrenda) references prenda(idPrenda)
);
