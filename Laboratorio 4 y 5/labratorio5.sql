-- 1. Cantidad de transacciones por tipo, por semana y por mes
--1.1 Por semana
SELECT
    wt.wallet_transaction_type_id,
    COUNT(*) AS cantidad_transacciones,
    SUM(wt.amount_in + wt.amount_out) AS monto_total,
    DATE_TRUNC('week', wt.transaction_date) AS semana
FROM
    wallet.wallet_transaction wt
GROUP BY
    wt.wallet_transaction_type_id, semana
ORDER BY
    semana, cantidad_transacciones DESC;

--1.2 Por mes
SELECT
    wt.wallet_transaction_type_id,
    COUNT(*) AS cantidad_transacciones,
    SUM(wt.amount_in + wt.amount_out) AS monto_total,
    DATE_TRUNC('month', wt.transaction_date) AS mes
FROM
    wallet.wallet_transaction wt
GROUP BY
    wt.wallet_transaction_type_id, mes
ORDER BY
    mes, cantidad_transacciones DESC;


--2. Top 10 usuarios con más transacciones y mayores montos procesados
--2.1 Top 10 usuarios con más transacciones
SELECT
    u.id AS user_id,
    u.name AS user_name,
    COUNT(wt.id) AS total_transacciones
FROM
    wallet.wallet_transaction wt
        JOIN
    wallet.wallet w ON wt.origin_wallet_id = w.id OR wt.destination_wallet_id = w.id
        JOIN
    wallet.user u ON w.user_id = u.id
GROUP BY
    u.id
ORDER BY
    total_transacciones DESC
LIMIT 10;

--2.2 Top 10 usuarios con mayores montos procesados
SELECT
    u.id AS user_id,
    u.name AS user_name,
    SUM(wt.amount_in + wt.amount_out) AS total_monto
FROM
    wallet.wallet_transaction wt
        JOIN
    wallet.wallet w ON wt.origin_wallet_id = w.id OR wt.destination_wallet_id = w.id
        JOIN
    wallet.user u ON w.user_id = u.id  -- Reemplaza 'schema_name' por el esquema correcto si es necesario
GROUP BY
    u.id, u.name
ORDER BY
    total_monto DESC
LIMIT 10;

--3. Resumen por usuario y wallet: cantidad de transacciones y saldo
--3.1 Resumen mensual
SELECT
    u.id AS user_id,  -- Verifica el nombre de la columna en la tabla `users`
    u.name AS user_name,
    w.id AS wallet_id,
    COUNT(wt.id) AS cantidad_transacciones,
    SUM(wt.amount_in + wt.amount_out) AS saldo_total,
    DATE_TRUNC('month', wt.transaction_date) AS mes
FROM
    wallet.wallet w
        JOIN
    wallet.user u ON w.user_id = u.id  -- Asumimos que la columna en `users` es `id`
        LEFT JOIN
    wallet.wallet_transaction wt ON wt.origin_wallet_id = w.id OR wt.destination_wallet_id = w.id
GROUP BY
    u.id, u.name, w.id, mes
ORDER BY
    user_id, wallet_id, mes;

--4. Comparativa entre budget y lo ejecutado por mes
SELECT
    u.id AS user_id,  -- Verifica que `id` sea el nombre correcto en la tabla `users`
    u.name AS user_name,
    w.id AS wallet_id,
    wb.id AS budget_id,
    wb.amount AS budget_amount,
    SUM(wt.amount_in + wt.amount_out) AS total_ejecutado,
    DATE_TRUNC('month', wt.transaction_date) AS mes
FROM
    wallet.wallet_budget wb
        JOIN
    wallet.wallet w ON wb.wallet_id = w.id
        JOIN
    wallet.user u ON w.user_id = u.id  -- Verifica si la tabla `users` pertenece a otro esquema
        LEFT JOIN
    wallet.wallet_transaction wt ON wt.origin_wallet_id = w.id OR wt.destination_wallet_id = w.id
GROUP BY
    u.id, w.id, wb.id, mes
ORDER BY
    user_id, wallet_id, mes;

--5. Tipo de presupuesto que más transacciones ha generado
SELECT
    bc.id AS budget_category_id,
    bc.name AS budget_category_name,
    COUNT(wt.id) AS cantidad_transacciones
FROM
    wallet.wallet_budget wb
        JOIN
    wallet.wallet_budget_category bc ON wb.budget_category_id = bc.id  -- Relación entre wallet_budget y budget_category
        LEFT JOIN
    wallet.wallet_transaction wt ON wt.wallet_budget_id = wb.id
GROUP BY
    bc.id
ORDER BY
    cantidad_transacciones DESC
LIMIT 1;


