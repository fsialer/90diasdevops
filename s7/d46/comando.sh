#Revisión de dependencias
## Si usas python
# Ver vulnerabilidades conocidas en requirements.txt
trivy fs --scanners vuln,secret --severity HIGH,CRITICAL .
## Si usas noejs
npm audit fix