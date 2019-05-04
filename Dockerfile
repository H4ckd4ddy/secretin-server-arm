FROM hypriot/rpi-node

ENV BEHIND_REVERSE_PROXY=0
ENV REDIS_URL="redis://anonymous@redis:6379"
ENV COUCHDB_URL="http://admin:password@couchdb:5984/secretin"
ENV PORT=3000

RUN mkdir -p /secretin-server
WORKDIR /secretin-server

COPY package.json /secretin-server
RUN yarn install

COPY . /secretin-server
COPY .es* /secretin-server/

EXPOSE 3000

COPY setup-system-tables-and-start.sh /

RUN chmod 755 /setup-system-tables-and-start.sh

CMD [ "/setup-system-tables-and-start.sh" ]
