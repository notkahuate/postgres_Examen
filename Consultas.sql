--  Productos con stock menor a 5 unidades
SELECT p.id_serial, p.nombre, s.cantidad
FROM productos p
JOIN stock s ON p.id_serial = s.id_producto
WHERE s.cantidad < 5;

-- Ventas totales de un mes específico 
SELECT SUM(dv.cantidad * p.precio) AS total_ventas
FROM ventas v
JOIN  ventas_detalle dv ON v.id_serial = dv.venta_id
JOIN productos p ON dv.producto_id = p.id_serial
WHERE DATE_PART('month', v.fecha) = 10 AND DATE_PART('year', v.fecha) = 2024;

--  Cliente con más compras realizadas
SELECT c.id_serial, c.nombre, COUNT(v.id_serial) AS total_compras
FROM clientes c
JOIN ventas v ON c.id_serial = v.cliente_id
GROUP BY c.id_serial
ORDER BY total_compras DESC
LIMIT 1;

--  Top 5 productos más vendidos
SELECT p.id_serial, p.nombre, SUM(dv.cantidad) AS total_vendido
FROM productos p
JOIN ventas_detalle dv ON p.id_serial = dv.producto_id
GROUP BY p.id_serial
ORDER BY total_vendido DESC
LIMIT 5;

--  Ventas realizadas en un rango de fechas
SELECT v.id_serial as venta , v.cliente_id as id_cliente , v.fecha
FROM ventas v
WHERE fecha BETWEEN '2024-10-01' AND '2024-10-29';

--  Clientes que no han comprado en los últimos 6 meses
SELECT *
FROM clientes
WHERE id_serial NOT IN (
    SELECT DISTINCT cliente_id
    FROM ventas
    WHERE fecha >= CURRENT_DATE - INTERVAL '6 months'
);