FROM --platform=$TARGETPLATFORM node:18-bookworm

RUN mkdir /var/log/acos \
  && chmod 1777 /var/log/acos

# Create app directory
WORKDIR /usr/src/acos-server

# install acos-server itself
# RUN git clone https://github.com/acos-server/acos-server.git . \
RUN git clone https://github.com/Tob229/acos-server.git . \
  && (echo "On branch $(git rev-parse --abbrev-ref HEAD)"; echo; git log -n5) > GIT \
  && rm -rf .git \
  && rm -f package-lock.json

# copy a modified package.json file of the acos-server
# it has additional dependencies in order to install more content types and content packages
COPY package.json ./
COPY config.js ./
RUN rm -rf node_modules \
  && npm update --global npm \
  && npm install \
  && :

VOLUME /var/log/acos
EXPOSE 3000

CMD [ "npm", "start" ]
