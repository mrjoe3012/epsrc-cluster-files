# Overview

This repository contains the cluster-side scripts used in this [EPSRC Vacation Internship](https://www.gla.ac.uk/colleges/scienceengineering/students/epsrcvacationinternships2023/anevaluationofmodel-basedmethodsforcontrolindriverlessracing/)

| Script | Description |
| - | - |
| next_value.py \<filename\> [-r,-reset] | A general purpose iterator resource which stores an integral value inside of a file, retrieiving and incrementing it upon request. |
| run_simulation.bash \<num_seconds\> | A bash script used in the simulation running job. This script run the UGRDV software alongside the EUFS simulator and data logger for a specified number of seconds. Upon completion, a health check is conducted and the job exits nonzero if the database is corrupted. |
| get_pkg_share.py \<pkg1\> \<pkg2\> ... | Acts as a CLI for the ament_index_python:get_package_share_directory function. |
| track_generation.bash | Runs the headless track generator and generates random tracks. |

## Environment Variables

Please ensure the following environment variables are set before running any script in this repository.

| Name | Description |
| - | - |
| UGRWS_DIR | The path to the root directory of the UGRDV repository. |
| SCRIPTS_REPO | The path to the root directory of this repository. |
| DATA_COLLECTION_REPO | The path to the root directory of the sim_data_collection data logger repository. |
| EUFS_MASTER | The path to the root directory of the EUFS Sim repo. |