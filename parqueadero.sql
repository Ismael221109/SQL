CREATE DATABASE parqueadero
CHARACTER SET utf8mb4 
COLLATE utf8mb4_spanish_ci;

USE parqueadero;

CREATE TABLE propietarios (
    id_propietario INT NOT NULL AUTO_INCREMENT,
    tipo_documento VARCHAR(20) NOT NULL,
    documento VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    PRIMARY KEY(id_propietario),
    INDEX idx_propietarios_apellidos(apellidos)
) ENGINE = InnoDB;

CREATE TABLE tipos_vehiculo (
    id_tipo_vehiculo INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(50) UNIQUE,
    PRIMARY KEY(id_tipo_vehiculo)
) ENGINE = InnoDB;

CREATE TABLE tarifas (
    id_tarifa INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(100) UNIQUE NOT NULL,
    valor_hora DECIMAL(10,2) NOT NULL,
    valor_dia DECIMAL(10,2) NOT NULL,
    PRIMARY KEY(id_tarifa)
) ENGINE = InnoDB;

CREATE TABLE estados_ingresos (
    id_estado INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY(id_estado)
) ENGINE = InnoDB;

CREATE TABLE metodos_pago (
    id_pago INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY(id_pago)
) ENGINE = InnoDB;

CREATE TABLE empleados (
    id_empleado INT NOT NULL AUTO_INCREMENT,
    documento VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_empleado),
    INDEX idx_empleados_apellidos(apellidos)
) ENGINE = InnoDB;

CREATE TABLE parqueaderos (
    id_parqueadero INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    capacidad INT NOT NULL,
    PRIMARY KEY(id_parqueadero),
    INDEX idx_parqueaderos_nombre(nombre)
) ENGINE = InnoDB;






CREATE TABLE vehiculos (
    id_vehiculo INT NOT NULL AUTO_INCREMENT,
    id_propietario INT NOT NULL,
    id_tipo_vehiculo INT NOT NULL,
    placa VARCHAR(15) UNIQUE NOT NULL,
    marca VARCHAR(50) NOT NULL,
    linea VARCHAR(50) NOT NULL,
    modelo VARCHAR(10) NOT NULL,
    color VARCHAR(30) NOT NULL,
    PRIMARY KEY(id_vehiculo, id_propietario, id_tipo_vehiculo),
    INDEX idx_vehiculos_marca(marca),
    CONSTRAINT fk_id_propietario 
        FOREIGN KEY (id_propietario) REFERENCES propietarios(id_propietario) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_id_tipo_vehiculo
        FOREIGN KEY (id_tipo_vehiculo) REFERENCES tipos_vehiculo(id_tipo_vehiculo) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE espacios (
    id_espacio INT NOT NULL AUTO_INCREMENT,
    id_parqueadero INT NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nivel VARCHAR(10) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_espacio, id_parqueadero),
    CONSTRAINT fk_id_parqueadero
        FOREIGN KEY (id_parqueadero) REFERENCES parqueaderos(id_parqueadero) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE ingresos (
    id_ingreso INT NOT NULL AUTO_INCREMENT,
    id_vehiculo INT NOT NULL,
    id_espacio INT NOT NULL,
    id_tarifa INT NOT NULL,
    id_estado INT NOT NULL,
    id_pago INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_hora_ingreso DATETIME NOT NULL,
    fecha_hora_salida DATETIME NOT NULL,
    horas DECIMAL(6,2) NOT NULL,
    valor DECIMAL(12,2) NOT NULL,
    PRIMARY KEY(id_ingreso, id_vehiculo, id_espacio, id_tarifa, id_estado, id_pago, id_empleado),
    INDEX idx_ingresos_vehiculos(id_vehiculo),
    INDEX idx_ingresos_espacios(id_espacio),
    CONSTRAINT fk_id_vehiculo
        FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_id_espacio
        FOREIGN KEY (id_espacio) REFERENCES espacios(id_espacio) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_id_tarifa
        FOREIGN KEY (id_tarifa) REFERENCES tarifas(id_tarifa) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_estado
        FOREIGN KEY (id_estado) REFERENCES estados_ingresos(id_estado) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_id_pago
        FOREIGN KEY (id_pago) REFERENCES metodos_pago(id_pago) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_id_empleado
        FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;