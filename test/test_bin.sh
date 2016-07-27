#!/bin/bash

# Test script

FILE=$1

echo "" >&2
echo "Testing $FILE file" >&2
echo "------------------------------" >&2

function test0 {
    if "${@:2}"
    then
        echo "$1" >&2
    else
        echo "$1 [FAILED]" >&2
        exit 1
    fi
}

function test1 {
    test0 "- 1. File exists" test -e $1
}

function test2 {
    test0 "- 2. File is executable" test -x $1
}

function test3 {
    output=$(ldd $1 | grep "not a dynamic executable")
    test0 "- 3. File is static" test -n "$output"
}

test1 $FILE
test2 $FILE
test3 $FILE

echo "------------------------------" >&2
echo "All tests [PASSED]" >&2
echo "" >&2
