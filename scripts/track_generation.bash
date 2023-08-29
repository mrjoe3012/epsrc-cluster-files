#!/bin/bash
################################################################
## This script runs the headless track genrator to generate   ##
## tracks. The amount of tracks generated is configured thro- ##
## ugh the headless track generator's config file.            ##
################################################################

if [[ -z "${EPSRC_MASTER}" ]]; then
        echo "EPSRC_MASTER not set."
        exit 1
fi

source "${EPSRC_MASTER}/epsrc-cluster-files/scripts/utils.bash"
source_ros

log "Spawning instance..."
next_seed=$("${EPSRC_MASTER}/epsrc-cluster-files/scripts/next_value.py" "${HOME}/seed.txt")
if [[ "${?}" -ne "0" ]]; then die "Unable to get next seed."; fi
eufs_tracks_share=$("${EPSRC_MASTER}/epsrc-cluster-files/scripts/get_pkg_share.py" "eufs_tracks")
if [[ "${?}" -ne "0" ]]; then die "Unable to get eufs_tracks share directory"; fi

run_and_log ros2 run eufs_tracks headless_track_generator --ros-args \
        --params-file "${eufs_tracks_share}/params/headless_track_generator.yaml" \
        -p use_custom_seed:=true \
        -p "seed:=${next_seed}"
if [[ "${?}" -ne "0" ]]; then die "headless_track_generator returned nonzero."; fi

log "Success, terminating..."
exit 0
