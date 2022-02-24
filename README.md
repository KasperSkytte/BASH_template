# BASH_template
A simple BASH template script intended for making convenient scientific workflows in BASH. Includes some helpful functions, for example for printing status messages with a time stamp, checking if required software is available in `$PATH`, standard argument parsing and help overview, etc. Also writes all output from stderr+stdout streams to a log file as well as the chosen settings. Adjust to your own needs.

## Usage
```
$ bash template.bash -i data/input_file -o data/output -d ../../databases/some_database/database_file
#################################################
Script: /home/kapper/scripts/BASH_template/template.bash
System time: 2022-02-24 11:40:40 (Europe/Copenhagen)
Script version: 1.2 (available at https://github.com/kasperskytte/bash_template)
Current user name: kapper
Current working directory: /home/kapper/projects/some_project/
Input file: /home/kapper/projects/some_project/data/input_file
Output folder: /home/kapper/projects/some_project/data/output
Database: /home/kapper/databases/some_database/database_file
Max. number of threads: 10
Log file: /home/kapper/projects/some_project/data/output/logfile_20220224_114040.txt
#################################################

 *** [2022-02-24 11:40:40] script message: Step 1: xxxx...
 *** [2022-02-24 11:40:40] script message: Step 2: yyyy...
 *** [2022-02-24 11:40:40] script message: Done processing. Time elapsed: 00h:00m:00s!
```

Run it again and it will stop with an error to avoid overwriting output data from a previous run
```
$ bash template.bash -i data/input_file -o data/output -d ../../databases/some_database/database_file
 *** [2022-02-24 11:39:45] script message: A directory named 'output_folder' already exists and is needed for this script to run. Please backup or delete the folder.
 *** [2022-02-24 11:39:45] script message: Exiting script.
```
