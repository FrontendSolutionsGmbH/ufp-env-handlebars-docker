FROM node:8-alpine as builder

# Setup binary pathes for project node modules
ENV PATH ${PATH}:/ufp-env-handlebars-build/node_modules/.bin

# Set up working directory, copying our local js folder as buil
COPY js/ /ufp-env-handlebars-build

WORKDIR /ufp-env-handlebars-build/js

# Install dependencies (node modules is mounted, so if present will be used)
RUN yarn install

RUN ls /ufp-env-handlebars-build/js
RUN yarn install --production=true
RUN ls /ufp-env-handlebars-build/js

# final step build distribution and execute the parse and serve steps
FROM node:8-alpine
#
# so extensive handlebars helpers require original node_modules for accessing non bundled
# lazy loading parts, hence we copy the full node_modules to dist
#
COPY --from=builder /ufp-env-handlebars-build /ufp-env-handlebars



WORKDIR /ufp-env-handlebars
RUN ls -la
RUN ls -la static
RUN ls -la static/config
RUN pwd
RUN static/config/getjsondataexample.sh
RUN /ufp-env-handlebars/static/config/getjsondataexample.sh
EXPOSE 3000:3000
CMD ["node","./execute.js"]
