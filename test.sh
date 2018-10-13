#!/usr/bin/env bash

INPUT=$@
TEARDOWN=1
CREATE=1
help() {
  echo " Executes the component tests"
  echo " Options:"
  echo "   -t          No Teardown keeps infrastructure up for inspection after test"
  echo "   -c          recreate images"

}

while getopts 'thc' OPTION; do
  case $OPTION in
    t)
        TEARDOWN=0
    ;;
    c)
        CREATE="-c"
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

echo "------------------------------------------------------------------------------"
echo "Shutting down Infrastructure "
echo "------------------------------------------------------------------------------"


if [ "$TEARDOWN" -eq "1" ]; then
	./stack.sh -d service ${CREATE}
fi

echo "EXITING WITH ${TEST_RESULT}"
exit ${TEST_RESULT}
