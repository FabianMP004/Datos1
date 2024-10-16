CREATE SCHEMA IF NOT EXISTS Proyecto1;

CREATE TABLE Proyecto1.USERS (
    user_id INT PRIMARY KEY,
    codigo_usuario VARCHAR(50),
    primer_nombre VARCHAR(50),
    segundo_nombre VARCHAR(50),
    tercer_nombre VARCHAR(50),
    primer_apellido VARCHAR(50),
    segundo_apellido VARCHAR(50),
    apellido_casada VARCHAR(50),
    genero VARCHAR(10),
    cui VARCHAR(25),
    fecha_nacimiento DATE,
    fecha_vencimiento_dpi DATE,
    rol_id INT,
    supervisor_id INT,
    nombre VARCHAR(50),
    rol VARCHAR(50),
    FOREIGN KEY (rol_id) REFERENCES Proyecto1.ROL(rol_id)
);

CREATE TABLE Proyecto1.ROL (
    rol_id INT PRIMARY KEY,
    descripcion VARCHAR(100)
);

CREATE TABLE Proyecto1.DETALLE_CLIENTE (
    detalle_cliente_id INT PRIMARY KEY,
    user_id INT,
    estado_civil VARCHAR(20),
    nacionalidad VARCHAR(50),
    ocupacion VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Proyecto1.USERS(user_id)
);

CREATE TABLE Proyecto1.DIRECCION (
    direccion_id INT PRIMARY KEY,
    user_id INT,
    depto_nacimiento VARCHAR(50),
    muni_nacimiento VARCHAR(50),
    vecindad VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Proyecto1.USERS(user_id)
);

CREATE TABLE Proyecto1.PRESTAMO (
    prestamo_id INT PRIMARY KEY,
    codigo_prestamo VARCHAR(50),
    monto_solicitado DECIMAL(10, 2),
    cuotas_pactadas INT,
    motivo VARCHAR(255),
    estatus_id INT,
    porcentaje_interes DECIMAL(5, 2),
    iva DECIMAL(5, 2),
    cargos_administrativos DECIMAL(10, 2),
    total DECIMAL(10, 2),
    fecha_creacion DATE,
    fecha_aprobacion DATE,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Proyecto1.USERS(user_id),
    FOREIGN KEY (estatus_id) REFERENCES Proyecto1.ESTADO_PRESTAMO(estatus_id)
);

CREATE TABLE Proyecto1.CALENDARIO_DE_PAGOS (
    calendario_id INT PRIMARY KEY,
    prestamo_id INT,
    numero_pago INT,
    fecha_esperada DATE,
    FOREIGN KEY (prestamo_id) REFERENCES Proyecto1.PRESTAMO(prestamo_id)
);

CREATE TABLE Proyecto1.HISTORIAL_PAGOS (
    pago_id INT PRIMARY KEY,
    calendario_id INT,
    fecha_real DATE,
    monto_pagado DECIMAL(10, 2),
    mora DECIMAL(10, 2),
    estado_id INT,
    FOREIGN KEY (calendario_id) REFERENCES Proyecto1.CALENDARIO_DE_PAGOS(calendario_id),
    FOREIGN KEY (estado_id) REFERENCES Proyecto1.ESTADO_PAGO(estado_id)
);

CREATE TABLE Proyecto1.VALIDACION (
    validacion_id INT PRIMARY KEY,
    pago_id INT,
    analista_id INT,
    fecha_validacion DATE,
    estatus_id INT,
    FOREIGN KEY (pago_id) REFERENCES Proyecto1.HISTORIAL_PAGOS(pago_id),
    FOREIGN KEY (analista_id) REFERENCES Proyecto1.USERS(user_id),
    FOREIGN KEY (estatus_id) REFERENCES Proyecto1.ESTADO_PRESTAMO(estatus_id)
);

CREATE TABLE Proyecto1.ESTADO_PRESTAMO (
    estatus_id INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE Proyecto1.ESTADO_PAGO (
    estado_id INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE Proyecto1.REFERENCIA (
    referencia_id INT PRIMARY KEY,
    user_id INT,
    tipo_id INT,
    nombre_completo VARCHAR(100),
    telefono VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Proyecto1.USERS(user_id),
    FOREIGN KEY (tipo_id) REFERENCES Proyecto1.TIPO_REFERENCIA(tipo_id)
);

CREATE TABLE Proyecto1.TIPO_REFERENCIA (
    tipo_id INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE Proyecto1.HISTORIAL_ESTADO_PRESTAMO (
    historial_id INT PRIMARY KEY,
    prestamo_id INT,
    estatus_id INT,
    fecha_cambio DATE,
    FOREIGN KEY (prestamo_id) REFERENCES Proyecto1.PRESTAMO(prestamo_id),
    FOREIGN KEY (estatus_id) REFERENCES Proyecto1.ESTADO_PRESTAMO(estatus_id)
);
