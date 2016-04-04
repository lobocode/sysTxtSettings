FROM node:0.10

# crafted and tuned by lobocode
MAINTAINER lobocode@fedoraproject.org

RUN groupadd -r rocketchat \
&&  useradd -r -g rocketchat rocketchat

VOLUME /app/uploads

ENV RC_VERSION 0.24.0

WORKDIR /app

RUN curl -fSL "https://rocket.chat/releases/${RC_VERSION}/download" -o rocket.chat.tgz \
&&  curl -fSL "https://rocket.chat/releases/${RC_VERSION}/asc" -o rocket.chat.tgz.asc \
&&  tar zxvf rocket.chat.tgz \
&&  rm rocket.chat.tgz rocket.chat.tgz.asc \
&&  cd bundle/programs/server \
&&  npm install

USER rocketchat

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'db'
ENV MONGO_URL=mongodb://db:27017/meteor \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]

