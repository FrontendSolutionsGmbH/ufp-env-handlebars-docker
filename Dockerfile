FROM node:8-slim as builder
#VOLUME /ufp-env-handlebars-build/node_modules
# Setup binary pathes for project node modules

ENV PATH ${PATH}:/ufp-env-handlebars-build/node_modules/.bin

# Set up working directory, copying our local js folder as buil
COPY js/ /ufp-env-handlebars-build

WORKDIR /ufp-env-handlebars-build/js

# Install dependencies (node modules is mounted, so if present will be used)
RUN yarn install

# Execute build script which builds the 2 executables parser and server
# RUN ./build.sh

# final step build distribution and execute the parse and serve steps
FROM node:8-slim
# 
# so extensive handlebars helpers require original node_modules for accessing non bundled
# lazy loading parts, hence we copy the full node_modules to dist
# 

COPY --from=builder /ufp-env-handlebars-build /ufp-env-handlebars

WORKDIR /ufp-env-handlebars
EXPOSE 3000:3000
CMD ./execute.sh
