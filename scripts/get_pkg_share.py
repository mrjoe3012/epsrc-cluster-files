#!/bin/python3
################################################################
## This script acts a command-line interface to the ROS 2     ##
## ament_index get_package_share_directory() function.        ##
################################################################

import sys
from ament_index_python import get_package_share_directory

def print_usage():
    print("Usage: get_pkg_share.py <pkg1_name> <pkg2_name> ...")

def main():
    if len(sys.argv) == 1:
        print_usage()
        sys.exit()
    else:
        packages = sys.argv[1:]
        directories = []
        for package in packages:
            directories.append(get_package_share_directory(package))
        print(" ".join(directories))

if __name__ == "__main__":
    main()
