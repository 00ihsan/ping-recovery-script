#! /bin/bash
# This script is written by Ihsan Topcu
# This script can be used for free.
# Pull requests are allowed.

config_prefix=./test
LogFile=/var/log/ping-reset.log
LockFile=./reset.lock
ping 8.8.8.8 -c 1 > /dev/null 2>&1; exit_code=$?
time_stamp=$(date +"%d-%m-%Y - %H:%M")


if [ ! -f "$LogFile" ]; then
    touch $LogFile
    echo "$time_stamp: INFO: $LogFile does not exist!" | tee -a "$LogFile"
    echo "$time_stamp: INFO: Creating logfile...." | tee -a "$LogFile"
fi

echo "$time_stamp: INFO: Logfile can be seen with cat $LogFile"

if [ $exit_code -ne 0 ]; then 
    (1>&2 echo "$time_stamp: FAIL: Failed with exit code $exit_code." | tee -a "$LogFile")
if [ ! -f "$LockFile" ]; then
    echo "$time_stamp: FAIL: $LockFile does not exist." | tee -a "$LogFile"
    echo "$time_stamp: FAIL: Changing configs to stable state!" | tee -a "$LogFile"
    cp $config_prefix/config.gateway.json config.gateway.json.old
    cp $config_prefix/config.gateway.json.bk config.gateway.json
    touch ./reset.lock
else 
       echo "$time_stamp: FAIL: $LockFile does exist." | tee -a "$LogFile"
       echo "$time_stamp: FAIL: Quiting..." | tee -a "$LogFile"
fi

else
    echo "$time_stamp: OK: Internet connection available. Quitting..."  | tee -a "$LogFile"
fi