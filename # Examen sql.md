# # Examen sql 

-- ==============================

# 1. ESTRUCTURA DE LA BASE DE DATOS (db.sql)

-- ==============================

```sql
CREATE DATABASE Techzone;

\c Techzone


CREATE TABLE categorias (
    id_serial INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE proveedores (
    id_serial INT  PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    telefono VARCHAR(20)
);


CREATE TABLE productos (
    id_serial INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    categoria_id INT REFERENCES categorias(id_serial)
);


CREATE TABLE producto_proveedores(
    id_producto INT REFERENCES productos(id_serial),
    id_proveedores INT  REFERENCES proveedores(id_serial),
    primary key (id_producto,id_proveedores)
);

CREATE TABLE stock (
    id_serial INT PRIMARY KEY,
    cantidad INT not null,
    fecha_actualizacion date,
    id_producto INT REFERENCES productos(id_serial) 
);


CREATE TABLE clientes (
    id_serial INT  PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    telefono VARCHAR(20)
);


CREATE TABLE ventas (
    iid_serial INT PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ventas_detalle (
    id_serial INT PRIMARY KEY,
    venta_id INT REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id INT REFERENCES productos(id),
    cantidad INT NOT NULL CHECK (cantidad > 0)
);
```



-- ==============================
-- 2. INSERCIÓN DE DATOS (insert.sql)
-- ==============================

```sql
-- Categorías
INSERT INTO categorias (nombre) VALUES 
('Laptops'), ('Teléfonos'), ('Accesorios'), ('Componentes');

-- Proveedores
INSERT INTO proveedores (nombre, correo, telefono) VALUES
('TechGlobal', 'ventas@techglobal.com', '3124567890'),
('ElectroWorld', 'contacto@electroworld.com', '3106543210'),
('CompuPartes', 'info@compupartes.com', '3112233445');

-- Productos
INSERT INTO productos (nombre, precio, stock, categoria_id) VALUES
('Laptop Lenovo i5', 2500000, 10, 1),
('Laptop HP Ryzen 7', 3200000, 3, 1),
('iPhone 13', 4500000, 2, 2),
('Samsung Galaxy S21', 3800000, 7, 2),
('Cargador USB-C', 80000, 25, 3),
('Teclado mecánico', 200000, 4, 3),
('Mouse inalámbrico', 120000, 15, 3),
('RAM 8GB DDR4', 180000, 6, 4),
('Disco SSD 1TB', 450000, 3, 4),
('Procesador Intel i7', 950000, 1, 4),
('Case ATX', 220000, 9, 4),
('Power Bank 20000mAh', 120000, 18, 3),
('Audífonos Bluetooth', 150000, 5, 3),
('Pantalla LED 24"', 480000, 2, 3),
('Cámara Web HD', 110000, 4, 3);
INSERT INTO producto_proveedores(id_producto, id_proveedores) VALUES 
(),(),(),()

-- Clientes
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
(20,1,'2024-09-02'),(50,2,'2024-11-02'),(35,3,'2024-12-02'),
(15,5,'2024-02-02');

-- Ventas y detalles
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
-- 3. CONSULTAS SQL AVANZADAS (queries.sql)
-- ==============================



```sql
-- 1️⃣ Productos con stock menor a 5
SELECT nombre, stock FROM productos WHERE stock < 5;

-- 2️⃣ Ventas totales de octubre 2024
SELECT SUM(p.precio * vd.cantidad) AS total_ventas_octubre
FROM ventas v
JOIN ventas_detalle vd ON v.id = vd.venta_id
JOIN productos p ON vd.producto_id = p.id
WHERE EXTRACT(MONTH FROM v.fecha) = 10 AND EXTRACT(YEAR FROM v.fecha) = 2024;

-- 3️⃣ Cliente con más compras
SELECT c.nombre, COUNT(v.id) AS total_compras
FROM clientes c
JOIN ventas v ON c.id = v.cliente_id
GROUP BY c.nombre
ORDER BY total_compras DESC
LIMIT 1;

-- 4️⃣ Los 5 productos más vendidos
SELECT p.nombre, SUM(vd.cantidad) AS
```

