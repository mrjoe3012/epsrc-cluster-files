# Overview

This repository contains the cluster-side scripts used in this [EPSRC Vacation Internship](https://www.gla.ac.uk/colleges/scienceengineering/students/epsrcvacationinternships2023/anevaluationofmodel-basedmethodsforcontrolindriverlessracing/)

| Script | Description |
| - | - |
| next_value.py \<filename\> [-r,-reset] | A general purpose iterator resource which stores an integral value inside of a file, retrieiving and incrementing it upon request. |
| run_simulation.bash \<num_seconds\> | A bash script used in the simulation running job. This script run the UGRDV software alongside the EUFS simulator and data logger for a specified number of seconds. Upon completion, a health check is conducted and the job exits nonzero if the database is corrupted. |