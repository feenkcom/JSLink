#!/bin/bash

# Kill all the PythonBridge servers running on localhost.
# This assumes they are being run as the current user.
# Any associated debug server processes will automatically exit.

# List the processes.
# If none are found, exit successfully
ps aux | grep -E 'node.*js/src/app.js' | grep -v grep
status=$?
if [ $status -eq 1 ]
then
	exit 0
fi

# Kill them
ps aux | grep -E 'node.*js/src/app.js' | grep -v grep | awk '{print $2}' | xargs kill
exit $?
