
#Ignorar severidades menores
trivy image --exit-code 1 --severity CRITICAL,HIGH nombre-imagen
#Salida en formato JSON
trivy image -f json -o trivy-report.json nombre-imagen
#Escanear el sistema de archivos (proyecto local)
trivy fs --exit-code 1 --severity CRITICAL,HIGH .