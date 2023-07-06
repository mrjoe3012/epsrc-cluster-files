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
    echo "${@}"
    exit 1
}

# sources all ROS 2 related scripts
function source_ros () {
    source /opt/ros/humble/setup.bash
    if [[ -z "${UGRWS_DIR}" ]]; then die "UGRWS_DIR not set."; fi
    if [[ -z "${DATA_COLLECTION_REPO}" ]]; then die "DATA_COLLECTION_REPO not set."; fi
    source "${DATA_COLLECTION_REPO}/install/setup.bash"
    source "${UGRWS_DIR}/ros2_ws/install/setup.bash"
}
