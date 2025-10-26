FROM node:20
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV APP_VERSION=v1
CMD ["node", "index.js"]
