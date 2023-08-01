#!/bin/bash
################################################################
## This script runs a simulation on the cluster. It works by  ##
## simultaneously starting the EUFS simulator and the UGRDV   ##
## software, after which the data logger is started. The sim- ##
## ulation is stopped after a certain amount of time.         ##
## TODO: add a health check after running a simulation.       ##
################################################################

if [[ -z "${SCRIPTS_REPO}" ]]; then
        echo "SCRIPTS_REPO not set."
        exit 1
fi

source "${SCRIPTS_REPO}/scripts/utils.bash" || exit 1

run_and_log source_ros

if [[ "${#}" -ne "1" ]]; then
        die "Usage: run_simulation.bash <simulation duration in seconds>"
fi

simulation_seconds="${1}"

run_and_log cd "${UGRWS_DIR}/ros2_ws" || die "Unable to CD to UGRWS_DIR."

next_track=$("${SCRIPTS_REPO}/scripts/next_track.py") || die "Couldn't fetch next track."
log "next_track: ${next_track}"

log_folder="${HOME}/.run_simulation/${next_track}"
run_and_log mkdir -p "${log_folder}"

ros2 launch ugrdv_backup_main eufs_simulatedperception_comms.launch.py \
        &> "${log_folder}/ugrdv_backup_main.log" &
ugrdv_pid="${!}"

ros2 launch eufs_launcher simulation.launch.py \
        "track:=${next_track}" \
        "commandMode:=acceleration" \
        "rviz:=false" \
        "show_rqt_gui:=false" \
        "pub_ground_truth:=true" \
        "launch_group:=no_perception" \
        &> "${log_folder}/eufs_launcher.log" &
eufs_pid="${!}"

log "Starting perception model."

ros2 run sim_data_collection perception_model --ros-args -p model:=realistic \
        &> "${log_folder}/perception_model.log" &
perception_model_pid="${!}"

log "Waiting for nodes to spin up."
run_and_log sleep 30

timeout_seconds=120
log "Waiting for EUFS_SIM service."
timeout "${timeout_seconds}" bash -c "while ! ros2 service list | grep ros_can/set_mission &> /dev/null; do sleep 1; done; echo Found Service."
timeout "${timeout_seconds}" ros2 service call /ros_can/set_mission eufs_msgs/SetCanState '{"ami_state" : 14, "as_state": 1}'
if [[ "${?}" -ne "0" ]]; then
        die "Unable to call EUFS service."
fi
ros2 run sim_data_collection data_collector --ros-args \
        -p "database:=${next_track}.db3" \
        &> "${log_folder}/sim_data_collection.log" &
data_pid="${!}"
tail -f "${log_folder}/sim_data_collection.log" &
log "Waiting for simulation to end."
run_and_log sleep "${simulation_seconds}"
log "Time's up, stopping data collection."
database="$("${SCRIPTS_REPO}/scripts/get_pkg_share.py" sim_data_collection)/${next_track}.db3"
run_and_log timeout "${timeout_seconds}" ros2 service call /sim_data_collection/stop_collection std_srvs/Trigger
if [[ "${?}" -ne "0" ]]; then
        rm ${database}
        die "Unable to cleanly stop the data collection service."
else
        log "Waiting for sim_data_collection to exit..."
        wait "${data_pid}" || die "sim_data_collection exited with nonzero error code ${?}"
        log "Running integrity check on '${database}'"
        run_and_log ros2 run sim_data_collection integrity_check "${database}" \
                &> "${log_folder}/integrity_check.log"
        if [[ "${?}" -ne "0" ]]; then
                rm ${database}
                die "Integrity check failed. Exiting."
        fi
        log "Finished cleanly. Exiting."
fi

exit 0
