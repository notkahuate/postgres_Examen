
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