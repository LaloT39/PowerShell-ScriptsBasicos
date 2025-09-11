import sys
import requests
import time
import os
import getpass
import csv
import logging

#Lo hice en otro archivo y pues aparece todo modificado
#LALOT 9/11/2025

logging.basicConfig(
    filename="registro.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
if len(sys.argv) != 2:
    print("Uso: python verificar_correo.py correo@example.com")
    sys.exit(1)
correo = sys.argv[1]
api_key_path = "apikey.txt"
if not os.path.exists(api_key_path):
    print("No se encontro el archivo apykey.txt.")
    clave = getpass.getpass("Ingresa tu apikey:")
    try:
        with open(api_key_path, "w") as archivo:
            archivo.write(clave)
    except Exception as e:
        logging.error(f"No se pudo guarar la API key: {e}")
        sys.exit(1)
try:
    with open("apikey.txt", "r") as archivo:
        api_key = archivo.read().strip()
except Exception as e:
    print("Error al leer la APIKEY.")
    logging.error(f"No se pudo leer apikey.txt: {e}")
    sys.exit(1)
url = f"https://haveibeenpwned.com/api/v3/breachedaccount/{correo}"
headers = {
    "hibp-api-key": api_key,
    "user-agent": "PythonScript"
}
try:
    response = requests.get(url, headers=headers)
except Exception as e:
    print("Error al realizar la conexion")
    logging.error(f"Error de conexion {e}")
    sys.exit(1)
if response.status_code == 200:
    brechas = response.json()
    logging.info(f"Consulta exitosa para {correo}. Brechas encontradas> {len(brechas)}")
    try:
        with open("reporte.csv", "w", newline='', encoding="utf-8") as archivo_csv:
            writer = csv.writer(archivo_csv)
            writer.writerow(["Titulo", "Dominio", "Fecha de Brecha",
                            "Datos Comprometidos", "Verificada", "Sensible"])
            for i, brecha in enumerate(brechas[:3]):
                nombre = brecha['Name']
                detalle_url = f"https://haveibeenpwned.com/api/v3/breach/{nombre}"
                try:
                    detalle_resp = requests.get(detalle_url, headers=headers)
                    if detalle_resp.status_code == 200:
                        detalle = detalle_resp.json()
                        writer.writerow([
                            detalle.get('Title'),
                            detalle.get('Domain'),
                            detalle.get('BreachDate'),
                            ", ".join(detalle.get('DataClasses', [])),
                            "Si" if detalle.get('IsVerified') else "No",
                            "Si" if detalle.get('IsSensitive') else "No"
                        ])
                    else:
                        msj = f"No se pudo obtener detalles de la brecha: {nombre}"
                        msj += f"Codigo: {detalle_resp.status_code}"
                        logging.error(msj)
                except Exception as e:
                    logging.error(f"Error al obtener detalles de la brecha {nombre}: {e}")
                if i < 2:
                    time.sleep(10)
    except Exception as e:
        print("Error al generar el archivo CSV")
        logging.error(f"Error al crear el reporte CSV: {e}")
        sys.exit(1)
    print("Consulta completada. Revisa el archivo reporte.csv para ver los resultados.")
elif response.status_code == 404:
    print(f"La cuenta {correo} no aparece en ninguna brecha conocida.")
    logging.info(f"Consulta exitosa para {correo}. No se encontraron brechas")
elif response.status_code == 401:
    print("Error de autenticación: revisa tu API key.")
    logging.error("Error 401: Api key invalida")
else:
    print(f"Error inesperado. Código de estado: {response.status_code}")
    logging.error(f"Error inesperado. Codigo de estado: {response.status_code}")
