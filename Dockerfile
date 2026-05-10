FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

COPY . .

EXPOSE 3000

RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

CMD ["node", "server.js"]

