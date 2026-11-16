USE Ventas_Tech_DB;
GO



-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Proposito: integrar ventas, clientes, productos y categorias
-- para obtener una vista completa del negocio.

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- Hallazgo: Se registraron 10 ventas que pudieron
-- relacionarse con sus clientes, productos y categorias.
-- Esto permite analizar la facturacion por ciudad y
-- categoria para identificar oportunidades comerciales.



-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- Proposito: identificar clientes registrados que
-- nunca compraron para realizar acciones de CRM.

SELECT
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.id_cliente;


-- Hallazgo: No se identificaron clientes sin ventas.
-- Los 5 clientes registrados realizaron al menos una compra.
-- Para CRM, no hay clientes sin compras a quienes dirigir
-- una campana de primera compra con los datos actuales.



-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Proposito: identificar productos del catalogo
-- que no registraron ventas.

SELECT
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.id_producto;


-- Hallazgo: No se identificaron productos sin ventas.
-- Los 6 productos del catalogo registraron al menos
-- una venta. Para el area de producto, no hay articulos
-- completamente sin movimiento en el periodo analizado.



-- CONSULTA 4: CONSOLIDADO POR PERIODO (UNION ALL)
-- Proposito: comparar la facturacion de la primera
-- y segunda quincena de marzo de 2024.

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primera quincena' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) BETWEEN 1 AND 15

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segunda quincena' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) BETWEEN 16 AND 31
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;


-- Hallazgo: El 100% de la facturacion registrada
-- ($6444) corresponde a la primera quincena de marzo
-- de 2024. No se registraron ventas durante la segunda
-- quincena en los datos disponibles.
