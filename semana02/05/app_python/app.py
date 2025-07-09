import mysql.connector
from mysql.connector import Error

def conectar_mysql():
    try:
        connection = mysql.connector.connect(
            host='my_mysql',        # nombre del contenedor MySQL en la red Docker
            port=3306,              # puerto interno del contenedor MySQL
            user='root',
            password='password',    # usa la misma contraseña que definiste al crear el contenedor
            database='testdb'       # asegúrate de que esta BD exista
        )

        if connection.is_connected():
            print("✅ Conexión exitosa a MySQL")
            cursor = connection.cursor()
            cursor.execute("SELECT DATABASE();")
            row = cursor.fetchone()
            print("📂 Base de datos actual:", row)

    except Error as e:
        print("❌ Error al conectar a MySQL:", e)

    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            print("🔌 Conexión cerrada.")

if __name__ == "__main__":
    conectar_mysql()