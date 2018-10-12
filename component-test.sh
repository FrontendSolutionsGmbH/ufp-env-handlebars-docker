#!/usr/bin/env bash


./build.sh

 docker-compose -f ./ct/docker-compose.yml build --no-cache
 docker-compose -f ./ct/docker-compose.yml up
