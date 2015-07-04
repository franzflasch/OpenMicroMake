#!/bin/bash

abort_when_exit_status()
{
	exit_status=$?
	if [ "$exit_status" -ne "0" ]; then
		exit $exit_status
	fi
}

# input arguments
CUR_DIR=$1
WORK_DIR=$2
PATCHES_IMPORT=$3

cd $WORK_DIR
abort_when_exit_status
quilt import $PATCHES_IMPORT
abort_when_exit_status
quilt push -a;
abort_when_exit_status
cd $CUR_DIR
abort_when_exit_status
exit 0