

-- Tabla de Roles
CREATE TABLE miprestamo.ROL (
                                rol_id INT PRIMARY KEY,
                                descripcion VARCHAR(100)
);

-- Tabla de Usuarios
CREATE TABLE miprestamo.USUARIOS (
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
                                     nombre VARCHAR(50)
);

-- Tabla de Trabajadores
CREATE TABLE miprestamo.TRABAJADORES (
                                         trabajador_id INT PRIMARY KEY,
                                         user_id INT UNIQUE NOT NULL,
                                         rol_id INT NOT NULL,
                                         supervisor_id INT,
                                         FOREIGN KEY (user_id) REFERENCES miprestamo.USUARIOS(user_id),
                                         FOREIGN KEY (rol_id) REFERENCES miprestamo.ROL(rol_id),
                                         FOREIGN KEY (supervisor_id) REFERENCES miprestamo.TRABAJADORES(trabajador_id)
);

-- Tabla de Dirección de Usuario
CREATE TABLE miprestamo.DIRECCION (
                                      direccion_id INT PRIMARY KEY,
                                      user_id INT NOT NULL,
                                      depto_nacimiento VARCHAR(50),
                                      muni_nacimiento VARCHAR(50),
                                      vecindad VARCHAR(100),
                                      FOREIGN KEY (user_id) REFERENCES miprestamo.USUARIOS(user_id)
);

-- Tabla de Estado de Préstamo
CREATE TABLE miprestamo.ESTADO_PRESTAMO (
                                            estatus_id INT PRIMARY KEY,
                                            descripcion VARCHAR(50)
);

-- Tabla de Préstamos
CREATE TABLE miprestamo.PRESTAMO (
                                     prestamo_id INT PRIMARY KEY,
                                     codigo_prestamo VARCHAR(50),
                                     monto_solicitado DECIMAL(10, 2),
                                     cuotas_pactadas INT,
                                     motivo VARCHAR(255),
                                     estatus_id INT NOT NULL,
                                     porcentaje_interes DECIMAL(5, 2),
                                     iva DECIMAL(5, 2),
                                     cargos_administrativos DECIMAL(10, 2),
                                     total DECIMAL(10, 2) GENERATED ALWAYS AS (monto_solicitado + iva + cargos_administrativos) STORED,
                                     fecha_creacion DATE,
                                     fecha_aprobacion DATE,
                                     user_id INT NOT NULL,
                                     FOREIGN KEY (user_id) REFERENCES miprestamo.USUARIOS(user_id),
                                     FOREIGN KEY (estatus_id) REFERENCES miprestamo.ESTADO_PRESTAMO(estatus_id)
);

-- Historial de Estados del Préstamo
CREATE TABLE miprestamo.HISTORIAL_ESTADO_PRESTAMO (
                                                      historial_id INT PRIMARY KEY,
                                                      prestamo_id INT NOT NULL,
                                                      estatus_id INT NOT NULL,
                                                      fecha_cambio DATE,
                                                      FOREIGN KEY (prestamo_id) REFERENCES miprestamo.PRESTAMO(prestamo_id),
                                                      FOREIGN KEY (estatus_id) REFERENCES miprestamo.ESTADO_PRESTAMO(estatus_id)
);

-- Tabla de Calendario de Pagos para cada Préstamo
CREATE TABLE miprestamo.CALENDARIO_DE_PAGOS (
                                                calendario_id INT PRIMARY KEY,
                                                prestamo_id INT NOT NULL,
                                                numero_pago INT,
                                                fecha_esperada DATE,
                                                FOREIGN KEY (prestamo_id) REFERENCES miprestamo.PRESTAMO(prestamo_id)
);

-- Tabla de Estado de Pago
CREATE TABLE miprestamo.ESTADO_PAGO (
                                        estado_id INT PRIMARY KEY,
                                        descripcion VARCHAR(50)
);

-- Tabla de Historial de Pagos
CREATE TABLE miprestamo.HISTORIAL_PAGOS (
                                            pago_id INT PRIMARY KEY,
                                            calendario_id INT NOT NULL,
                                            fecha_real DATE,
                                            monto_pagado DECIMAL(10, 2),
                                            mora DECIMAL(10, 2),
                                            estado_id INT NOT NULL,
                                            FOREIGN KEY (calendario_id) REFERENCES miprestamo.CALENDARIO_DE_PAGOS(calendario_id),
                                            FOREIGN KEY (estado_id) REFERENCES miprestamo.ESTADO_PAGO(estado_id)
);

-- Tabla de Validación de Pagos
CREATE TABLE miprestamo.VALIDACION (
                                       validacion_id INT PRIMARY KEY,
                                       pago_id INT NOT NULL,
                                       analista_id INT NOT NULL,
                                       fecha_validacion DATE,
                                       estatus_id INT NOT NULL,
                                       FOREIGN KEY (pago_id) REFERENCES miprestamo.HISTORIAL_PAGOS(pago_id),
                                       FOREIGN KEY (analista_id) REFERENCES miprestamo.TRABAJADORES(trabajador_id),
                                       FOREIGN KEY (estatus_id) REFERENCES miprestamo.ESTADO_PRESTAMO(estatus_id)
);

-- Tabla de Tipos de Referencias
CREATE TABLE miprestamo.TIPO_REFERENCIA (
                                            tipo_id INT PRIMARY KEY,
                                            descripcion VARCHAR(50)
);

-- Tabla de Referencias de Usuario
CREATE TABLE miprestamo.REFERENCIA (
                                       referencia_id INT PRIMARY KEY,
                                       user_id INT NOT NULL,
                                       tipo_id INT NOT NULL,
                                       nombre_completo VARCHAR(100),
                                       telefono VARCHAR(20),
                                       FOREIGN KEY (user_id) REFERENCES miprestamo.USUARIOS(user_id),
                                       FOREIGN KEY (tipo_id) REFERENCES miprestamo.TIPO_REFERENCIA(tipo_id)
);