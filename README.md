# BASH_template
A simple BASH template script intended for making convenient scientific workflows in BASH. Includes some helpful functions, for example for printing status messages with a time stamp, checking if required software is available in `$PATH`, standard argument parsing and help overview, etc. Also writes all output from stderr+stdout streams to a log file as well as the chosen settings. Adjust to your own needs.

## Usage
```
$ bash template.bash -i data/input_file -o data/output -d ../../databases/some_database/database_file
#################################################
Host name: slaptop
Current user name: kapper
System time: 2022-08-05 11:29:21 (Europe/Copenhagen)
Script: /home/kapper/Knockbox/github/BASH_template/template.bash
Script version: 1.2.1 (available at https://github.com/kasperskytte/bash_template)
Current working directory: /home/kapper/Knockbox/github/BASH_template
Input file: /home/kapper/Knockbox/github/BASH_template/data/input_file
Output folder: /home/kapper/Knockbox/github/BASH_template/data/output
Database: /home/kapper/Knockbox/databases/some_database/database_file
Max. number of threads: 10
Log file: /home/kapper/Knockbox/github/BASH_template/data/output/logfile_20220805_112921.txt
#################################################

 *** [2022-08-05 11:29:21] script message: Step 1: I'm gonna sleep for 5 seconds...
 *** [2022-08-05 11:29:27] script message: Step 2: I'm gonna take 2 seconds more...
 *** [2022-08-05 11:29:29] script message: Done processing. Time elapsed: 00h:00m:08s!  
```

Run it again and it will stop with an error to avoid overwriting output data from a previous run
```
$ bash template.bash -i data/input_file -o data/output -d ../../databases/some_database/database_file
 *** [2022-08-05 11:29:53] script message: A directory named 'data/output' already exists and is needed for this script to run. Please backup or delete the folder.
 *** [2022-08-05 11:29:53] script message: Exiting script.
```
