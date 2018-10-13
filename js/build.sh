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
webpack --entry ./server/server.js --target node  --output-filename index.js   --output-path dist/server
echo "------------------------------------------------------------------------------"
echo "Executing Webpack for handlebars/index.js"
echo "------------------------------------------------------------------------------"
webpack --entry ./handlebars/handlebars.js --target node  --output-filename index.js    --output-path dist/handlebars

echo "------------------------------------------------------------------------------"
echo "Manually copying static assets"
echo "------------------------------------------------------------------------------"

cp -r ./static/* ./dist
