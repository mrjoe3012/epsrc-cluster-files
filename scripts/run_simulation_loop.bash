if [[ "${#}" -ne "3" ]]; then
    echo "Usage: run_simulation_loop.bash <number of sims to run> <seconds> <perception>"
    exit 1
fi

num="${1}"
seconds="${2}"
perception="${3}"

for ((i=1;i<num;i++)); do
    code=1
    while [[ "${code}" -ne "0" ]]; do
        /nfs/cluster-files/scripts/run_simulation.bash "${seconds}" "${perception}"
        code="$?"
        source /nfs/ugrdv/scripts/KillAllROS.bash
    done
done
