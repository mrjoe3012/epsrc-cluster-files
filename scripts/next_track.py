#!/bin/python3
import subprocess, json, os, itertools
from ament_index_python import get_package_share_directory

def get_track_index():
    command = ["/nfs/next_seed.py", "/nfs/track.txt"]
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

