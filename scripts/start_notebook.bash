#!/bin/bash
if [[ -z "${EPSRC_MASTER}" ]]; then
    echo "EPSRC_MASTER not set."
    exit 1
fi

source "${EPSRC_MASTER}/epsrc-cluster-files/scripts/utils.bash"

source_ros
run_and_log pip install tqdm ray[tune]
run_and_log pip install -U ipywidgets
cd "${EPSRC_MASTER}/epsrc-vehicle-model" || die "Couldn't cd into EPSRC_MASTER/epsrc-vehicle-model"
./build.bash
jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token= --notebook-dir="${EPSRC_MASTER}/epsrc-vehicle-model"
