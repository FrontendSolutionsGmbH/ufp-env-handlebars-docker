#!/usr/bin/env bash


echo "------------------------------------------------------------------------------"
echo "Cleaning ./dist folder"
echo "------------------------------------------------------------------------------"
rm -rf dist
echo "------------------------------------------------------------------------------"
echo "Executing Webpack for server/server.js"
echo "------------------------------------------------------------------------------"
webpack --entry ./server/server.js --target node  --output-filename server.js   --output-path dist/server
echo "------------------------------------------------------------------------------"
echo "Executing Webpack for handlebars/handlebars.js"
echo "------------------------------------------------------------------------------"
webpack --entry ./handlebars/handlebars.js --target node  --output-filename handlebars.js    --output-path dist/handlebars

echo "------------------------------------------------------------------------------"
echo "Manually copying static assets"
echo "------------------------------------------------------------------------------"

cp -r ./static/ ./dist
