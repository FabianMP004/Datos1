import pandas as pd
from sqlalchemy import create_engine

# Conectar con la base de datos PostgreSQL
engine = create_engine('postgresql://test:test123@localhost/proyectodatos')

# Leer el archivo Excel en lugar de CSV
df = pd.read_excel('pagos_realizados.xlsx')
with engine.begin() as cursor:
    df.to_sql('pagos_realizados', schema='miprestamo', con=cursor, if_exists='replace')

# Leer el otro archivo Excel
dfe = pd.read_excel('prestamos.xlsx')
with engine.begin() as cursor:
    dfe.to_sql('prestamos', schema='miprestamo', con=cursor, if_exists='replace')
