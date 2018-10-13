#!/usr/bin/env bash


./build.sh


echo "------------------------------------------------------------------------------"
echo "Bringing up Infrastructure "
echo "------------------------------------------------------------------------------"

docker-compose -f ./ct/docker-compose.yml up -d

echo "------------------------------------------------------------------------------"
echo "Executing component test "
echo "------------------------------------------------------------------------------"

docker-compose -f ./ct/docker-compose-test.yml up

echo "------------------------------------------------------------------------------"
echo "Shutting down Infrastructure "
echo "------------------------------------------------------------------------------"

docker-compose -f ./ct/docker-compose.yml down
