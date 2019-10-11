FROM node:12.7-alpine

WORKDIR /home/node/app

COPY . .

RUN npm install

EXPOSE 8081

CMD [ "node", "app.js" ]

