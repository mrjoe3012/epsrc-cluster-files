#!/bin/python3
################################################################
## This script is a general purpose 'iterator' style resource ##
## that is designed for concurrent use. An integer value is   ##
## stored in a text file, upon request the integer is retrie- ##
## ved and incremented before being put back in the file.     ##
## This is used to assign different random seeds to pods in a ##
## cluster job or to give each one a sequential id.           ##
################################################################

import fcntl, sys

def print_usage(exit_code=None):
	"""
	This prints a help message and optionally exits
	the script.
	
	:param exit_code: The code to exit with. Does not exit if
	set to None
	"""
	print("Usage: next_value.py <filename> [-r,-reset]")
	if exit_code is not None:
		sys.exit(exit_code)

def handle_args(argv):
	"""
	Parses CLA and returns a filename to operator on
	and whether or not to reset it.
	
	:param argv: The raw CLA list with the program name at
	index 0
	"""
	filename = None
	reset = False
	for arg in argv[1:]:
		if arg == "-reset" or arg == "-r":
			reset = True
		elif arg[0] != "-":
			if filename is None:
				filename = arg
			else:
				print("Error, multiple filenames were specified.")
				print_usage(1)
	if filename is None:
		print("Error, please specify a filename.")
		print_usage(1)
	return filename, reset

def get_next_value(filename, reset=False):
	"""
	Reads a file, locking it to guard against concurrent
	access, and returns the integer stored within it.
	The integer is automatically incremented and put back
	in the file. Optionally reset the contents of the file
	back to 0.
	
	:param filename: The file to operate on.
	:param reset: Whether or not to reset the file's contents
	back to 0.
	:returns: The next integer or None is resetting.
	"""
	value = None
	if reset == True:
		with open(filename, "w", encoding="ascii") as f:
			try:
				fcntl.flock(f, fcntl.LOCK_EX)
				f.write(str(0))
			finally:
				fcntl.flock(f, fcntl.F_UNLCK)
	else:
		with open(filename, "r+", encoding="ascii") as f:
			try:
				fcntl.flock(f, fcntl.LOCK_EX)
				value = int(f.read().strip())
				f.seek(0)
				f.truncate()
				f.write(str(value + 1))
			finally:
				fcntl.flock(f, fcntl.F_UNLCK)
	return value

def main():
	"""
	Parse arguments, reset or increment value
	and print it if non-None return.
	"""
	filename, reset = handle_args(sys.argv)
	value = get_next_value(filename, reset=reset)
	if value is not None: print(value)

if __name__ == "__main__":
	main()
	