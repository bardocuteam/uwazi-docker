FROM node:16-buster
LABEL maintainer="Emerson Rocha <rocha@ieee.org>"

ARG UWAZI_VERSION=1.110.1
# see https://github.com/nodejs/docker-node#how-to-use-this-image

## Install common software
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  bzip2 \
  dh-autoreconf \
  git \
  libpng-dev \
  poppler-utils \
  gnupg

# Install mongo & mongorestore (this is used only for database initialization, not on runtime)
# So much space need, see 'After this operation, 184 MB of additional disk space will be used.'
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add - \
  && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list \
  && apt-get update \
  && apt-get install -y mongodb-org-tools mongodb-org-shell \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

## Download Uwazi v1.4
RUN mkdir -p /home/node/uwazi-download \
  && wget -qO- "https://github.com/huridocs/uwazi/releases/download/$UWAZI_VERSION/uwazi.tgz" | tar xz -C /home/node/uwazi-download \
  && mv /home/node/uwazi-download/prod /home/node/uwazi \
  && rm -rf /home/node/uwazi-download \
  && chown node:node -R /home/node/uwazi/

# Add wait for it
COPY --chown=node:node wait-for-it.sh /wait-for-it.sh

WORKDIR /home/node/uwazi/
COPY --chown=node:node docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
