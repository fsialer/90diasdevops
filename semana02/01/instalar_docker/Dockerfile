# repositorio git clone https://github.com/docker/getting-started-app.git
FROM node:lts-alpine
WORKDIR /app
COPY . .
RUN npm install --production
CMD ["node", "src/index.js"]
EXPOSE 3000