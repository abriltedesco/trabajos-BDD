/* 1) Listar los nombres de los proveedores de la ciudad de La Plata. */
SELECT nombre FROM proveedor WHERE ciudad = "La Plata";

/* 2) Eliminar los artículos que no están compuestos por ningún material. */
DELETE FROM articulo WHERE codigo = (SELECT articulo_codigo FROM compuesto_por WHERE material_codigo IS NULL);

/* 3) Mostrar códigos y descripciones de los artículos compuestos por al menos un material */
SELECT codigo, descripcion FROM articulo 
WHERE codigo IN (SELECT articulo_codigo FROM compuesto_por 
WHERE material_codigo IN (SELECT material_codigo FROM compuesto_por WHERE material_codigo IS NOT NULL));

/* 4) Hallar códigos y nombres de proveedores que proveen al menos un material que se usa
en algún artículo cuyo precio es mayor que $10000. */
SELECT codigo, nombre FROM proveedor WHERE codigo IN 
(SELECT proveedor_codigo FROM provisto_por WHERE material_codigo IN
(SELECT material_codigo FROM compuesto_por WHERE articulo_codigo IN 
(SELECT codigo FROM articulo WHERE precio > 10000)));

/* 5) Hallar el o los códigos de artículos de mayor precio. */
SELECT codigo FROM articulo ORDER BY precio DESC LIMIT 5;

/* 6) Mostrar el nombre del producto que tiene mayor stock, teniendo en cuenta todos los
almacenes. */
SELECT descripcion FROM articulo WHERE codigo IN 
(SELECT articulo_codigo FROM tiene ORDER BY stock, almacen_codigo DESC );

SELECT descripcion FROM articulo JOIN tiene ON codigo = articulo_codigo 
GROUP BY codigo ORDER BY sum(stock) DESC LIMIT 1;

/* 7) Hallar los números de almacenes que tienen artículos que incluyen el material con
código 2. */
SELECT almacen_codigo FROM tiene WHERE articulo_codigo IN
(SELECT articulo_codigo FROM compuesto_por WHERE material_codigo = "2")
GROUP BY almacen_codigo;

/* 8) Listar el nombre del artículo que está compuesto por más materiales. */ 
SELECT descripcion FROM articulo WHERE codigo IN
(SELECT articulo_codigo FROM compuesto_por ORDER BY 
(SELECT count(material_codigo) as cantM FROM compuesto_por GROUP BY articulo_codigo)) LIMIT 1;

/* --- 9) Modificar el precio de los productos con stock menor a 20, aumentarlo un 20%. */
UPDATE articulo SET precio = precio + (precio * 0.20) 
WHERE codigo IN (SELECT articulo_codigo FROM tiene WHERE stock > 20);

/* 10) Listar el promedio de la cantidad de materiales por el que está compuesto un artículo. */
SELECT avg(cantM) as promedio FROM
(SELECT count(*) as cantM FROM compuesto_por GROUP BY articulo_codigo) as aaaa;

/* 11) Hallar para cada almacén el precio mínimo, máximo y promedio de los artículos que 
tiene. */
SELECT max(precio) as maximo, min(precio) as minimo, avg(precio), almacen_codigo as promedio 
FROM articulo JOIN tiene ON articulo_codigo = codigo GROUP BY almacen_codigo;

/* 12) Listar para cada almacén el stock valorizado (valor de los productos teniendo en
cuenta el precio y el stock). */
SELECT sum(precio * stock) FROM articulo
JOIN tiene ON articulo_codigo = codigo
GROUP BY almacen_codigo;

/* 13) Listar el stock valorizado de cada producto (independiente del almacén) para todos
los artículos cuya existencia supera 100 unidades. */ 
SELECT sum(precio * stock) FROM articulo 
JOIN tiene ON articulo_codigo = codigo WHERE stock > 100
GROUP BY codigo ;

/* --- 14) Hallar los artículos cuyo precio es superior a $5000 y que están compuestos por más de
tres materiales. */
SELECT articulo.codigo, articulo.descripcion FROM compuesto_por 
JOIN articulo ON codigo = articulo_codigo 
WHERE articulo.precio > 5000 
GROUP BY articulo_codigo HAVING count(material_codigo) > 3;

/* 15) Listar los materiales que componen los artículos cuyo precio es superior al precio
promedio de los artículos del almacén nro. 2 */
SELECT codigo, descripcion FROM articulo WHERE precio >
(SELECT avg(precio) FROM articulo
JOIN tiene ON articulo_codigo = codigo WHERE almacen_codigo = 2);