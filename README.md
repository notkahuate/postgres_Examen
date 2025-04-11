# # Examen sql 



-- ==============================

# DESCRIPCION

-- ==============================

El presente proyecto consiste en el diseño e implementación de una base de datos relacional para **TechZone**, una tienda tecnológica dedicada a la venta de productos electrónicos. El sistema ha sido desarrollado bajo los principios de la **normalización (hasta 3FN)** con el fin de garantizar la integridad, eficiencia y escalabilidad de los datos. El modelo contempla todas las entidades clave para la gestión comercial de la tienda 

Además, se incorporan procedimientos almacenados que permiten automatizar y controlar el proceso de venta, garantizando que haya stock suficiente antes de confirmar la transacción. Todo esto se complementa con consultas SQL avanzadas para generar reportes, monitorear ventas, y analizar el comportamiento de los clientes.



# 0. MODELO ENTIDAD RELACION



![Captura desde 2025-04-11 08-42-58](/home/camper/Imágenes/Capturas de pantalla/Captura desde 2025-04-11 08-42-58.png)



-- ==============================

# 1. ESTRUCTURA DE LA BASE DE DATOS

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
# 2. INSERCIÓN DE DATOS 
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
# 3. CONSULTAS SQL AVANZADAS 
-- ==============================



```sql

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
```

 -- ==============================

# 4. PRODECIMIENTO ADECUADO	

-- ==============================



```sql
-- Crea la venta y devuelve el ID generado.

 CREATE OR REPLACE FUNCTION crear_venta(p_id_cliente INT)
RETURNS INT AS $$
DECLARE
    v_id_venta INT;
BEGIN
    INSERT INTO ventas(cliente_id) VALUES (p_id_cliente)
    RETURNING id_serial INTO v_id_venta;
    RETURN v_id_venta;
END;
$$ LANGUAGE plpgsql;


-- Valida si hay suficiente stock. Si no, lanza una excepción.

 CREATE OR REPLACE PROCEDURE verificar_stock(p_id_producto INT, p_cantidad INT)
AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT cantidad INTO v_stock FROM stock WHERE id_producto = p_id_producto;

    IF v_stock IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado en stock.';
    END IF;

    IF v_stock < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto %', p_id_producto;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Agrega un producto al detalle de la venta.

 CREATE OR REPLACE PROCEDURE insertar_detalle_venta(p_id_venta INT, p_id_producto INT, p_cantidad INT)
AS $$
BEGIN
    INSERT INTO ventas_detalle(venta_id, producto_id, cantidad)
    VALUES (p_id_venta, p_id_producto, p_cantidad);
END;
$$ LANGUAGE plpgsql;


-- Resta del stock la cantidad vendida y actualiza la fecha.

CREATE OR REPLACE PROCEDURE actualizar_stock(p_id_producto INT, p_cantidad INT)
AS $$
BEGIN
    UPDATE stock
    SET cantidad = cantidad - p_cantidad,
        fecha_actualizacion = CURRENT_DATE
    WHERE id_producto = p_id_producto;
END;
$$ LANGUAGE plpgsql;


```

