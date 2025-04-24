/* 1) trigger que ante cada fila insertada en la Pedido_Producto modifique la tabla
IngresoStock_Producto restando la cant de esta tabla la cant informada en Pedido_Producto. */


/* 2) trigger que antes de borrar en la tabla IngresoStock borre todas las filas de la tabla
IngresoStock_Producto. */


/* 3) Imaginando que agregamos una columna categoría en la tabla de clientes, hacer un trigger que, cada vez
que se agrega un pedido, se calcule el monto total gastado por ese cliente en los últimos dos años y
actualice la categoría del cliente. Las categorías son “bronce” hasta $50.000 inclusive, “ plata”de $50.000 a
$100.000 inclusive y “oro” más de $100.000. */


/* 4) Realizar un trigger que después de insertar una fila en la tabla de IngresoStock_Producto incremente la
columna stock de la tabla de productos con la cantidad ingresada de la tabla IngresoStock_Producto. */


/* 5) Si las tablas de la base de datos estuvieran todas definidas con claves foráneas con restricción delete no
action ¿qué sucedería si quisiera borrar un pedido? Traten de solucionar esta situación mediante un
trigger que me permita llevar a cabo la acción de borrado en la tabla de pedidos. Planteen y desarrollen
cuáles serían otras alternativas de solución que se les ocurra, como por ejemplo utilizando una función o
definiendo cambio de restricciones, alguna otra característica que le parezca contemplar. *7