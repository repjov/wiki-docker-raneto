# docker run -v `pwd`/content/:/data/content/ -v `pwd`/config/config.default.js:/opt/raneto/example/config.default.js -p 3000:3000 -d appsecco/raneto
#
# Reference (https://github.com/sparkfabrik/docker-node-raneto)
# Using official node:slim from the dockerhub (https://hub.docker.com/_/node/)
FROM node:slim
LABEL maintainer="Madhu Akula <madhu@appsecco.com>"

# Change the raneto version based on version you want to use
ENV RANETO_VERSION master
ENV RANETO_INSTALL_DIR /opt/raneto

# Get Raneto from sources
RUN cd /tmp \
    && curl -SLO "https://github.com/repjov/Raneto/archive/$RANETO_VERSION.tar.gz" \
    && mkdir -p $RANETO_INSTALL_DIR \
    && tar -xzf "$RANETO_VERSION.tar.gz" -C $RANETO_INSTALL_DIR --strip-components=1 \
    && rm "$RANETO_VERSION.tar.gz"

# RUN mkdir -p /var/www/current
# COPY src/package.json .
# RUN cd $RANETO_INSTALL_DIR && npm install

# Installing dependencies
RUN npm install --global gulp-cli pm2

# Copy config
COPY config/config.default.js $RANETO_INSTALL_DIR/example/config.default.js

# Entering into the Raneto directory
WORKDIR $RANETO_INSTALL_DIR

# Installing Raneto
RUN npm install \
    # && rm -f $RANETO_INSTALL_DIR/example/config.default.js \
    && gulp

# Exposed the raneto default port 3000
EXPOSE 3000

# Starting the raneto
CMD [ "pm2", "start", "/opt/raneto/example/server.js", "--name", "wikilds", "--no-daemon" ]
