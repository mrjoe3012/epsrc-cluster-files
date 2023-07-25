#!/bin/bash
# TODO: header

if [[ -z "${SCRIPTS_REPO}" ]]; then
    echo "SCRIPTS_REPO not set."
    exit 1
fi

source "${SCRIPTS_REPO}/scripts/utils.bash" || exit 1

run_and_log source_ros

if [[ "${#}" -ne "2" ]]; then
    die "Usage: analyse_data.bash <num dbs to process> <dataset directory>"
fi

num_to_process="${1}"
datasets_dir="${2}"

echo "num_to_process: ${num_to_process}"
echo "datasets_dir: ${datasets_dir}"

if ! [[ -d  ${datasets_dir} ]]; then
    die "${datasets_dir} is not a valid directory."
fi

databases=("${datasets_dir}"/*)
num_dbs=${#databases[@]}

process_number=$("${SCRIPTS_REPO}/scripts/next_value.py" ${HOME}/proc_num.txt)
db_idx=$(((num_dbs/process_number)*num_to_process))
ros2 run sim_data_collection analysis analyse "${databases[@]:db_idx:num_to_process}"
