USE Ventas_Tech_DB;
GO
-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- CONSULTA 2: TOP 5 PRODUCTOS POR FACTURACION

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- CONSULTA 3: CLIENTES RECURRENTES

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;


WITH facturacion_productos AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_productos
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_productos
ORDER BY total_facturado DESC;


-- HALLAZGOS DEL ANALISIS

-- Hallazgo 1:
-- En marzo de 2024 se registraron 10 pedidos,
-- con una facturacion total de $6444
-- y un ticket promedio de $644,40.

-- Hallazgo 2:
-- El producto ID 1 fue el de mayor facturacion,
-- generando $3600, equivalente al 55,9%
-- de la facturacion total.

-- Hallazgo 3:
-- Los 5 clientes realizaron 2 pedidos cada uno.
-- El cliente ID 1 fue el de mayor gasto,
-- con un total de $2640.