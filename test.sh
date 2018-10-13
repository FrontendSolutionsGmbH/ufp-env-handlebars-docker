#!/usr/bin/env bash

INPUT=$@

echo "------------------------------------------------------------------------------"
echo "Bringing up Infrastructure "
echo "------------------------------------------------------------------------------"

./stack.sh -d service ${INPUT}
./stack.sh -u service -b ${INPUT}

echo "------------------------------------------------------------------------------"
echo "Executing component test "
echo "------------------------------------------------------------------------------"

./stack.sh -d test ${INPUT}
./stack.sh -u test ${INPUT}
TEST_RESULT=$?

echo "------------------------------------------------------------------------------"
echo "Shutting down Infrastructure "
echo "------------------------------------------------------------------------------"

./stack.sh -d service ${INPUT}

echo "EXITING WITH ${TEST_RESULT}"
exit ${TEST_RESULT}
