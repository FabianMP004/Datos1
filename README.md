# Datos 1

# Proyecto1

Este proyecto tiene como objetivo cargar datos desde archivos Excel a una base de datos en un contenedor Docker utilizando DataGrip. A continuación, se detallan los pasos necesarios para completar esta tarea.

## Requisitos

- Docker
- DataGrip
- Python
- Librerías de Python: `pandas`, `sqlalchemy`, `openpyxl`

## Archivos del Proyecto

- `script.py`: Script para cargar los archivos Excel a la base de datos.
- `create-tablas.sql`: Script SQL para la creación de las tablas.
- `insert-proyecto1.sql`: Script SQL para insertar los datos en las tablas correspondientes.
- Archivos Excel: `prestamo.xlsx` y `pagos_realizados.xlsx`.

## Pasos para Cargar los Datos

### 1. Configurar el Contenedor Docker

Primero, asegúrate de tener Docker instalado y ejecutándose. Luego, crea y ejecuta un contenedor para tu base de datos. Por ejemplo, si estás utilizando PostgreSQL:

### 2. Conectar DataGrip al Contenedor Docker

Abre DataGrip y configura una nueva conexión a la base de datos utilizando los detalles del contenedor Docker.

### 3. Ejecutar el Script de Python

Ejecuta el script `script.py` para cargar los datos desde los archivos Excel a la base de datos. Asegúrate de tener las librerías necesarias instaladas:

### 4. Crear las Tablas

Ejecuta el script `create-tablas.sql` en DataGrip para crear las tablas necesarias en el esquema proyecto1.

### 5. Insertar los Datos

Ejecuta el script `insert-proyecto1.sql` en DataGrip para insertar los datos en las tablas correspondientes.

### 6. Eliminar Tablas Temporales

Finalmente, elimina las tablas temporales `prestamo.xlsx` y `pagos_realizados.xlsx` ejecutando el siguiente comando en DataGrip:

-- DROP TABLE IF EXISTS prestamos;

-- DROP TABLE IF EXISTS pagos_realizados;


## Enlaces a los Archivos

- [script.py](./Proyecto1/script.py)
- [create-tablas.sql](./Proyecto1/create-tablas.sql)
- [insert-proyecto1.sql](./Proyecto1/insert-proyecto1.sql)
- [prestamo.xlsx](./Proyecto1/prestamo.xlsx)
- [pagos_realizados.xlsx](./Proyecto1/pagos_realizados.xlsx)



