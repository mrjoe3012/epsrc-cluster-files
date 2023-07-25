#!/bin/bash
# TODO: header

if [[ -z "${SCRIPTS_REPO}" ]]; then
    echo "SCRIPTS_REPO not set."
    exit 1
fi

source "${SCRIPTS_REPO}/scripts/utils.bash" || exit 1

run_and_log source_ros

if [[ "${#}" -lt "2" ]]; then
    die "Usage: analyse_data.bash <num dbs to process> <dbs>"
fi

num_to_process="${1}"
databases=(${@:2})

echo "num_to_process: ${num_to_process}"
echo "datasets: ${databases[@]}"

num_dbs=${#databases[@]}
echo "num_dbs: ${#databases[@]}"

process_number=$("${SCRIPTS_REPO}/scripts/next_value.py" ${HOME}/proc_num.txt)
db_idx=$((((num_dbs/num_to_process)*process_number)+1))
echo "db_idx: ${db_idx} process_number: ${process_number} databases: ${databases[@]} num_dbs: ${num_dbs}"
ros2 run sim_data_collection analysis analyse analysis.json "${databases[@]:db_idx:num_to_process}"
