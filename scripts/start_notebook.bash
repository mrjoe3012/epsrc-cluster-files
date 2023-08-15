#!/bin/bash
if [[ -z "${SCRIPTS_REPO}" ]]; then
    echo "SCRIPTS_REPO not set."
    exit 1
fi

if [[ -z "${NOTEBOOK_REPO}" ]]; then
    echo "NOTEBOOK_REPO not set."
    exit 1
fi

source "${SCRIPTS_REPO}/scripts/utils.bash"
source_ros
pip install tqdm ray[tune]
pip install -U ipywidgets
cd "${NOTEBOOK_REPO}" || die "Couldn't cd into NOTEBOOK_REPO"
./build.bash
jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token= --notebook-dir="${NOTEBOOK_REPO}"
