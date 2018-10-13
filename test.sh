#!/usr/bin/env bash

log(){
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $@"
}

INPUT=$@
TEARDOWN=1
CREATE="-c"
help() {
  echo " Executes the component tests"
  echo " Options:"
  echo "   -t          No Teardown keeps infrastructure up for inspection after test"
  echo "   -c          do not recreate images"

}

while getopts 'thc' OPTION; do
  case $OPTION in
    t)
        TEARDOWN=0
    ;;
    c)
        CREATE=""
    ;;

    h)
        help
        exit 0
    ;;
  esac
done
log "------------------------------------------------------------------------------"
log "Bringing up Infrastructure "
log "------------------------------------------------------------------------------"

./stack.sh -d service ${CREATE}
./stack.sh -u service -b

log "------------------------------------------------------------------------------"
log "Executing component test "
log "------------------------------------------------------------------------------"

./stack.sh -d test ${CREATE}
./stack.sh -u test
TEST_RESULT=$?


if [ "$TEARDOWN" -eq "1" ]; then

	log "------------------------------------------------------------------------------"
	log "Shutting down Infrastructure "
	log "------------------------------------------------------------------------------"

	./stack.sh -d service
fi

log "EXITING WITH ${TEST_RESULT}"
exit ${TEST_RESULT}
