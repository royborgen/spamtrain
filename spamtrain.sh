#!/bin/bash

# Define the path to the skip list file (relative to the script's directory)
SKIP_FILE="$(dirname "$0")/skip_folders.txt"

# Initialize an array to store skipped folders
SKIPPED_FOLDERS=()

# Read the skip list file into an array
if [ -f "$SKIP_FILE" ]; then
    mapfile -t SKIP_FOLDERS < "$SKIP_FILE"
else
    echo "Skip list file not found: $SKIP_FILE"
    echo "All folders will be processed"
fi

# Function to check if a folder should be skipped
should_skip() {
    local folder_name="$1"
    for skip in "${SKIP_FOLDERS[@]}"; do
        if [ "$skip" == "$folder_name" ]; then
            return 0
        fi
    done
    return 1
}

# Loop through each home folder
for folder in /home/*; do
    folder_name=$(basename "$folder")

    # Check if the folder should be skipped
    if should_skip "$folder_name"; then
        SKIPPED_FOLDERS+=("$folder_name")  # Add to the skipped folders array
        continue
    fi

    # Process the folder if not skipped
    echo "Entering ${folder}"
    echo "Processing ${folder}/Maildir/.Junk"
    echo "Learning messages as spam"
    sa-learn --no-sync --spam "${folder}/Maildir/.Junk"
    
    echo "Processing ${folder}/Maildir/cur"
    echo "Learning messages as ham (non-spam)"
    sa-learn --no-sync --ham "${folder}/Maildir/cur"
    echo ""
done

# List skipped folders at the end
if [ ${#SKIPPED_FOLDERS[@]} -gt 0 ]; then
    echo "The following folders were skipped due to exclusion in $SKIP_FILE:"
    for skipped in "${SKIPPED_FOLDERS[@]}"; do
        echo "$skipped"
    done
else
    echo "No folders were skipped."
fi

echo ""
# Synchronize the database
echo "Synchronizing the database and the journal"
sa-learn --sync
echo "Done :)"
