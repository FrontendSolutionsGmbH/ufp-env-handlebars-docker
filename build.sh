#!/usr/bin/env bash

echo "------------------------------------------------------------------------------"
echo "Building ufp-env-handlebars "
echo "------------------------------------------------------------------------------"

#cd js
#yarn install
#./build.sh
#cd ..

echo "------------------------------------------------------------------------------"
echo "Building ufp-env-handlebars docker file "
echo "------------------------------------------------------------------------------"


docker build --no-cache -t ufp/env-handlebars .


echo "------------------------------------------------------------------------------"
echo "Building finished "
echo "------------------------------------------------------------------------------"


echo "------------------------------------------------------------------------------"
echo "docker run  -p 3000:3000 ufp/env-handlebars "
echo "------------------------------------------------------------------------------"

