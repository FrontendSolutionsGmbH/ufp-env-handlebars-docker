#!/usr/bin/env bash

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
echo "------------------------------------------------------------------------------"
echo "Bringing up Infrastructure "
echo "------------------------------------------------------------------------------"

./stack.sh -d service ${CREATE}
./stack.sh -u service -b ${CREATE}

echo "------------------------------------------------------------------------------"
echo "Executing component test "
echo "------------------------------------------------------------------------------"

./stack.sh -d test ${CREATE}
./stack.sh -u test ${CREATE}
TEST_RESULT=$?


if [ "$TEARDOWN" -eq "1" ]; then

	echo "------------------------------------------------------------------------------"
	echo "Shutting down Infrastructure "
	echo "------------------------------------------------------------------------------"

	./stack.sh -d service
fi

echo "EXITING WITH ${TEST_RESULT}"
exit ${TEST_RESULT}
