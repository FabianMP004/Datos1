-- Truncate all relevant tables, cascading to remove dependencies
TRUNCATE TABLE miprestamo.HISTORIAL_PAGOS CASCADE;
TRUNCATE TABLE miprestamo.CALENDARIO_DE_PAGOS CASCADE;
TRUNCATE TABLE miprestamo.PRESTAMO CASCADE;
TRUNCATE TABLE miprestamo.ESTADO_PRESTAMO CASCADE;
TRUNCATE TABLE miprestamo.ESTADO_PAGO CASCADE;
TRUNCATE TABLE miprestamo.VALIDACION CASCADE;
TRUNCATE TABLE miprestamo.DIRECCION CASCADE;
TRUNCATE TABLE miprestamo.USUARIOS CASCADE;
TRUNCATE TABLE miprestamo.TRABAJADORES CASCADE;
TRUNCATE TABLE miprestamo.ROL CASCADE;

-- 1. Insertar en la tabla USUARIOS
INSERT INTO miprestamo.USUARIOS (
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
    nombre
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
    CONCAT(cliente_primer_nombre, ' ', cliente_primer_apellido)
FROM
    miprestamo.prestamos;

-- 2. Insertar en la tabla DIRECCION
INSERT INTO miprestamo.DIRECCION (
    direccion_id,
    user_id,
    depto_nacimiento,
    muni_nacimiento,
    vecindad
)
SELECT
            ROW_NUMBER() OVER (ORDER BY cliente_id) AS direccion_id,
            cliente_id,
            depto_nacimiento,
            muni_nacimiento,
            vecindad
FROM
    miprestamo.prestamos;

-- 3. Insertar estados únicos en la tabla ESTADO_PRESTAMO
INSERT INTO miprestamo.ESTADO_PRESTAMO (estatus_id, descripcion)
SELECT DISTINCT
            ROW_NUMBER() OVER (ORDER BY prestamo_estatus) AS estatus_id,
            prestamo_estatus AS descripcion
FROM
    miprestamo.prestamos;

-- 4. Insertar en la tabla PRESTAMO con manejo de duplicados
INSERT INTO miprestamo.PRESTAMO (
    prestamo_id,
    codigo_prestamo,
    monto_solicitado,
    cuotas_pactadas,
    motivo,
    estatus_id,
    porcentaje_interes,
    iva,
    cargos_administrativos,
    fecha_creacion,
    fecha_aprobacion,
    user_id
)
SELECT DISTINCT ON (p.prestamo_id) -- Aseguramos que cada prestamo_id sea único en el SELECT
                                   p.prestamo_id,
                                   p.codigo_prestamo,
                                   p.monto_solicitado,
                                   p.cuotas_pactadas,
                                   p.motivo_prestamo,
                                   ep.estatus_id,
                                   p.porcentaje_interes,
                                   p.prestamo_iva,
                                   p.prestamo_cargos_administrativos,
                                   CURRENT_DATE AS fecha_creacion,
                                   CURRENT_DATE AS fecha_aprobacion,
                                   p.cliente_id
FROM
    miprestamo.prestamos p
        INNER JOIN miprestamo.ESTADO_PRESTAMO ep
                   ON p.prestamo_estatus = ep.descripcion
ON CONFLICT (prestamo_id) DO UPDATE SET
                                        codigo_prestamo = EXCLUDED.codigo_prestamo,
                                        monto_solicitado = EXCLUDED.monto_solicitado,
                                        cuotas_pactadas = EXCLUDED.cuotas_pactadas,
                                        motivo = EXCLUDED.motivo,
                                        estatus_id = EXCLUDED.estatus_id,
                                        porcentaje_interes = EXCLUDED.porcentaje_interes,
                                        iva = EXCLUDED.iva,
                                        cargos_administrativos = EXCLUDED.cargos_administrativos,
                                        fecha_creacion = EXCLUDED.fecha_creacion,
                                        fecha_aprobacion = EXCLUDED.fecha_aprobacion,
                                        user_id = EXCLUDED.user_id;

-- 5. Insertar en la tabla CALENDARIO_DE_PAGOS
INSERT INTO miprestamo.CALENDARIO_DE_PAGOS (
    calendario_id,
    prestamo_id,
    numero_pago,
    fecha_esperada
)
SELECT
            ROW_NUMBER() OVER () AS calendario_id,
            p.prestamo_id,
            t.NumeroPago,
            t.FechaEsperada
FROM
    miprestamo.prestamos p
        CROSS JOIN LATERAL (
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
        ) AS t(NumeroPago, FechaEsperada)
WHERE
    t.FechaEsperada IS NOT NULL;

-- 6. Insertar estados únicos en la tabla ESTADO_PAGO
INSERT INTO miprestamo.ESTADO_PAGO (estado_id, descripcion)
SELECT DISTINCT
            ROW_NUMBER() OVER (ORDER BY validacion1_estatus) AS estado_id,
            validacion1_estatus AS descripcion
FROM
    miprestamo.pagos_realizados;

-- 7. Insertar en la tabla HISTORIAL_PAGOS
WITH CalendarioMapping AS (
    SELECT
        c.calendario_id,
        c.prestamo_id,
        c.numero_pago
    FROM
        miprestamo.CALENDARIO_DE_PAGOS c
)
INSERT INTO miprestamo.HISTORIAL_PAGOS (
    pago_id,
    calendario_id,
    fecha_real,
    monto_pagado,
    mora,
    estado_id
)
SELECT
    pr.pago_realizado_id, -- Asegúrate de que esta columna sea del tipo correcto
    cm.calendario_id, -- Debe coincidir con el mapeo de calendario_id
    pr.pago_realizado_fecha_pago,
    pr.pago_realizado_monto_pagado,
    0 AS mora, -- Valor por defecto para mora
    ep.estado_id
FROM
    miprestamo.pagos_realizados pr
        INNER JOIN CalendarioMapping cm
                   ON CAST(pr.pago_realizado_correlativo AS VARCHAR) LIKE cm.numero_pago::TEXT
        INNER JOIN miprestamo.PRESTAMO p
                   ON cm.prestamo_id = p.prestamo_id
        INNER JOIN miprestamo.ESTADO_PAGO ep
                   ON pr.validacion1_estatus = ep.descripcion;

-- 8. Insertar en la tabla VALIDACION
WITH CalendarioMapping AS (
    SELECT
        c.calendario_id,
        c.prestamo_id,
        c.numero_pago
    FROM
        miprestamo.CALENDARIO_DE_PAGOS c
)
INSERT INTO miprestamo.HISTORIAL_PAGOS (
    pago_id,
    calendario_id,
    fecha_real,
    monto_pagado,
    mora,
    estado_id
)
SELECT
    pr.pago_realizado_id, -- Asegúrate de que esta columna sea del tipo correcto
    cm.calendario_id, -- Debe coincidir con el mapeo de calendario_id
    pr.pago_realizado_fecha_pago,
    pr.pago_realizado_monto_pagado,
    0 AS mora, -- Valor por defecto para mora
    ep.estado_id
FROM
    pagos_realizados pr
        INNER JOIN CalendarioMapping cm
                   ON CAST(pr.pago_realizado_correlativo AS VARCHAR) LIKE cm.numero_pago::TEXT
        INNER JOIN miprestamo.PRESTAMO p
                   ON cm.prestamo_id = p.prestamo_id
        INNER JOIN miprestamo.ESTADO_PAGO ep
                   ON pr.validacion1_estatus = ep.descripcion;