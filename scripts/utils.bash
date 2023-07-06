#!/bin/bash
################################################################
## This script contains a collection of utility functions     ##
## used in other scripts.                                     ##
################################################################

# echoes its arguments
function log () {
    echo "${@}"
}

# logs a command before running it
function run_and_log () {
    log "${@}"
    ${@}
}

# prints a message and exits with a code
function die () {
    echo "${1}"
    exit "${2}"
}
