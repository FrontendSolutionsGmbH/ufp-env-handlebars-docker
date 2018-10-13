FROM node:8-slim
COPY js/dist /ufp-env-handlebars/dis
COPY js/execute.sh /ufp-env-handlebars/
WORKDIR /ufp-env-handlebars
EXPOSE 3000:3000
CMD ./execute.sh
