#!/usr/bin/env bash


echo "------------------------------------------------------------------------------"
echo "Building ufp-env-handlebars js executables"
echo "------------------------------------------------------------------------------"


echo "------------------------------------------------------------------------------"
echo "Cleaning ./dist folder"
echo "------------------------------------------------------------------------------"
rm -rf dist
echo "------------------------------------------------------------------------------"
echo "Executing Webpack for server/index.js"
echo "------------------------------------------------------------------------------"
webpack --entry ./src/server/server.js --target node  --output-filename index.js   --output-path dist/server  --mode production
echo "------------------------------------------------------------------------------"
echo "Executing Webpack for handlebars/index.js"
echo "------------------------------------------------------------------------------"
#webpack --entry ./src/handlebars/handlebars.js --target node  --output-filename index.js    --output-path dist/handlebars --mode production --resolve-alias handlebars=handlebars/dist/handlebars.js
webpack --config ./src/handlebars/webpack.config.js


echo "------------------------------------------------------------------------------"
echo "Manually copying static assets"
echo "------------------------------------------------------------------------------"

cp -r ./static/* ./dist
