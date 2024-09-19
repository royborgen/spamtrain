#!/bin/bash

# loop through each each home folder
for folder in /home/*; do
    #exclude ansible and lost+found
    if [ "${folder}" != "/home/ansible" ] && [ "${folder}" != "/home/lost+found" ];
    then
	echo "Entering ${folder}"
    	echo "Processing ${folder}/Maildir/.Junk"
	echo "Learning  messages as spam"
    	sa-learn --no-sync --spam "${folder}/Maildir/.Junk"
	echo "Processing ${folder}/Maildir/cur"
	echo "Learning messages as ham (non-spam)"
    	sa-learn --no-sync --ham "${folder}/Maildir/cur"
	echo ""
    fi
done
echo "Syncronize the database and the journal"
sa-learn --sync
echo "Done :)"
