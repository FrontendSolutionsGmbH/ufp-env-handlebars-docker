FROM node:8-slim as builder
#VOLUME /ufp-env-handlebars-build/node_modules
# Setup binary pathes for project node modules

ENV PATH ${PATH}:/ufp-env-handlebars-build/node_modules/.bin

# Set up working directory, copying our local js folder as buil
COPY js/src /ufp-env-handlebars-build/src
COPY js/static /ufp-env-handlebars-build/static
COPY js/build.sh /ufp-env-handlebars-build/build.sh
COPY js/package.json /ufp-env-handlebars-build/package.json
COPY js/yarn.lock /ufp-env-handlebars-build/yarn.lock
WORKDIR /ufp-env-handlebars-build

# Install dependencies (node modules is mounted, so if present will be used)
RUN yarn install

# Execute build script which builds the 2 executables parser and server
RUN ./build.sh

# final step build distribution and execute the parse and serve steps
FROM node:8-slim

COPY --from=builder /ufp-env-handlebars-build/dist /ufp-env-handlebars
WORKDIR /ufp-env-handlebars
EXPOSE 3000:3000
CMD ./execute.sh
