#!/bin/bash
################################################################
## This script contains a collection of utility functions     ##
## used in other scripts.                                     ##
################################################################

set -T
trap 'test "$FUNCNAME" = run_and_log || trap_saved_commands="${BASH_COMMAND}"'

# echoes its arguments
function log () {
    echo "${@}"
}

# logs a command before running it
function run_and_log () {
    log "${trap_saved_command#* }"
    "${@}"
}

# prints a message and exits with a code
function die () {
    echo "${@}"
    exit 1
}

# sources all ROS 2 related scripts
function source_ros () {
    if [[ -z "${ROS_HOME}" ]]; then die "ROS_HOME environment variable not set."; fi
    if [[ -z "${ROS_INSTALL}" ]]; then die "ROS_INSTALL environment variable not set."; fi
    if [[ -z "${EUFS_MASTER}" ]]; then die "EUFS_MASTER environment variable not set."; fi
    if [[ -z "${EPSRC_MASTER}" ]]; then die "EPSRC_MASTER environment variable not set."; fi
    if ! [[ -d "${EPSRC_MASTER}/install" ]]; then die "'install' directory not found in EPSRC_MASTER. This please run 'colcon build' in this directory."; fi

    run_and_log source "${ROS_INSTALL}/setup.bash"
    run_and_log source "${EPSRC_MASTER}/install/setup.bash"
}
