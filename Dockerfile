FROM node:8-slim as builder
VOLUME /ufp-env-handlebars-build/node_modules
# Setup binary pathes for project node modules
ENV PATH ${PATH}:./node_modules/.bin
# Set up working directory, copying our local js folder as buil
COPY js /ufp-env-handlebars-build
WORKDIR /ufp-env-handlebars-build

# Install dependencies (node modules is mounted, so if present will be used)
RUN yarn install

# Execute build script which builds the 2 executables parser and server
RUN ./build.sh

# final step build distribution and execute the parse and serve steps
FROM node:8-slim

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb
RUN dpkg -i dumb-init_*.deb


COPY --from=builder /ufp-env-handlebars-build/dist /ufp-env-handlebars
WORKDIR /ufp-env-handlebars
EXPOSE 3000:3000
# Runs "/usr/bin/dumb-init -- /my/script --with --args"
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ./execute.sh
