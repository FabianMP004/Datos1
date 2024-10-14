-- 1. Insert data into proyecto1.USERS table
INSERT INTO proyecto1.USERS (
    user_id,
    codigo_usuario,
    primer_nombre,
    segundo_nombre,
    tercer_nombre,
    primer_apellido,
    segundo_apellido,
    apellido_casada,
    genero,
    cui,
    fecha_nacimiento,
    fecha_vencimiento_dpi,
    rol_id
)
SELECT
    cliente_id,
    codigo_cliente,
    cliente_primer_nombre,
    cliente_segundo_nombre,
    cliente_tercer_nombre,
    cliente_primer_apellido,
    cliente_segundo_apellido,
    apellido_casada,
    genero,
    cui,
    fecha_nacimiento,
    fecha_vencimiento_dpi,
    (SELECT rol_id FROM proyecto1.ROL WHERE descripcion = 'Cliente') AS rol_id
FROM
    prestamos;

-- 2. Insert data into proyecto1.DETALLE_CLIENTE table
INSERT INTO proyecto1.detalle_cliente (
    user_id,
    estado_civil,
    nacionalidad,
    ocupacion
)
SELECT
    cliente_id,
    estado_civil,
    nacionalidad,
    ocupacion
FROM
    prestamos;


-- 3. Insert data into proyecto1.DIRECCION table
INSERT INTO proyecto1.DIRECCION (
    user_id,
    depto_nacimiento,
    muni_nacimiento,
    vecindad
)
SELECT
    cliente_id,
    depto_nacimiento,
    muni_nacimiento,
    vecindad
FROM
    prestamos;

-- 4. Map prestamo_estatus to estatus_id in proyecto1.ESTADO_PRESTAMO
-- Insert unique statuses into proyecto1.ESTADO_PRESTAMO
INSERT INTO proyecto1.ESTADO_PRESTAMO (estatus_id, descripcion)
SELECT DISTINCT
            ROW_NUMBER() OVER (ORDER BY prestamo_estatus) AS estatus_id,
            prestamo_estatus AS descripcion
FROM
    prestamos;



-- 5. Insert data into proyecto1.PRESTAMO table
INSERT INTO proyecto1.PRESTAMO (
    prestamo_id,
    codigo_prestamo,
    monto_solicitado,
    cuotas_pactadas,
    motivo,
    estatus_id,
    porcentaje_interes,
    iva,
    cargos_administrativos,
    total,
    fecha_creacion,
    fecha_aprobacion,
    user_id
)
SELECT
    prestamo_id,
    codigo_prestamo,
    monto_solicitado,
    cuotas_pactadas,
    motivo_prestamo,
    em.estatus_id,
    porcentaje_interes,
    prestamo_iva,
    prestamo_cargos_administrativos,
    prestamo_total,
    CURRENT_DATE AS fecha_creacion,
    CURRENT_DATE AS fecha_aprobacion,
    cliente_id
FROM
    prestamos p
        JOIN proyecto1.ESTADO_PRESTAMO em ON p.prestamo_estatus = em.descripcion
WHERE
    prestamo_id NOT IN (SELECT prestamo_id FROM proyecto1.PRESTAMO);

-- 6. Insert data into proyecto1.CALENDARIO_DE_PAGOS table

INSERT INTO proyecto1.CALENDARIO_DE_PAGOS (
    calendario_id,
    prestamo_id,
    numero_pago,
    fecha_esperada
)
SELECT
    nextval('proyecto1.calendario_id_seq') AS calendario_id,
    p.prestamo_id + 1,
    t.NumeroPago,
    t.FechaEsperada
FROM
    prestamos p
        JOIN LATERAL (
        VALUES
            (1, p.pago1_fecha_esperada),
            (2, p.pago2_fecha_esperada),
            (3, p.pago3_fecha_esperada),
            (4, p.pago4_fecha_esperada),
            (5, p.pago5_fecha_esperada),
            (6, p.pago6_fecha_esperada),
            (7, p.pago7_fecha_esperada),
            (8, p.pago8_fecha_esperada),
            (9, p.pago9_fecha_esperada),
            (10, p.pago10_fecha_esperada),
            (11, p.pago11_fecha_esperada),
            (12, p.pago12_fecha_esperada)
        ) AS t(NumeroPago, FechaEsperada) ON true
WHERE
    t.FechaEsperada IS NOT NULL;



-- 7. Insert data into proyecto1.REFERENCIA table

CREATE SEQUENCE proyecto1.referencia_id_seq
    START WITH 1
    INCREMENT BY 1;

ALTER TABLE proyecto1.referencia
    ALTER COLUMN telefono SET DATA TYPE VARCHAR(250);

INSERT INTO proyecto1.REFERENCIA (
    referencia_id,
    user_id,
    tipo_id,
    nombre_completo,
    telefono
)
SELECT
    NEXTVAL('proyecto1.referencia_id_seq') AS referencia_id, -- Usar NEXTVAL para UUID
    cliente_id,
    (SELECT tipo_id FROM proyecto1.TIPO_REFERENCIA LIMIT 1) AS tipo_id,
    CONCAT(
            referencia1_primer_nombre, ' ',
            referencia1_segundo_nombre, ' ',
            referencia1_tercer_nombre, ' ',
            referencia1_primer_apellido, ' ',
            referencia1_segundo_apellido
    ) AS nombre_completo,
    referencia1_telefono
FROM
    prestamos
WHERE
    referencia1_primer_nombre IS NOT NULL

UNION ALL

SELECT
    NEXTVAL('proyecto1.referencia_id_seq'),
    cliente_id,
    (SELECT tipo_id FROM proyecto1.TIPO_REFERENCIA LIMIT 1),
    CONCAT(
            referencia2_primer_nombre, ' ',
            referencia2_segundo_nombre, ' ',
            referencia2_tercer_nombre, ' ',
            referencia2_primer_apellido, ' ',
            referencia2_segundo_apellido
    ),
    referencia2_telefono
FROM
    prestamos
WHERE
    referencia2_primer_nombre IS NOT NULL

UNION ALL

SELECT
    NEXTVAL('proyecto1.referencia_id_seq'),
    cliente_id,
    (SELECT tipo_id FROM proyecto1.TIPO_REFERENCIA LIMIT 1),
    CONCAT(
            referencia3_primer_nombre, ' ',
            referencia3_segundo_nombre, ' ',
            referencia3_tercer_nombre, ' ',
            referencia3_primer_apellido, ' ',
            referencia3_segundo_apellido
    ),
    referencia3_telefono
FROM
    prestamos
WHERE
    referencia3_primer_nombre IS NOT NULL

UNION ALL

SELECT
    NEXTVAL('proyecto1.referencia_id_seq'),
    cliente_id,
    (SELECT tipo_id FROM proyecto1.TIPO_REFERENCIA LIMIT 1),
    CONCAT(
            referencia4_primer_nombre, ' ',
            referencia4_segundo_nombre, ' ',
            referencia4_tercer_nombre, ' ',
            referencia4_primer_apellido, ' ',
            referencia4_segundo_apellido
    ),
    referencia4_telefono
FROM
    prestamos
WHERE
    referencia4_primer_nombre IS NOT NULL;


-- 8. Insert unique statuses into proyecto1.ESTADO_PAGO
INSERT INTO proyecto1.ESTADO_PAGO (estado_id, descripcion)
SELECT DISTINCT
            ROW_NUMBER() OVER (ORDER BY validacion1_estatus) AS estado_id,
            validacion1_estatus AS descripcion
FROM
    pagos_realizados;

-- 9. Insert data into proyecto1.HISTORIAL_PAGOS table
WITH CalendarioMapping AS (
    SELECT
        c.calendario_id,
        c.prestamo_id,
        c.numero_pago
    FROM
        proyecto1.CALENDARIO_DE_PAGOS c
)
INSERT INTO proyecto1.HISTORIAL_PAGOS (
    pago_id,
    calendario_id,
    fecha_real,
    monto_pagado,
    mora,
    estado_id
)
SELECT
    pr.pago_realizado_id,
    cm.calendario_id,
    pr.pago_realizado_fecha_pago,
    pr.pago_realizado_monto_pagado,
    0 AS mora, -- Assuming mora is 0 or calculate accordingly
    epm.estado_id
FROM
    pagos_realizados pr
        INNER JOIN CalendarioMapping cm ON pr.pago_realizado_correlativo::integer = cm.numero_pago -- Conversión de tipo
        INNER JOIN proyecto1.PRESTAMO p ON cm.prestamo_id = p.prestamo_id
        INNER JOIN (
        SELECT
            descripcion AS estatus,
            estado_id
        FROM
            proyecto1.ESTADO_PAGO
    ) epm ON pr.validacion1_estatus = epm.estatus;


-- 10. Inserción de datos de préstamo
INSERT INTO proyecto1.prestamo (
    codigo_prestamo,
    monto_solicitado,
    cuotas_pactadas,
    motivo,
    estatus_id,
    porcentaje_interes,
    iva,
    cargos_administrativos,
    total,
    fecha_creacion,
    fecha_aprobacion,
    user_id
)
SELECT
    codigo_prestamo,
    monto_solicitado,
    cuotas_pactadas,
    motivo_prestamo,
    CASE
        WHEN prestamo_estatus = 'Approved' THEN 1
        WHEN prestamo_estatus = 'Pending' THEN 2
        WHEN prestamo_estatus = 'Denied' THEN 3
        ELSE 0  -- En caso de que haya otros valores no mapeados, se asigna 0 o algún valor por defecto
        END AS estatus_id,
    porcentaje_interes,
    prestamo_iva AS iva,
    prestamo_cargos_administrativos AS cargos_administrativos,
    prestamo_total AS total,
    CURRENT_DATE AS fecha_creacion,
    NULL AS fecha_aprobacion,
    cliente_id AS user_id
FROM prestamos;

-- Insertar en la tabla HISTORIAL_PAGOS usando los datos de pagos_realizados
INSERT INTO Proyecto1.HISTORIAL_PAGOS (pago_id, calendario_id, fecha_real, monto_pagado, mora, estado_id)
SELECT
    pago_realizado_id AS pago_id,
    448673 AS calendario_id,  -- Asignación estática, ajustar según sea necesario
    pago_realizado_fecha_pago AS fecha_real,
    pago_realizado_monto_pagado AS monto_pagado,
    0.00 AS mora,  -- Se asigna mora 0, ajustar si es necesario
    1 AS estado_id  -- Se asigna un estado, ajustar si es necesario
FROM proyecto1.pagos_realizados;


-- Insertar en la tabla VALIDACION usando los datos de pagos_realizados (Validación 1)
/* INSERT INTO Proyecto1.VALIDACION (validacion_id, pago_id, analista_id, fecha_validacion, estatus_id)
SELECT
    /* pago_realizado_correlativo AS validacion_id,  -- Ahora es VARCHAR, no necesita CAST
    pago_realizado_correlativo AS pago_id,
    CAST(validacion1_validado_por AS INTEGER) AS analista_id,  -- Este sí se mantiene como INTEGER
    validacion1_fecha_creacion AS fecha_validacion,
    CAST(validacion1_estatus AS INTEGER) AS estatus_id
FROM proyecto1.pagos_realizados;



-- Insertar en la tabla VALIDACION usando los datos de pagos_realizados (Validación 2)
INSERT INTO Proyecto1.VALIDACION (validacion_id, pago_id, analista_id, fecha_validacion, estatus_id)
SELECT
    pago_realizado_correlativo + 1 AS validacion_id,  -- +1 para diferenciar el ID de validación
    pago_realizado_correlativo AS pago_id,
    validacion2_validado_por AS analista_id,
    validacion2_fecha_creacion AS fecha_validacion,
    validacion2_estatus AS estatus_id
FROM proyecto1.pagos_realizados;

-- Insertar en la tabla VALIDACION usando los datos de pagos_realizados (Validación 3)
INSERT INTO Proyecto1.VALIDACION (validacion_id, pago_id, analista_id, fecha_validacion, estatus_id)
SELECT
    pago_realizado_correlativo + 2 AS validacion_id,  -- +2 para diferenciar el ID de validación
    pago_realizado_correlativo AS pago_id,
    validacion3_validado_por AS analista_id,
    validacion3_fecha_creacion AS fecha_validacion,
    validacion3_estatus AS estatus_id
FROM proyecto1.pagos_realizados;

-- Insertar en la tabla VALIDACION usando los datos de pagos_realizados (Validación 4)
INSERT INTO Proyecto1.VALIDACION (validacion_id, pago_id, analista_id, fecha_validacion, estatus_id)
SELECT
    pago_realizado_correlativo + 3 AS validacion_id,  -- +3 para diferenciar el ID de validación
    pago_realizado_correlativo AS pago_id,
    validacion4_validado_por AS analista_id,
    validacion4_fecha_creacion AS fecha_validacion,
    validacion4_estatus AS estatus_id
FROM proyecto1.pagos_realizados; */ */