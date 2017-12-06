#!/bin/bash
DEBUG_SHELL=true

source download/common/boilerplate.sh

# Will contain an array of files that need to be processed.
declare -a ON_TRAP_COMMANDS

function add_on_exit()
{
    local n=${#ON_TRAP_COMMANDS[*]}
    ON_TRAP_COMMANDS[$n]="$*"
    if [[ $n -eq 0 ]]; then
        LogLine "Appending Trap: $*"
        trap on_exit EXIT
    fi
}

function on_exit()
{
    for i in "${ON_TRAP_COMMANDS[@]}"
    do
        echo "on_exit: $i"
        eval $i
    done

    exit 1
}

trap on_exit SIGINT SIGTERM

assert_num_args 1
CheckDirectory $1

PATCH_DIRECTORY=$1
PATCH_DIRECTORY_FILES=${PATCH_DIRECTORY}/*.patch

total_patch_files=$(ls -1 $PATCH_DIRECTORY_FILES | wc -l)
LogLine "Total .patch files to process: $total_patch_files"

for patch_file in ${PATCH_DIRECTORY_FILES}
do
    LogLine "Applying patch file ${patch_file}..."
    patch -p1 -i ${patch_file}
done
