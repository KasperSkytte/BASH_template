#!/usr/bin/env bash
#exit when a command fails (use "|| true" to allow a command to fail)
set -o errexit
# exit when a pipe fails
set -o pipefail
#disallow undeclared variables
set -o nounset
#disallow clobbering (overwriting) of files
#set -o noclobber
#print exactly what gets executed (useful for debugging)
#set -o xtrace

VERSION="1.0"

#use all logical cores except 2 unless adjusted by user
MAX_THREADS=${MAX_THREADS:-$((`nproc`-2))}

#default error message if bad usage
usageError() {
  local self=`basename "$0"`
  echo "Invalid usage: $1" 1>&2
  echo ""
  echo "Run 'bash $self -h' for help"
}

#fetch and check options provided by user
#flags for required options, checked after getopts loop
i_flag=0
d_flag=0
o_flag=0
while getopts ":hi:d:t:vo:" opt; do
case ${opt} in
  h )
    echo "Some help text"
    echo "Version: $VERSION"
    echo "Options:"
    echo "  -h    Display this help text and exit."
    echo "  -v    Print version and exit."
    exit 1
    ;;
  i )
    input=$OPTARG
    i_flag=1
    ;;
  d )
    database=$OPTARG
    d_flag=1
    ;;
  t )
    MAX_THREADS=$OPTARG
    ;;
  v )
    echo "Version: $VERSION"
    exit 0
    ;;
  o )
    output=$OPTARG
    o_flag=1
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

#does script need any options or are default values ok?
if [ $# -eq 0 ]
then
	usageError "no arguments passed"
	exit 1
fi
#check all required options
if [ $i_flag -eq 0 ]
then
	usageError "option -i is required"
	exit 1
fi
if [ $d_flag -eq 0 ]
then
	usageError "option -d is required"
	exit 1
fi
if [ $o_flag -eq 0 ]
then
	usageError "option -o is required"
	exit 1
fi

#function to add timestamps to progress messages
echoWithTS() {
  #check user arguments
  if [ ! $# -eq 1 ]
  then
    echo "Error: function must be passed exactly 1 argument" >&2
    exit 1
  fi
  echo " *** [$(date '+%Y-%m-%d %H:%M:%S')] script message: $1"
}

##### START OF ACTUAL SCRIPT #####
echo "Version: $VERSION"
echo "max threads: $MAX_THREADS"
echo "input: $input"
echo "database: $database"
echo "output: $output"
##### END OF ACTUAL SCRIPT #####

#print elapsed time since script was invoked
duration=$(printf '%02dh:%02dm:%02ds\n' $(($SECONDS/3600)) $(($SECONDS%3600/60)) $(($SECONDS%60)))
echoWithTS "Done in: $duration!"
exit 0