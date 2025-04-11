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