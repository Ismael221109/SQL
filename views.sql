CREATE OR REPLACE VIEW vw_vehiculos_propietarios AS
SELECT v.placa, v.marca, v.modelo, p.nombres, p.apellidos, p.documento
FROM vehiculos v
INNER JOIN propietarios p ON v.id_propietario = p.id_propietario;

CREATE OR REPLACE VIEW vw_detalle_ingresos_completo AS
SELECT i.id_ingreso, p.nombre AS parqueadero, e.codigo AS espacio, tv.descripcion AS tipo_vehiculo, v.placa, i.valor
FROM ingresos i
INNER JOIN espacios e ON i.id_espacio = e.id_espacio
INNER JOIN parqueaderos p ON e.id_parqueadero = p.id_parqueadero
INNER JOIN vehiculos v ON i.id_vehiculo = v.id_vehiculo
INNER JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo;

CREATE OR REPLACE VIEW vw_reporte_ingresos_empleados AS
SELECT i.id_ingreso, v.placa, CONCAT(emp.nombres, ' ', emp.apellidos) AS empleado_atiende, i.fecha_hora_salida
FROM ingresos i
INNER JOIN vehiculos v ON i.id_vehiculo = v.id_vehiculo
INNER JOIN empleados emp ON i.id_empleado = emp.id_empleado;

CREATE OR REPLACE VIEW vw_ingresos_pagos_estados AS
SELECT i.id_ingreso, ei.descripcion AS estado, mp.descripcion AS metodo_pago, i.valor
FROM ingresos i
INNER JOIN estados_ingresos ei ON i.id_estado = ei.id_estado
INNER JOIN metodos_pago mp ON i.id_pago = mp.id_pago;

CREATE OR REPLACE VIEW vw_propietarios_y_vehiculos AS
SELECT p.nombres, p.apellidos, v.placa, v.marca
FROM propietarios p
LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario;

CREATE OR REPLACE VIEW vw_estado_espacios_ingresos AS
SELECT e.codigo, e.nivel, i.id_ingreso, i.fecha_hora_ingreso
FROM espacios e
LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio;

CREATE OR REPLACE VIEW vw_tarifas_y_aplicacion AS
SELECT t.descripcion AS tarifa, t.valor_hora, i.id_ingreso, i.valor
FROM tarifas t
LEFT JOIN ingresos i ON t.id_tarifa = i.id_tarifa;

CREATE OR REPLACE VIEW vw_tipos_vehiculo_asociados AS
SELECT tv.descripcion AS tipo_vehiculo, v.placa, v.marca
FROM tipos_vehiculo tv
LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo;

CREATE OR REPLACE VIEW vw_empleados_gestion_ingresos AS
SELECT CONCAT(emp.nombres, ' ', emp.apellidos) AS empleado, i.id_ingreso
FROM empleados emp
LEFT JOIN ingresos i ON emp.id_empleado = i.id_empleado;

CREATE OR REPLACE VIEW vw_parqueaderos_y_espacios AS
SELECT p.nombre AS parqueadero, e.codigo AS espacio, e.nivel
FROM parqueaderos p
LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero;

CREATE OR REPLACE VIEW vw_metodos_pago_ingresos AS
SELECT mp.descripcion AS metodo_pago, i.id_ingreso, i.valor
FROM metodos_pago mp
LEFT JOIN ingresos i ON mp.id_pago = i.id_pago;

CREATE OR REPLACE VIEW vw_vehiculos_propietarios_derecha AS
SELECT p.nombres, p.apellidos, v.placa, v.marca
FROM propietarios p
RIGHT JOIN vehiculos v ON p.id_propietario = v.id_propietario;

CREATE OR REPLACE VIEW vw_ingresos_metodos_pago AS
SELECT i.id_ingreso, mp.descripcion AS metodo_pago, i.valor
FROM ingresos i
RIGHT JOIN metodos_pago mp ON i.id_pago = mp.id_pago;

CREATE OR REPLACE VIEW vw_ingresos_tarifas_cruce AS
SELECT t.descripcion AS tarifa, i.id_ingreso, i.valor
FROM ingresos i
RIGHT JOIN tarifas t ON i.id_tarifa = t.id_tarifa;

CREATE OR REPLACE VIEW vw_ingresos_espacios_derecha AS
SELECT i.id_ingreso, e.codigo AS espacio
FROM ingresos i
RIGHT JOIN espacios e ON e.id_espacio = i.id_espacio;

CREATE OR REPLACE VIEW vw_ingresos_estados_derecha AS
SELECT i.id_ingreso, ei.descripcion AS estado
FROM ingresos i
RIGHT JOIN estados_ingresos ei ON i.id_estado = ei.id_estado;

CREATE OR REPLACE VIEW vw_ingresos_empleados_derecha AS
SELECT i.id_ingreso, CONCAT(emp.nombres, ' ', emp.apellidos) AS empleado
FROM ingresos i
RIGHT JOIN empleados emp ON i.id_empleado = emp.id_empleado;

CREATE OR REPLACE VIEW vw_propietarios_vehiculos_full AS
SELECT p.nombres, p.apellidos, v.placa, v.marca FROM propietarios p LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario
UNION
SELECT p.nombres, p.apellidos, v.placa, v.marca FROM propietarios p RIGHT JOIN vehiculos v ON p.id_propietario = v.id_propietario;

CREATE OR REPLACE VIEW vw_espacios_ingresos_full AS
SELECT e.codigo, i.id_ingreso, i.fecha_hora_ingreso FROM espacios e LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio
UNION
SELECT e.codigo, i.id_ingreso, i.fecha_hora_ingreso FROM espacios e RIGHT JOIN ingresos i ON e.id_espacio = i.id_espacio;

CREATE OR REPLACE VIEW vw_parqueaderos_espacios_full AS
SELECT p.nombre AS parqueadero, e.codigo AS espacio FROM parqueaderos p LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero
UNION
SELECT p.nombre AS parqueadero, e.codigo AS espacio FROM parqueaderos p RIGHT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero;

CREATE OR REPLACE VIEW vw_tarifas_ingresos_full AS
SELECT t.descripcion AS tarifa, i.id_ingreso FROM tarifas t LEFT JOIN ingresos i ON t.id_tarifa = i.id_tarifa
UNION
SELECT t.descripcion AS tarifa, i.id_ingreso FROM tarifas t RIGHT JOIN ingresos i ON t.id_tarifa = i.id_tarifa;

CREATE OR REPLACE VIEW vw_tipos_vehiculos_full AS
SELECT tv.descripcion AS tipo, v.placa FROM tipos_vehiculo tv LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo
UNION
SELECT tv.descripcion AS tipo, v.placa FROM tipos_vehiculo tv RIGHT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo;

DELIMITER //

CREATE PROCEDURE sp_auditar_propietarios_sin_vehiculos()
BEGIN
    SELECT p.id_propietario, p.nombres, p.apellidos, p.documento
    FROM propietarios p LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario WHERE v.id_vehiculo IS NULL;
END //

CREATE PROCEDURE sp_auditar_espacios_no_utilizados()
BEGIN
    SELECT e.id_espacio, e.codigo, e.nivel
    FROM espacios e LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_auditar_vehiculos_sin_ingreso()
BEGIN
    SELECT v.id_vehiculo, v.placa, v.marca
    FROM vehiculos v LEFT JOIN ingresos i ON v.id_vehiculo = i.id_vehiculo WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_auditar_empleados_sin_ingresos()
BEGIN
    SELECT emp.id_empleado, emp.nombres, emp.apellidos
    FROM empleados emp LEFT JOIN ingresos i ON emp.id_empleado = i.id_empleado WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_auditar_parqueaderos_sin_espacios()
BEGIN
    SELECT p.id_parqueadero, p.nombre, p.direccion
    FROM parqueaderos p LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero WHERE e.id_espacio IS NULL;
END //

CREATE PROCEDURE sp_auditar_tipos_vehiculo_huerfanos()
BEGIN
    SELECT tv.id_tipo_vehiculo, tv.descripcion
    FROM tipos_vehiculo tv LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo WHERE v.id_vehiculo IS NULL;
END //

CREATE PROCEDURE sp_auditar_tarifas_inactivas()
BEGIN
    SELECT t.id_tarifa, t.descripcion, t.valor_hora
    FROM ingresos i RIGHT JOIN tarifas t ON i.id_tarifa = t.id_tarifa WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_auditar_estados_ingreso_no_usados()
BEGIN
    SELECT ei.id_estado, ei.descripcion
    FROM ingresos i RIGHT JOIN estados_ingresos ei ON i.id_estado = ei.id_estado WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_auditar_metodos_pago_inactivos()
BEGIN
    SELECT mp.id_pago, mp.descripcion
    FROM ingresos i RIGHT JOIN metodos_pago mp ON i.id_pago = mp.id_pago WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_auditar_empleados_sin_actividad()
BEGIN
    SELECT emp.id_empleado, emp.nombres, emp.apellidos
    FROM ingresos i RIGHT JOIN empleados emp ON i.id_empleado = emp.id_empleado WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_auditar_tipos_vehiculo_sin_mapa()
BEGIN
    SELECT tv.id_tipo_vehiculo, tv.descripcion
    FROM vehiculos v RIGHT JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo WHERE v.id_vehiculo IS NULL;
END //

CREATE PROCEDURE sp_exclusivos_propietarios_vehiculos()
BEGIN
    SELECT p.nombres, p.apellidos, v.placa FROM propietarios p LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario WHERE v.id_vehiculo IS NULL
    UNION
    SELECT p.nombres, p.apellidos, v.placa FROM propietarios p RIGHT JOIN vehiculos v ON p.id_propietario = v.id_propietario WHERE p.id_propietario IS NULL;
END //

CREATE PROCEDURE sp_exclusivos_parqueaderos_espacios()
BEGIN
    SELECT p.nombre, e.codigo FROM parqueaderos p LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero WHERE e.id_espacio IS NULL
    UNION
    SELECT p.nombre, e.codigo FROM parqueaderos p RIGHT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero WHERE p.id_parqueadero IS NULL;
END //

CREATE PROCEDURE sp_exclusivos_tipos_vehiculos()
BEGIN
    SELECT tv.descripcion, v.placa FROM tipos_vehiculo tv LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo WHERE v.id_vehiculo IS NULL
    UNION
    SELECT tv.descripcion, v.placa FROM tipos_vehiculo tv RIGHT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo WHERE tv.id_tipo_vehiculo IS NULL;
END //

CREATE PROCEDURE sp_exclusivos_tarifas_ingresos()
BEGIN
    SELECT t.descripcion, i.id_ingreso FROM tarifas t LEFT JOIN ingresos i ON t.id_tarifa = i.id_tarifa WHERE i.id_ingreso IS NULL
    UNION
    SELECT t_d.descripcion, i.id_ingreso FROM ingresos i RIGHT JOIN tarifas t_d ON i.id_tarifa = t_d.id_tarifa WHERE i.id_ingreso IS NULL;
END //

CREATE PROCEDURE sp_exclusivos_espacios_ingresos()
BEGIN
    SELECT e.codigo, i.id_ingreso FROM espacios e LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio WHERE i.id_ingreso IS NULL
    UNION
    SELECT e.codigo, i.id_ingreso FROM espacios e RIGHT JOIN ingresos i ON e.id_espacio = i.id_espacio WHERE e.id_espacio IS NULL;
END //

CREATE PROCEDURE sp_registrar_propietario_acid(
    IN p_nombres VARCHAR(50),
    IN p_apellidos VARCHAR(50),
    IN p_documento VARCHAR(20),
    IN p_telefono VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en la transacción. ROLLBACK aplicado.' AS mensaje;
    END;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM propietarios WHERE documento = p_documento) THEN
        ROLLBACK;
        SELECT 'Error: El documento del propietario ya existe.' AS mensaje;
    ELSE
        INSERT INTO propietarios (nombres, apellidos, documento, telefono)
        VALUES (p_nombres, p_apellidos, p_documento, p_telefono);

        COMMIT;
        SELECT 'Propietario registrado exitosamente.' AS mensaje;
    END IF;
END //

CREATE PROCEDURE sp_registrar_vehiculo_acid(
    IN p_placa VARCHAR(10),
    IN p_marca VARCHAR(30),
    IN p_modelo VARCHAR(30),
    IN p_id_propietario INT,
    IN p_id_tipo_vehiculo INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en la transacción. ROLLBACK aplicado.' AS mensaje;
    END;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM vehiculos WHERE placa = p_placa) THEN
        ROLLBACK;
        SELECT 'Error: La placa del vehículo ya está registrada.' AS mensaje;
    ELSE
        INSERT INTO vehiculos (placa, marca, modelo, id_propietario, id_tipo_vehiculo)
        VALUES (p_placa, p_marca, p_modelo, p_id_propietario, p_id_tipo_vehiculo);

        COMMIT;
        SELECT 'Vehículo registrado exitosamente.' AS mensaje;
    END IF;
END //

CREATE PROCEDURE sp_registrar_ingreso_con_acid(
    IN p_id_vehiculo INT,
    IN p_id_espacio INT,
    IN p_id_empleado INT,
    IN p_id_tarifa INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error crítico en la transacción. Se aplicó un ROLLBACK.' AS mensaje;
    END;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    START TRANSACTION;

    IF EXISTS (SELECT 1 FROM ingresos WHERE id_espacio = p_id_espacio AND fecha_hora_salida IS NULL) THEN
        ROLLBACK;
        SELECT 'Error: El espacio de parqueo ya se encuentra ocupado.' AS mensaje;
    ELSE
        INSERT INTO ingresos (id_vehiculo, id_espacio, id_empleado, id_tarifa, id_estado, fecha_hora_ingreso, valor)
        VALUES (p_id_vehiculo, p_id_espacio, p_id_empleado, p_id_tarifa, 1, NOW(), 0.00);

        COMMIT;
        SELECT 'Ingreso registrado exitosamente y confirmado con COMMIT.' AS mensaje;
    END IF;
END //

CREATE PROCEDURE sp_registrar_salida_con_acid(
    IN p_id_ingreso INT,
    IN p_id_pago INT,
    IN p_valor DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error crítico en la transacción. Se aplicó un ROLLBACK.' AS mensaje;
    END;

    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

    START TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM ingresos WHERE id_ingreso = p_id_ingreso AND fecha_hora_salida IS NULL) THEN
        ROLLBACK;
        SELECT 'Error: El ingreso no existe o ya fue cerrado.' AS mensaje;
    ELSE
        UPDATE ingresos 
        SET fecha_hora_salida = NOW(), id_pago = p_id_pago, valor = p_valor, id_estado = 2 
        WHERE id_ingreso = p_id_ingreso;

        COMMIT;
        SELECT 'Salida registrada exitosamente y confirmada con COMMIT.' AS mensaje;
    END IF;
END //

DELIMITER ;
