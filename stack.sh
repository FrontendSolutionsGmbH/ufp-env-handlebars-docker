#!/usr/bin/env bash

###
# Variables
###
SCRIPT_PATH=$(realpath "$0")
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_HOME=${SCRIPT_PATH%$SCRIPT_NAME}

START=1
STOP=0

STACK_INFRA=0
STACK_DEBUG=0
STACK_SERVICE=1
STACK_TEST=0

BACKGROUND=""

COMPOSE_PROJECT_NAME="ct"

###
# Functions
###

help() {
  echo " Starts/Stops the local stack and their debug-tools."
  echo " Options:"
  echo "   -h          Show this help"
  echo "   -p          Pulls the latest docker images"
  echo "   -l          Show the logs"
  echo "   -u <stack>  Starts the given stack. Possible stacks see below!"
  echo "   -d <stack>  Stops the given stack. Possible stacks see below!"
  echo ""
  echo "   Possible Stacks:"
  echo "     infra     The infrastructure needed by the services"
  echo "     service   The order-process involved services"
  echo "     debug     The debug tools"
  echo "     all       All these stacks"
  echo ""
  echo " Default behavior: Starts the local-stack (exclusive all debug-tools)"
  echo ""
  echo " (initial) author: s.schumann@tarent.de"
}

pullAllImages() {
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml pull
#    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml pull
#    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml pull
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml pull
    cd -
}

logAllImages() {
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml logs
#    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml logs
#    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml logs
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml logs
    cd -
}

chooseServices() {
    case $1 in
       infra) STACK_INFRA=1;;
       debug) STACK_DEBUG=1 ;;
       service) STACK_SERVICE=1 ;;
       test) STACK_TEST=1 ;;
       all) STACK_SERVICE=1; STACK_DEBUG=1; STACK_INFRA=1;STACK_TEST=1;;
    esac
}

getEnv() {
    cat ${ENV_FILE} | grep ${1} | cut -d\= -f2
}

startInfraStack() {
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml build --no-cache
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml -p ${COMPOSE_PROJECT_NAME} ${BACKGROUND}
    cd -
}

stopInfraStack() {
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-infrastructure.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -
}

startDebugStack(){
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
    cd -
}

stopDebugStack(){
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-debug.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -
}

startServiceStack(){
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
    cd -
}

stopServiceStack(){
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-service.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -
}

startTestStack(){
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
    cd -
}

stopTestStack(){
    cd ${SCRIPT_HOME}/ct/
    docker-compose -f ${SCRIPT_HOME}/ct/docker-compose-test.yml -p ${COMPOSE_PROJECT_NAME} down
    cd -
}


###
# Main
###

if [ "$#" -ge 1 ]; then
    STACK_SERVICE=0
fi

while getopts 'u:d:hplb' OPTION; do
  case $OPTION in
    b)
        BACKGROUND="-d"
    ;;
    p)
        pullAllImages
    ;;
    l)
        logAllImages
    ;;
    u)
        START=1
        STOP=0
        chooseServices $OPTARG
    ;;
    d)
        START=0
        STOP=1
        chooseServices $OPTARG
    ;;
    h)
        help
        exit 0
    ;;
  esac
done

if [ "$STACK_INFRA" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startInfraStack ;fi
    if [ "$STOP" -eq "1" ];then stopInfraStack ;fi
fi
if [ "$STACK_DEBUG" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startDebugStack ;fi
    if [ "$STOP" -eq "1" ];then stopDebugStack ;fi
fi

if [ "$STACK_SERVICE" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startServiceStack ;fi
    if [ "$STOP" -eq "1" ];then stopServiceStack ;fi
fi

if [ "$STACK_TEST" -eq "1" ]; then
    if [ "$START" -eq "1" ];then startTestStack ;fi
    if [ "$STOP" -eq "1" ];then stopTestStack ;fi
fi
