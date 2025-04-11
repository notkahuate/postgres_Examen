CREATE DATABASE techzone;

\c techzone


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