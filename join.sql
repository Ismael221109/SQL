-- 1. Listar vehículos junto con los datos de sus propietarios
SELECT v.placa, v.marca, v.modelo, p.nombres, p.apellidos, p.documento
FROM vehiculos v
INNER JOIN propietarios p ON v.id_propietario = p.id_propietario; 


 -- 2. Consultar ingresos indicando espacio y parqueadero
SELECT i.id_ingreso, p.nombre AS parqueadero, e.codigo AS espacio, i.fecha_hora_ingreso
FROM ingresos i
INNER JOIN espacios e ON i.id_espacio = e.id_espacio
INNER JOIN parqueaderos p ON e.id_parqueadero = p.id_parqueadero; 


 -- 3. Detalles de ingreso incluyendo placa y tipo de vehículo
SELECT i.id_ingreso, v.placa, tv.descripcion AS tipo_vehiculo, i.valor
FROM ingresos i
INNER JOIN vehiculos v ON i.id_vehiculo = v.id_vehiculo
INNER JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo;  


-- 4. Reporte de ingresos relacionando el empleado que atendió
SELECT i.id_ingreso, v.placa, CONCAT(emp.nombres, ' ', emp.apellidos) AS empleado_atiende, i.fecha_hora_salida
FROM ingresos i
INNER JOIN vehiculos v ON i.id_vehiculo = v.id_vehiculo
INNER JOIN empleados emp ON i.id_empleado = emp.id_empleado;  


-- 5. Ingresos con estado de ingreso y método de pago
SELECT i.id_ingreso, ei.descripcion AS estado, mp.descripcion AS metodo_pago, i.valor
FROM ingresos i
INNER JOIN estados_ingresos ei ON i.id_estado = ei.id_estado
INNER JOIN metodos_pago mp ON i.id_pago = mp.id_pago;  


-- 6. Listar los espacios ocupados actualmente junto con el nombre del parqueadero
SELECT e.codigo, e.nivel, p.nombre AS parqueadero
FROM espacios e
INNER JOIN parqueaderos p ON e.id_parqueadero = p.id_parqueadero
INNER JOIN ingresos i ON e.id_espacio = i.id_espacio
WHERE i.fecha_hora_salida IS NULL;  


-- 7. Mostrar los vehículos con su respectivo tipo de vehículo y la marca registrada
SELECT v.placa, tv.descripcion AS tipo, v.marca, v.modelo
FROM vehiculos v
INNER JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo;  

/*LEFT JOIN (Tabla A + Intersección)
*/-- 8. Todos los propietarios y sus vehículos (incluye sin vehículo)

SELECT p.nombres, p.apellidos, v.placa, v.marca
FROM propietarios p
LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario;  


-- 9. Todos los espacios y el estado de sus ingresos
SELECT e.codigo, e.nivel, i.id_ingreso, i.fecha_hora_ingreso
FROM espacios e
LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio;  


-- 10. Todas las tarifas registradas y los ingresos que las aplicaron
SELECT t.descripcion AS tarifa, t.valor_hora, i.id_ingreso, i.valor
FROM tarifas t
LEFT JOIN ingresos i ON t.id_tarifa = i.id_tarifa;  


-- 11. Todos los tipos de vehículos y vehículos asociados
SELECT tv.descripcion AS tipo_vehiculo, v.placa, v.marca
FROM tipos_vehiculo tv
LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo; 


 -- 12. Todos los empleados y los ingresos gestionados
SELECT CONCAT(emp.nombres, ' ', emp.apellidos) AS empleado, i.id_ingreso
FROM empleados emp
LEFT JOIN ingresos i ON emp.id_empleado = i.id_empleado;  


-- 13. Listar todos los parqueaderos y los espacios configurados en ellos
SELECT p.nombre AS parqueadero, e.codigo AS espacio, e.nivel
FROM parqueaderos p
LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero;  


-- 14. Listar todos los métodos de pago y los ingresos asociados a cada uno
SELECT mp.descripcion AS metodo_pago, i.id_ingreso, i.valor
FROM metodos_pago mp
LEFT JOIN ingresos i ON mp.id_pago = i.id_pago; 


/* RIGHT JOIN (Tabla B + Intersección)
 */-- 15. Todos los vehículos y datos de sus propietarios (priorizando vehículos)
SELECT p.nombres, p.apellidos, v.placa, v.marca
FROM propietarios p
RIGHT JOIN vehiculos v ON p.id_propietario = v.id_propietario;  


-- 16. Todos los ingresos cruzados con métodos de pago (priorizando métodos de pago)
SELECT i.id_ingreso, mp.descripcion AS metodo_pago, i.valor
FROM ingresos i
RIGHT JOIN metodos_pago mp ON i.id_pago = mp.id_pago;  


-- 17. Listar todos los ingresos registrados y su tarifa correspondiente
SELECT t.descripcion AS tarifa, i.id_ingreso, i.valor
FROM ingresos i
RIGHT JOIN tarifas t ON i.id_tarifa = t.id_tarifa;  


-- 18. Listar todos los espacios y sus respectivos ingresos registrados
SELECT i.id_ingreso, e.codigo AS espacio
FROM ingresos i
RIGHT JOIN espacios e ON i.id_espacio = e.id_espacio;  


-- 19. Listar todos los estados de ingreso y los registros asociados
SELECT i.id_ingreso, ei.descripcion AS estado
FROM ingresos i
RIGHT JOIN estados_ingresos ei ON i.id_estado = ei.id_estado;  


-- 20. Relacionar todos los empleados con los ingresos atendidos (desde empleados)
SELECT i.id_ingreso, CONCAT(emp.nombres, ' ', emp.apellidos) AS empleado
FROM ingresos i
RIGHT JOIN empleados emp ON i.id_empleado = emp.id_empleado;  


/* ==========================================LEFT JOIN EXCLUDING (A - B)========================================== */-- 21. Propietarios que NO tienen ningún vehículo registrado
SELECT p.id_propietario, p.nombres, p.apellidos, p.documento
FROM propietarios p
LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario
WHERE v.id_vehiculo IS NULL;  


-- 22. Espacios de parqueo que NUNCA han sido utilizados
SELECT e.id_espacio, e.codigo, e.nivel
FROM espacios e
LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio
WHERE i.id_ingreso IS NULL;  


-- 23. Vehículos que NUNCA han registrado un ingreso
SELECT v.id_vehiculo, v.placa, v.marca
FROM vehiculos v
LEFT JOIN ingresos i ON v.id_vehiculo = i.id_vehiculo
WHERE i.id_ingreso IS NULL;  


-- 24. Empleados que no han registrado ningún ingreso
SELECT emp.id_empleado, emp.nombres, emp.apellidos
FROM empleados emp
LEFT JOIN ingresos i ON emp.id_empleado = i.id_empleado
WHERE i.id_ingreso IS NULL;  


-- 25. Parqueaderos que no tienen ningún espacio configurado
SELECT p.id_parqueadero, p.nombre, p.direccion
FROM parqueaderos p
LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero
WHERE e.id_espacio IS NULL;  


-- 26. Tipos de vehículo que no tienen ningún vehículo asociado
SELECT tv.id_tipo_vehiculo, tv.descripcion
FROM tipos_vehiculo tv
LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo
WHERE v.id_vehiculo IS NULL;  

/* RIGHT JOIN EXCLUDING (B - A)
*/-- 27. Tarifas que nunca han sido utilizadas en ingresos
SELECT t.id_tarifa, t.descripcion, t.valor_hora
FROM ingresos i
RIGHT JOIN tarifas t ON i.id_tarifa = t.id_tarifa
WHERE i.id_ingreso IS NULL;  


-- 28. Estados de ingreso que no se han aplicado en ningún registro de ingreso
SELECT ei.id_estado, ei.descripcion
FROM ingresos i
RIGHT JOIN estados_ingresos ei ON i.id_estado = ei.id_estado
WHERE i.id_ingreso IS NULL;  


-- 29. Métodos de pago que no han sido utilizados en ningún ingreso
SELECT mp.id_pago, mp.descripcion
FROM ingresos i
RIGHT JOIN metodos_pago mp ON i.id_pago = mp.id_pago
WHERE i.id_ingreso IS NULL;  


-- 30. Empleados que no figuran en ningún registro de ingreso (enfocado en empleados)
SELECT emp.id_empleado, emp.nombres, emp.apellidos
FROM ingresos i
RIGHT JOIN empleados emp ON i.id_empleado = emp.id_empleado
WHERE i.id_ingreso IS NULL;  


-- 31. Tipos de vehículo que no poseen registros de vehículos asociados (enfocado en vehículos)
SELECT tv.id_tipo_vehiculo, tv.descripcion
FROM vehiculos v
RIGHT JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo
WHERE v.id_vehiculo IS NULL;  

/* FULL OUTER JOIN (A ∪ B) - Emulado con UNION
 */-- 32. Vista completa combinando todos los propietarios y vehículos
SELECT p.nombres, p.apellidos, v.placa, v.marca
FROM propietarios p
LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario
UNION
SELECT p.nombres, p.apellidos, v.placa, v.marca
FROM propietarios p
RIGHT JOIN vehiculos v ON p.id_propietario = v.id_propietario;  


-- 33. Combinación completa de todos los espacios y todos los ingresos
SELECT e.codigo, i.id_ingreso, i.fecha_hora_ingreso
FROM espacios e
LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio
UNION
SELECT e.codigo, i.id_ingreso, i.fecha_hora_ingreso
FROM espacios e
RIGHT JOIN ingresos i ON e.id_espacio = i.id_espacio;  


-- 34. Vista completa de todos los parqueaderos y sus espacios correspondientes
SELECT p.nombre AS parqueadero, e.codigo AS espacio
FROM parqueaderos p
LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero
UNION
SELECT p.nombre AS parqueadero, e.codigo AS espacio
FROM parqueaderos p
RIGHT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero;  


-- 35. Combinación completa de tarifas y registros de ingresos
SELECT t.descripcion AS tarifa, i.id_ingreso
FROM tarifas t
LEFT JOIN ingresos i ON t.id_tarifa = i.id_tarifa
UNION
SELECT t.descripcion AS tarifa, i.id_ingreso
FROM tarifas t
RIGHT JOIN ingresos i ON t.id_tarifa = i.id_tarifa;  


-- 36. Vista unificada de tipos de vehículo y vehículos registrados
SELECT tv.descripcion AS tipo, v.placa
FROM tipos_vehiculo tv
LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo
UNION
SELECT tv.descripcion AS tipo, v.placa
FROM tipos_vehiculo tv
RIGHT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo; 


/* FULL OUTER JOIN EXCLUDING - Emulado con UNION
*/-- 37. Propietarios sin vehículos y vehículos sin propietario (Exclusivos)
SELECT p.nombres, p.apellidos, v.placa
FROM propietarios p
LEFT JOIN vehiculos v ON p.id_propietario = v.id_propietario
WHERE v.id_vehiculo IS NULL
UNION
SELECT p.nombres, p.apellidos, v.placa
FROM propietarios p
RIGHT JOIN vehiculos v ON p.id_propietario = v.id_propietario
WHERE p.id_propietario IS NULL;


-- 38. Parqueaderos sin espacios y espacios huérfanos sin parqueadero (Exclusivos)
SELECT p.nombre, e.codigo
FROM parqueaderos p
LEFT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero
WHERE e.id_espacio IS NULL
UNION
SELECT p.nombre, e.codigo
FROM parqueaderos p
RIGHT JOIN espacios e ON p.id_parqueadero = e.id_parqueadero
WHERE p.id_parqueadero IS NULL; 


-- 39. Tipos de vehículo huérfanos y vehículos con tipos no mapeados (Exclusivos)
SELECT tv.descripcion, v.placa
FROM tipos_vehiculo tv
LEFT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo
WHERE v.id_vehiculo IS NULL
UNION
SELECT tv.descripcion, v.placa
FROM tipos_vehiculo tv
RIGHT JOIN vehiculos v ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo
WHERE tv.id_tipo_vehiculo IS NULL; 


-- 40. Tarifas no utilizadas en ingresos e ingresos con tarifas inexistentes (Exclusivos)
SELECT t.descripcion, i.id_ingreso
FROM tarifas t
LEFT JOIN ingresos i ON t.id_tarifa = i.id_tarifa
WHERE i.id_ingreso IS NULL
UNION
SELECT t.descripcion, i.id_ingreso
FROM tarifas t
RIGHT JOIN ingresos i ON t.id_tarifa = i.id_tarifa
WHERE t.id_tarifa IS NULL;  


-- 41. Espacios sin ingresos registrados e ingresos asociados a espacios inexistentes (Exclusivos)
SELECT e.codigo, i.id_ingreso
FROM espacios e
LEFT JOIN ingresos i ON e.id_espacio = i.id_espacio
WHERE i.id_ingreso IS NULL
UNION
SELECT e.codigo, i.id_ingreso
FROM espacios e
RIGHT JOIN ingresos i ON e.id_espacio = i.id_espacio
WHERE e.id_espacio IS NULL;