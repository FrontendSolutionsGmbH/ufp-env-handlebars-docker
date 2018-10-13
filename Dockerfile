FROM node:8-slim as builder



 ENV PATH ${PATH}:./node_modules/.bin

COPY js /ufp-env-handlebars-build
WORKDIR /ufp-env-handlebars-build

RUN yarn install
RUN ls -la
RUN pwd
RUN ./build.sh


FROM node:8-slim
COPY js/dist /ufp-env-handlebars
WORKDIR /ufp-env-handlebars
EXPOSE 3000:3000
CMD ./execute.sh
