#!/usr/bin/env bash
# This BASH script is based on the template from https://github.com/kasperskytte/bash_template
# License is MIT, which means the author takes no responsibilities, but you can use it for anything you want

#exit when a command fails (use "|| :" after a command to allow it to fail)
set -o errexit

# exit when a pipe fails
set -o pipefail

#disallow undeclared variables
#set -o nounset

#disallow clobbering (overwriting) of files
#set -o noclobber

#print exactly what gets executed (useful for debugging)
#set -o xtrace

#set timezone if not set already
if [[ -z "$(env | grep '^TZ=')" ]]
then
  TZ="Europe/Copenhagen"
fi

VERSION="1.2"

#use all logical cores except 2 unless adjusted by user
max_threads=${max_threads:-$(($(nproc)-2))}

logfilename="logfile_$(date '+%Y%m%d_%H%M%S').txt"

#function to print default error message if bad usage
usageError() {
  echo "Invalid usage: $1" 1>&2
  echo ""
  eval "bash $0 -h"
}

#function to add timestamps to progress messages
scriptMessage() {
  #check user arguments
  if [ ! $# -eq 1 ]
  then
    echo "Error: function must be passed exactly 1 argument" >&2
    exit 1
  fi
  echo " *** [$(date '+%Y-%m-%d %H:%M:%S')] script message: $1"
}

#function to check if executable(s) are available in $PATH
checkCommand() {
  args="$*"
  exit="no"
  for arg in $args
  do
    if [ -z "$(command -v "$arg")" ]
    then
      echo "${arg}: command not found"
      exit="yes"
    fi
  done
  if [ $exit == "yes" ]
  then
    exit 1
  fi
}

#function to check if a folder is present and empty
checkFolder() {
  #check user arguments
  if [ ! $# -eq 1 ]
  then
    echo "Error: function must be passed exactly 1 argument" >&2
    exit 1
  fi
  if [ -d "$1" ]
  then
      scriptMessage "A directory named '$1' already exists and is needed for this script to run. Please backup or delete the folder."
      scriptMessage "Exiting script."
      exit 1
  else
    mkdir -p "$1"
  fi
}

#check for all required commands before doing anything else
checkCommand awk sed samtools minimap2 usearch

#fetch and check options provided by user
while getopts ":hi:d:t:vo:" opt; do
case ${opt} in
  h )
    echo "Some help text"
    echo "Version: $VERSION"
    echo "Options:"
    echo "  -h    Display this help text and exit."
    echo "  -v    Print version and exit."
    echo "  -i    (required) Input data."
    echo "  -o    (required) Output folder."
    echo "  -d    (required) Path to database."
    echo "  -t    Max number of threads to use. (Default: all available except 2)"
    exit 1
    ;;
  i )
    input=$OPTARG
    ;;
  o )
    output=$OPTARG
    ;;
  d )
    database=$OPTARG
    ;;
  t )
    max_threads=$OPTARG
    ;;
  v )
    echo "Version: $VERSION"
    exit 0
    ;;
  \? )
    usageError "Invalid Option: -$OPTARG"
    exit 1
    ;;
  : )
    usageError "Option -$OPTARG requires an argument"
    exit 1
    ;;
esac
done
shift $((OPTIND -1)) #reset option pointer

#check required options
if [[ -z "$input" ]]
then
  usageError "option -i is required"
	exit 1
fi
if [[ -z "$output" ]]
then
	usageError "option -o is required"
	exit 1
fi
if [[ -z "$database" ]]
then
	usageError "option -d is required"
	exit 1
fi

checkFolder "$output"
logfilepath="${output}/${logfilename}"

#actual script wrapped in a function to allow writing stderr+stdout to log file
main() {
  echo "#################################################"
  echo "Script: $(realpath "$0")"
  echo "System time: $(date '+%Y-%m-%d %H:%M:%S') (${TZ})"
  echo "Script version: ${VERSION} (available at https://github.com/kasperskytte/bash_template)"
  echo "Current user name: $(whoami)"
  echo "Current working directory: $(pwd)"
  echo "Input file: $(realpath "$input")"
  echo "Output folder: $(realpath -m "$output")"
  echo "Database: $(realpath -m "$database")"
  echo "Max. number of threads: ${max_threads}"
  echo "Log file: $(realpath -m "$logfilepath")"
  echo "#################################################"
  echo

  scriptMessage "Step 1: xxxx..."
  scriptMessage "Step 2: yyyy..."

  #print elapsed time since script was invoked
  duration=$(printf '%02dh:%02dm:%02ds\n' $((SECONDS/3600)) $((SECONDS%3600/60)) $((SECONDS%60)))
  scriptMessage "Done processing. Time elapsed: $duration!"
}

#clear log file first if it happens to already exist
true > "$logfilepath"
main |& tee -a "$logfilepath"
