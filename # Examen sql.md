# # Examen sql 

# 0. MODELO ENTIDAD RELACION



![Captura desde 2025-04-11 08-42-58](/home/camper/Imágenes/Capturas de pantalla/Captura desde 2025-04-11 08-42-58.png)



-- ==============================

# 1. ESTRUCTURA DE LA BASE DE DATOS (db.sql)

-- ==============================

```sql
CREATE DATABASE Techzone;

\c Techzone


CREATE TABLE categorias (
    id_serial SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE proveedores (
    id_serial SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    correo VARCHAR(50),
    telefono VARCHAR(20)
);


CREATE TABLE productos (
    id_serial SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
    categoria_id INT REFERENCES categorias(id_serial)
);


CREATE TABLE producto_proveedores(
    id_producto INT REFERENCES productos(id_serial),
    id_proveedores INT  REFERENCES proveedores(id_serial),
    primary key (id_producto,id_proveedores)
);

CREATE TABLE stock (
    id_serial SERIAL PRIMARY KEY,
    cantidad INT not null,
    fecha_actualizacion date,
    id_producto INT REFERENCES productos(id_serial) 
);


CREATE TABLE clientes (
    id_serial SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    correo VARCHAR(50) UNIQUE,
    telefono VARCHAR(20)
);


CREATE TABLE ventas (
    id_serial SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id_serial),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ventas_detalle (
    id_serial SERIAL PRIMARY KEY,
    venta_id INT REFERENCES ventas(id_serial) ON DELETE CASCADE,
    producto_id INT REFERENCES productos(id_serial),
    cantidad INT NOT NULL CHECK (cantidad > 0)
);
```



-- ==============================
# 2. INSERCIÓN DE DATOS (insert.sql)
-- ==============================

```sql

INSERT INTO categorias (nombre) VALUES 
('Laptops'), ('Teléfonos'), ('Accesorios'), ('Componentes');


INSERT INTO proveedores (nombre, correo, telefono) VALUES
('TechGlobal', 'ventas@techglobal.com', '3124567890'),
('ElectroWorld', 'contacto@electroworld.com', '3106543210'),
('CompuPartes', 'info@compupartes.com', '3112233445');


INSERT INTO productos (nombre, precio, categoria_id) VALUES
('Laptop Lenovo i5', 2500000,  1),
('Laptop HP Ryzen 7', 3200000, 1),
('iPhone 13', 4500000, 2),
('Samsung Galaxy S21', 3800000, 2),
('Cargador USB-C', 80000, 3),
('Teclado mecánico', 200000, 3),
('Mouse inalámbrico', 120000, 3),
('RAM 8GB DDR4', 180000,4),
('Disco SSD 1TB', 450000, 4),
('Procesador Intel i7', 950000, 4),
('Case ATX', 220000, 4),
('Power Bank 20000mAh', 120000, 3),
('Audífonos Bluetooth', 150000, 3),
('Pantalla LED 24"', 480000, 3),
('Cámara Web HD', 110000, 3);
INSERT INTO producto_proveedores(id_producto, id_proveedores) VALUES 
(1,1),(2,1),(3,2),(4,2);


INSERT INTO clientes (nombre, correo, telefono) VALUES
('Juan Pérez', 'juanp@gmail.com', '3001234567'),
('María López', 'marial@gmail.com', '3017654321'),
('Carlos Rojas', 'carlosr@gmail.com', '3023456789'),
('Ana Torres', 'ana.torres@gmail.com', '3009876543'),
('Luis Gómez', 'luisgomez@gmail.com', '3111111111'),
('Laura Méndez', 'lauram@gmail.com', '3122222222'),
('Pedro Martínez', 'pedrom@gmail.com', '3133333333'),
('Daniela Ruiz', 'danielar@gmail.com', '3144444444'),
('Santiago Díaz', 'santiagod@gmail.com', '3155555555'),
('Valentina Mora', 'valen.mora@gmail.com', '3166666666'),
('Esteban Gil', 'estebangil@gmail.com', '3177777777'),
('Camila Ríos', 'camilarios@gmail.com', '3188888888'),
('Mateo Vélez', 'mateov@gmail.com', '3199999999'),
('Lucía Herrera', 'luciah@gmail.com', '3200000000'),
('Andrés Silva', 'andress@gmail.com', '3211111111');

INSERT INTO stock (cantidad, id_producto, fecha_actualizacion) VALUES 
(20,1,'2024-09-02'),(3,2,'2024-11-02'),(35,3,'2024-12-02'),
(15,5,'2024-02-02');


INSERT INTO ventas (cliente_id, fecha) VALUES
(1, '2024-10-01'), (2, '2024-10-02'), (3, '2024-10-02'),
(1, '2024-10-05'), (4, '2024-11-01'), (5, '2024-11-03');

INSERT INTO ventas_detalle (venta_id, producto_id, cantidad) VALUES
(1, 1, 1), (1, 5, 2),
(2, 2, 1),
(3, 4, 1),
(4, 3, 1), (4, 7, 2),
(5, 6, 1), (5, 9, 1),
(6, 8, 2), (6, 14, 1);
```



-- ==============================
# 3. CONSULTAS SQL AVANZADAS (queries.sql)
-- ==============================



```sql

--  Productos con stock menor a 5 unidades
SELECT p.id_serial, p.nombre, s.cantidad
FROM productos p
JOIN stock s ON p.id_serial = s.id_producto
WHERE s.cantidad < 5;

-- 2️⃣ Ventas totales de un mes específico (Ej: marzo 2025)
SELECT SUM(dv.cantidad * p.precio) AS total_ventas
FROM ventas v
JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
JOIN productos p ON dv.id_producto = p.id_producto
WHERE DATE_PART('month', v.fecha) = 3 AND DATE_PART('year', v.fecha) = 2025;

-- 3️⃣ Cliente con más compras realizadas
SELECT c.id_cliente, c.nombre_cliente, COUNT(v.id_venta) AS total_compras
FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente
ORDER BY total_compras DESC
LIMIT 1;

-- 4️⃣ Top 5 productos más vendidos
SELECT p.id_producto, p.nombre_producto, SUM(dv.cantidad) AS total_vendido
FROM productos p
JOIN detalle_ventas dv ON p.id_producto = dv.id_producto
GROUP BY p.id_producto
ORDER BY total_vendido DESC
LIMIT 5;

-- 5️⃣ Ventas realizadas en un rango de fechas
SELECT *
FROM ventas
WHERE fecha BETWEEN '2025-03-01' AND '2025-03-03';

-- 6️⃣ Clientes que no han comprado en los últimos 6 meses
SELECT *
FROM clientes
WHERE id_cliente NOT IN (
    SELECT DISTINCT id_cliente
    FROM ventas
    WHERE fecha >= CURRENT_DATE - INTERVAL '6 months'
);
```

 

```
SELECT DATE(v.fecha) AS fecha, COUNT(*) AS total_ventas
FROM ventas v
GROUP BY DATE(v.fecha)
ORDER BY fecha;

SELECT cat.nombre AS categoria, SUM(vd.cantidad) AS total_vendidos
FROM ventas_detalle vd
JOIN productos p ON vd.producto_id = p.id_serial
JOIN categorias cat ON p.categoria_id = cat.id_serial
GROUP BY cat.nombre
ORDER BY total_vendidos DESC;

SELECT p.nombre, s.cantidad
FROM stock s
JOIN productos p ON s.id_producto = p.id_serial
WHERE s.cantidad < 5
ORDER BY s.cantidad ASC;

SELECT c.nombre, COUNT(v.id_serial) AS cantidad_compras
FROM clientes c
JOIN ventas v ON c.id_serial = v.cliente_id
GROUP BY c.nombre
ORDER BY cantidad_compras DESC;


CREATE OR REPLACE FUNCTION validar_stock_y_insertar_detalle(
    p_venta_id INT,
    p_producto_id INT,
    p_cantidad INT
)
RETURNS TEXT AS $$
DECLARE
    stock_actual INT;
BEGIN
    SELECT s.cantidad INTO stock_actual
    FROM stock s
    WHERE s.id_producto = p_producto_id;

    IF stock_actual IS NULL THEN
        RETURN '❌ No existe stock registrado para este producto.';
    ELSIF stock_actual < p_cantidad THEN
        RETURN '❌ Stock insuficiente.';
    ELSE
        -- Insertar en ventas_detalle
        INSERT INTO ventas_detalle (venta_id, producto_id, cantidad)
        VALUES (p_venta_id, p_producto_id, p_cantidad);

        -- Actualizar el stock
        UPDATE stock
        SET cantidad = cantidad - p_cantidad,
            fecha_actualizacion = CURRENT_DATE
        WHERE id_producto = p_producto_id;

        RETURN '✅ Venta registrada y stock actualizado.';
    END IF;
END;
$$ LANGUAGE plpgsql;

```

