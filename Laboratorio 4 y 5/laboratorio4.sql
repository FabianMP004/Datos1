-- Insertar 1000 usuarios aleatorios en la tabla "user"
INSERT INTO wallet."user" (name, email, date_of_birth, password)
SELECT
    -- Genera un nombre aleatorio de 5 a 10 caracteres
    substring(md5(random()::text) from 1 for 10) as name,

    -- Genera un correo aleatorio en formato 'nombre@correo.com'
    substring(md5(random()::text) from 1 for 5) || '@example.com' as email,

    -- Genera una fecha de nacimiento aleatoria entre 1980 y 2005
    date '1980-01-01' + (random() * (date '2005-12-31' - date '1980-01-01'))::int as date_of_birth,

    -- Genera una contraseña aleatoria de 8 caracteres
    substring(md5(random()::text) from 1 for 8) as password

FROM generate_series(1, 1000);


DO
$$
    DECLARE
        user_record RECORD;
        wallet_count INTEGER;
        i INTEGER;
    BEGIN
        -- Iterar sobre cada usuario en la tabla "user"
        FOR user_record IN SELECT id FROM wallet."user" LOOP

                -- Generar una cantidad aleatoria de wallets entre 1 y 3
                wallet_count := floor(1 + random() * 3)::int;

                -- Insertar las wallets correspondientes para el usuario
                FOR i IN 1..wallet_count LOOP
                        INSERT INTO wallet.wallet (user_id, code_wallet, name, balance)
                        VALUES (
                                   user_record.id,                                       -- id del usuario
                                   substring(md5(random()::text) from 1 for 16),         -- código de wallet aleatorio
                                   'wallet_' || i,                                       -- nombre de la wallet (por ejemplo, wallet_1, wallet_2, etc.)
                                   round((random() * 1000)::numeric, 2)::money           -- balance aleatorio entre 0 y 1000
                               );
                    END LOOP;
            END LOOP;
    END
$$;

DO
$$
    DECLARE
        wallet_record RECORD;
        category_id INTEGER;
    BEGIN
        -- Iterar sobre cada wallet en la tabla "wallet"
        FOR wallet_record IN (SELECT id FROM wallet.wallet) LOOP

                -- Seleccionar una categoría aleatoria de wallet_budget_category
                SELECT id INTO category_id
                FROM wallet.wallet_budget_category
                ORDER BY random()
                LIMIT 1;

                -- Insertar en wallet_budget la wallet y la categoría seleccionada
                INSERT INTO wallet.wallet_budget (wallet_id, budget_category_id, amount, name)
                VALUES (
                           wallet_record.id,           -- id de la wallet
                           category_id,                -- id de la categoría seleccionada
                           round((random() * 1000)::numeric, 2)::money,  -- cantidad aleatoria
                           'Budget for Wallet ' || wallet_record.id -- nombre de la categoría para la wallet
                       );
            END LOOP;
    END
$$;


DO
$$
    DECLARE
        wallet_record RECORD;
        transaction_count INTEGER;
        transaction_date DATE;
        i INTEGER;
        month_offset INTEGER;
        origin_wallet_id INTEGER;
        destination_wallet_id INTEGER;
        budget_id INTEGER;
        transaction_type_id INTEGER;
    BEGIN
        -- Iterar sobre cada wallet
        FOR wallet_record IN (SELECT id FROM wallet.wallet) LOOP

                -- Para cada mes, generar entre 1 y 5 transacciones
                FOR month_offset IN 0..2 LOOP  -- 0: Junio, 1: Julio, 2: Agosto
                -- Generar una cantidad aleatoria de transacciones entre 1 y 5 para el mes
                        transaction_count := floor(1 + random() * 5)::int;

                        -- Insertar las transacciones en la tabla wallet_transaction
                        FOR i IN 1..transaction_count LOOP
                                -- Generar una fecha aleatoria dentro del mes
                                transaction_date := ('2024-06-01'::date + (month_offset * INTERVAL '1 month') + (floor(random() * 29 + 1)::int * INTERVAL '1 day'));

                                -- Seleccionar aleatoriamente una wallet de destino diferente a la wallet de origen
                                SELECT id INTO destination_wallet_id
                                FROM wallet.wallet
                                WHERE id != wallet_record.id
                                ORDER BY random()
                                LIMIT 1;

                                -- Seleccionar aleatoriamente un wallet_budget_id asociado con la wallet de origen
                                SELECT id INTO budget_id
                                FROM wallet.wallet_budget
                                WHERE wallet_id = wallet_record.id
                                ORDER BY random()
                                LIMIT 1;

                                -- Seleccionar aleatoriamente un tipo de transacción (wallet_transaction_type_id)
                                SELECT id INTO transaction_type_id
                                FROM wallet.wallet_transaction_type
                                ORDER BY random()
                                LIMIT 1;

                                -- Insertar en wallet_transaction
                                INSERT INTO wallet.wallet_transaction (
                                    origin_wallet_id,
                                    destination_wallet_id,
                                    wallet_budget_id,
                                    amount_in,
                                    amount_out,
                                    wallet_transaction_type_id,
                                    transaction_date
                                )
                                VALUES (
                                           wallet_record.id,           -- wallet de origen
                                           destination_wallet_id,      -- wallet de destino
                                           budget_id,                  -- wallet_budget_id de la wallet de origen
                                           round((random() * 500)::numeric, 2)::money,  -- Monto entrante (aleatorio entre 0 y 500)
                                           round((random() * 500)::numeric, 2)::money,  -- Monto saliente (aleatorio entre 0 y 500)
                                           transaction_type_id,        -- Tipo de transacción
                                           transaction_date            -- Fecha de la transacción
                                       );
                            END LOOP;
                    END LOOP;
            END LOOP;
    END
$$;


DO
$$
    DECLARE
        wallet_record RECORD;
        transaction_count INTEGER := 10;  -- Mínimo de 10 transacciones de salida por mes
        transaction_date DATE;
        month_offset INTEGER;
        budget_id INTEGER;
        transaction_type_id INTEGER;
        available_balance NUMERIC;  -- Convertimos balance a NUMERIC
        amount_out MONEY;
    BEGIN
        -- Iterar sobre cada wallet
        FOR wallet_record IN (SELECT id, balance FROM wallet.wallet) LOOP

                -- Para cada mes (Junio, Julio, Agosto)
                FOR month_offset IN 0..2 LOOP
                        -- Generar las 10 transacciones de salida para el mes
                        FOR i IN 1..transaction_count LOOP
                                -- Obtener el balance disponible de la wallet antes de hacer la transacción
                                SELECT balance::numeric INTO available_balance  -- Convertir balance a numeric
                                FROM wallet.wallet
                                WHERE id = wallet_record.id;

                                -- Verificar si el balance es suficiente para hacer la transacción
                                IF available_balance > 0 THEN
                                    -- Generar una cantidad de salida aleatoria pero que no exceda el saldo disponible
                                    amount_out := round((random() * available_balance)::numeric, 2)::money;

                                    -- Generar una fecha aleatoria dentro del mes
                                    transaction_date := ('2024-06-01'::date + (month_offset * INTERVAL '1 month') + (floor(random() * 29 + 1)::int * INTERVAL '1 day'));

                                    -- Seleccionar aleatoriamente un wallet_budget_id asociado con la wallet de origen
                                    SELECT id INTO budget_id
                                    FROM wallet.wallet_budget
                                    WHERE wallet_id = wallet_record.id
                                    ORDER BY random()
                                    LIMIT 1;

                                    -- Seleccionar aleatoriamente un tipo de transacción (wallet_transaction_type_id)
                                    SELECT id INTO transaction_type_id
                                    FROM wallet.wallet_transaction_type
                                    ORDER BY random()
                                    LIMIT 1;

                                    -- Insertar la transacción de salida en la tabla wallet_transaction
                                    INSERT INTO wallet.wallet_transaction (
                                        origin_wallet_id,
                                        destination_wallet_id,
                                        wallet_budget_id,
                                        amount_in,
                                        amount_out,
                                        wallet_transaction_type_id,
                                        transaction_date
                                    )
                                    VALUES (
                                               wallet_record.id,       -- wallet de origen
                                               NULL,                   -- No hay wallet de destino (solo salida)
                                               budget_id,              -- wallet_budget_id de la wallet de origen
                                               0::money,               -- No hay monto entrante
                                               amount_out,             -- Monto saliente
                                               transaction_type_id,    -- Tipo de transacción (seleccionado aleatoriamente)
                                               transaction_date        -- Fecha de la transacción
                                           );

                                    -- Actualizar el balance de la wallet después de la transacción
                                    UPDATE wallet.wallet
                                    SET balance = balance - amount_out
                                    WHERE id = wallet_record.id;

                                END IF;
                            END LOOP;
                    END LOOP;
            END LOOP;
    END
$$;


DO
$$
    DECLARE
        wallet_origin RECORD;
        wallet_destination RECORD;
        transfer_amount MONEY;
        transaction_type_out_id INTEGER;
        transaction_type_in_id INTEGER;
        budget_id INTEGER;
        transfer_count INTEGER := 0;  -- Contador para llevar control de las transferencias generadas
    BEGIN
        -- Seleccionar el tipo de transacción 'out' y 'in'
        SELECT id INTO transaction_type_out_id
        FROM wallet.wallet_transaction_type
        WHERE description = 'out';

        SELECT id INTO transaction_type_in_id
        FROM wallet.wallet_transaction_type
        WHERE description = 'in';

        -- Generar 500 transacciones de transferencia
        WHILE transfer_count < 500 LOOP
                -- Seleccionar aleatoriamente una wallet de origen que tenga saldo disponible
                SELECT id, balance INTO wallet_origin
                FROM wallet.wallet
                WHERE balance > 0::money  -- Convertimos 0 a money
                ORDER BY random()
                LIMIT 1;

                -- Validar que se ha seleccionado una wallet de origen
                IF NOT FOUND THEN
                    RAISE NOTICE 'No hay wallets de origen disponibles con saldo.';
                    EXIT;  -- Salir si no hay wallets disponibles
                END IF;

                -- Seleccionar aleatoriamente una wallet de destino diferente a la wallet de origen
                SELECT id INTO wallet_destination
                FROM wallet.wallet
                WHERE id != wallet_origin.id
                ORDER BY random()
                LIMIT 1;

                -- Validar que se ha seleccionado una wallet de destino
                IF NOT FOUND THEN
                    RAISE NOTICE 'No hay wallets de destino disponibles.';
                    EXIT;  -- Salir si no hay wallets de destino
                END IF;

                -- Determinar un monto de transferencia aleatorio que no exceda el saldo de la wallet de origen
                transfer_amount := round((random() * wallet_origin.balance::numeric)::numeric, 2)::money;

                -- Seleccionar un wallet_budget_id asociado con la wallet de origen
                SELECT id INTO budget_id
                FROM wallet.wallet_budget
                WHERE wallet_id = wallet_origin.id
                ORDER BY random()
                LIMIT 1;

                -- Validar que se ha seleccionado un wallet_budget_id
                IF budget_id IS NULL THEN
                    RAISE NOTICE 'No hay budget_id disponible para la wallet de origen.';
                    EXIT;  -- Salir si no hay budget_id disponible
                END IF;

                -- Insertar la transacción de salida en la wallet de origen
                INSERT INTO wallet.wallet_transaction (
                    origin_wallet_id,
                    destination_wallet_id,
                    wallet_budget_id,
                    amount_in,
                    amount_out,
                    wallet_transaction_type_id,
                    transaction_date
                )
                VALUES (
                           wallet_origin.id,      -- wallet de origen
                           wallet_destination.id, -- wallet de destino
                           budget_id,             -- wallet_budget_id de la wallet de origen
                           0::money,              -- No hay monto entrante
                           transfer_amount,       -- Monto saliente
                           transaction_type_out_id, -- Tipo de transacción de salida
                           NOW()                  -- Fecha actual
                       );

                -- Insertar la transacción de entrada en la wallet de destino
                INSERT INTO wallet.wallet_transaction (
                    origin_wallet_id,
                    destination_wallet_id,
                    wallet_budget_id,
                    amount_in,
                    amount_out,
                    wallet_transaction_type_id,
                    transaction_date
                )
                VALUES (
                           wallet_origin.id,      -- wallet de origen
                           wallet_destination.id, -- wallet de destino
                           budget_id,             -- wallet_budget_id (puede ser el mismo para ambas wallets)
                           transfer_amount,       -- Monto entrante
                           0::money,              -- No hay monto saliente
                           transaction_type_in_id, -- Tipo de transacción de entrada
                           NOW()                  -- Fecha actual
                       );

                -- Actualizar el saldo de la wallet de origen
                UPDATE wallet.wallet
                SET balance = balance - transfer_amount
                WHERE id = wallet_origin.id;

                -- Actualizar el saldo de la wallet de destino
                UPDATE wallet.wallet
                SET balance = balance + transfer_amount
                WHERE id = wallet_destination.id;

                -- Incrementar el contador de transferencias
                transfer_count := transfer_count + 1;
            END LOOP;
    END
$$;