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


DELIMITER //

DROP PROCEDURE IF EXISTS sp_auditar_propietarios_sin_vehiculos //
CREATE PROCEDURE sp_auditar_propietarios_sin_vehiculos()
BEGIN
    SELECT p.id_propietario, p.nombres, p.apellidos, p.documento
    FROM propietarios p LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario WHERE v.id_vehiculo IS NULL;
END //

DROP PROCEDURE IF EXISTS sp_auditar_espacios_no_utilizados //
CREATE PROCEDURE sp_auditar_espacios_no_utilizados()
BEGIN
    SELECT e.id_espacio, e.codigo, e.nivel
    FROM espacios e LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio WHERE i.id_ingreso IS NULL;
END //


DROP PROCEDURE IF EXISTS sp_registrar_ingreso_con_acid //
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
        SELECT 'Error crítico en la transacción. Se aplicó un ROLLBACK y no se guardaron cambios.' AS mensaje;
    END;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM ingresos WHERE id_espacio = p_id_espacio AND fecha_hora_salida IS NULL) THEN
    
        ROLLBACK;
        SELECT 'Error de Consistencia: El espacio de parqueo ya se encuentra ocupado.' AS mensaje;
    ELSE

        INSERT INTO ingresos (id_vehiculo, id_espacio, id_empleado, id_tarifa, id_estado, fecha_hora_ingreso, valor)
        VALUES (p_id_vehiculo, p_id_espacio, p_id_empleado, p_id_tarifa, 1, NOW(), 0.00);

        COMMIT;
        SELECT 'Ingreso registrado exitosamente y confirmado con COMMIT.' AS mensaje;
    END IF;

END //

DELIMITER ;