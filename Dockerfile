FROM node:20

RUN apt-get update && apt-get install -y pgloader

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

CMD ["npm", "run", "start"]