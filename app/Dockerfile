FROM node:18-slim

# Crear directorio
WORKDIR /app

# copiar los archivos js al contenedor
COPY . .

RUN npm install

EXPOSE 3000

# comando por defecto: ejecuacion de js
CMD ["node","server.js"]



 
