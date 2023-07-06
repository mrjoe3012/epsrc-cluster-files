#!/bin/python3
################################################################
## This script makes use of the next_value.py script to       ##
## retrive an index, it the uses it to retrieve the correspo- ##
## nding racetrack name.                                      ##
################################################################

import subprocess, json, os, itertools
from ament_index_python import get_package_share_directory

def get_track_index():
    assert "SCRIPTS_REPO" in os.environ
    command = [
        f"{os.environ['SCRIPTS_REPO']}/scripts/next_track.py",
        f"{os.environ['HOME']}/track.txt",
    ]
    index = int(subprocess.check_output(command))
    return index

def get_track_name(index):
    eufs_tracks = get_package_share_directory("eufs_tracks")
    report_path = os.path.join(eufs_tracks, "report.json") 
    with open(report_path, "r") as f: report_data = json.load(f)
    track_names = list(itertools.chain.from_iterable([x["tracks"] for x in report_data]))
    return track_names[index]

if __name__ == "__main__":
    idx = get_track_index()
    track_name = get_track_name(idx)
    print(track_name)

