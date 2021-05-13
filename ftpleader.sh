#!/bin/bash
WORKINGDIRFILES =  ""  # change full path to match your working dir
cd $WORKINGDIRFILES
HOST='provide host name or ip of ftp server'
USER='provide username'
PASSWD='provide password'
FILE='ledger.json'
REMOTEPATH='/' #change to your remote path on ftp server

ftp -pdniv $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
cd $REMOTEPATH
binary
put $FILE
quit
END_SCRIPT
echo "File uploaded"
exit 0

