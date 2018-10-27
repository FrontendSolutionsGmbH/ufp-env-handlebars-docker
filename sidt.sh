#!/usr/bin/env bash
log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

log ""
log "SIDT - Service Infrastructure Debug Test"
log ""



###
# Variables
###
PROJECT_NAME="ckleinhuis/ufp-env-handlebars"
VERSION=5
SCRIPT_PATH=$(realpath "$0")
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
SCRIPT_HOME=${SCRIPT_PATH%$SCRIPT_NAME}

STACK_LOCATION_SERVICE="${SCRIPT_HOME}ct/docker-compose-service.yml"
STACK_LOCATION_INFRA="${SCRIPT_HOME}ct/docker-compose-infrastructure.yml"
STACK_LOCATION_DEBUG="${SCRIPT_HOME}ct/docker-compose-debug.yml"
STACK_LOCATION_TEST="${SCRIPT_HOME}ct/docker-compose-test.yml"


START=1
STOP=0

STACK_INFRA=0
STACK_DEBUG=0
STACK_SERVICE=1
STACK_TEST=0
LOG_STACK=0
DEBUG=0


BACKGROUND=""
CREATE=0

COMPOSE_PROJECT_NAME="${PROJECT_NAME}componenttest"

RESULT=0
###
# Functions
###

help() {
  echo " Starts/Stops the local stack and their debug-tools."
  echo " Options:"
  echo "   -h          Show this help"
  echo "   -p          Pulls the latest docker images"
  echo "   -b          Starts stack in background with -d"
  echo "   -c          (re-)create container stacks"
  echo "   -l <stack>  Show the logs of stacks"
  echo "   -u <stack>  Starts the given stack. Possible stacks see below!"
  echo "   -d <stack>  Stops the given stack. Possible stacks see below!"
  echo ""
  echo "   Possible Stacks:"
  echo "     infra     The infrastructure needed by the services"
  echo "     service   The involved services"
  echo "     debug     The debug tools"
  echo "     all       All these stacks"
  echo ""
  echo " Default behavior: Starts the service only"
  echo ""
  echo " (continued) author: ck@froso.de"
  echo " (initial) author: s.schumann@tarent.de"
}

pullStack() {
    COMPOSE_FILENAME=$1

	log "Pulling Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} pull
}

logStack() {
    COMPOSE_FILENAME=$1
    log "Loggin Stack ${COMPOSE_FILENAME}"
    docker-compose -f ${COMPOSE_FILENAME} logs
}

startStack() {
    COMPOSE_FILENAME=$1

	log "(Re-)Starting Stack ${COMPOSE_FILENAME}"

	stopStack  $COMPOSE_FILENAME
    if [ "$CREATE" -eq "1" ]; then
	log "(Re-)Creating Stack ${COMPOSE_FILENAME}"

	  if [ "$COMPOSE_FILENAME" = "$STACK_LOCATION_SERVICE" ]; then
    	#    hnandle call to docker build of main service in root Dockerfile
	log "Building main docker image $PROJECT_NAME:$VERSION"
        docker build --no-cache -t $PROJECT_NAME:$VERSION .
        docker build -t $PROJECT_NAME:latest .
    fi

		docker-compose -f $COMPOSE_FILENAME build --no-cache  --force-rm

	fi

    docker-compose -f $1 -p ${COMPOSE_PROJECT_NAME} up ${BACKGROUND}
}
stopStack() {

    COMPOSE_FILENAME=$1
	log "Stopping Stack ${COMPOSE_FILENAME}"

    docker-compose -f ${COMPOSE_FILENAME} -p ${COMPOSE_PROJECT_NAME} down
}

logAllImages() {
    logStack ${STACK_LOCATION_SERVICE}
    logStack ${STACK_LOCATION_INFRA}
    logStack ${STACK_LOCATION_DEBUG}
    logStack ${STACK_LOCATION_TEST}
}

pullAllImages() {
    pullStack ${STACK_LOCATION_SERVICE}
    pullStack ${STACK_LOCATION_INFRA}
    pullStack ${STACK_LOCATION_DEBUG}
    pullStack ${STACK_LOCATION_TEST}
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

###
# Main
###

if [ "$#" -ge 1 ]; then
    STACK_SERVICE=0
fi

while getopts 'u:d:hpl:bc' OPTION; do
  case $OPTION in
    b)
    	log "Background flag -b found, starting in background"
        BACKGROUND="-d"
    ;;
    p)
    	log "Pull All Images flag -p found, pulling all images"
        pullAllImages
    ;;
    c)
    	log "Create flag -c found, (re-)creating stacks/images"
        CREATE=1
    ;;

    l)
    	log "Log flag -l found, logging  stacks"
#        logAllImages
		LOG_STACK=1
        START=0
        STOP=0
        chooseServices $OPTARG
    ;;
    u)
    	log "Start flag -u found, starting"
        START=1
        STOP=0
        chooseServices $OPTARG
    ;;
    d)
    	log "Stop flag -d found, stopping"
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


#log "SCRIPT_PATH=${SCRIPT_PATH}"
#log "SCRIPT_NAME=${SCRIPT_NAME}"
#log "SCRIPT_HOME=${SCRIPT_HOME}"
#log "START=${START}"
#log "STOP=${STOP}"
#log "STACK_INFRA=${STACK_INFRA}"
#log "STACK_DEBUG=${STACK_DEBUG}"
#log "STACK_SERVICE=${STACK_SERVICE}"
#log "STACK_TEST=${STACK_TEST}"
#log "CREATE=${CREATE}"


log ""
log "SIDT - Performing action"
log ""
set -x
execute(){
    log "Executing ${1}"

    if [ "$STOP" -eq "1" ];then stopStack $1 ;fi
    if [ "$START" -eq "1" ];then startStack $1 ;fi
    if [ "$LOG_STACK" -eq "1" ];then logStack $1 ;fi
}

if [ "$DEBUG" -eq "1" ]; then
set -x
fi

if [ "$STACK_INFRA" -eq "1" ]; then
   execute $STACK_LOCATION_INFRA
fi

if [ "$STACK_SERVICE" -eq "1" ]; then

   execute $STACK_LOCATION_SERVICE
fi

if [ "$STACK_DEBUG" -eq "1" ]; then

   execute $STACK_LOCATION_DEBUG
fi

if [ "$STACK_TEST" -eq "1" ]; then

   execute $STACK_LOCATION_TEST
fi

log ""
log "SIDT - Service Infrastructure Debug Test Exit"
log ""
exit ${RESULT}
