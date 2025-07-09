FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD [ "ls","-l" ]
CMD ["node", "server.js"]