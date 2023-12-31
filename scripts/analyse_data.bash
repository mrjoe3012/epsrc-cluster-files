#!/bin/bash
# TODO: header

if [[ -z "${EPSRC_MASTER}" ]]; then
    echo "EPSRC_MASTER not set."
    exit 1
fi

source "${EPSRC_MASTER}/epsrc-cluster-files/scripts/utils.bash" || exit 1

run_and_log source_ros

if [[ "${#}" -lt "2" ]]; then
    die "Usage: analyse_data.bash <num dbs to process> <dbs>"
fi

num_to_process="${1}"
databases=(${@:2})

num_dbs=${#databases[@]}

process_number=$("${EPSRC_MASTER}/epsrc-cluster-files/scripts/next_value.py" ${HOME}/proc_num.txt)
db_idx=$((num_to_process*process_number))
echo "db_idx: ${db_idx} process_number: ${process_number} databases: ${databases[@]:db_idx:num_to_process} num_dbs: ${num_dbs}"
ros2 run sim_data_collection analysis analyse analysis.json "${databases[@]:db_idx:num_to_process}" || die "Unable to run data analysis"
