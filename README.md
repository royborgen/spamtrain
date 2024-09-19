# SpamAssassin Learning Script

This script automates the process of teaching SpamAssassin to recognize spam and ham (non-spam) messages from users' mailboxes, while allowing for specific home directories to be excluded from processing using a skip list file.

## How It Works

1. **Skip List File:**
   - The script reads a file named `skip_folders.txt`, which should be placed in the same directory as the script.
   - The `skip_folders.txt` file contains a list of home folder names (one per line) that should be excluded from processing.
   - If no skip list file is found, the script will process all home directories.

2. **Spam and Ham Classification:**
   - For each user's home directory (except those listed in the skip list), the script processes two mail folders:
     - `Maildir/.Junk`: Messages in this folder are learned as spam using `sa-learn --spam`.
     - `Maildir/cur`: Messages in this folder are learned as ham (non-spam) using `sa-learn --ham`.

3. **Skipped Folders:**
   - Any home folder listed in the `skip_folders.txt` file is skipped during processing.
   - After processing, the script outputs a list of skipped folders.

4. **Synchronization:**
   - After processing all folders, the script synchronizes the SpamAssassin Bayes database using `sa-learn --sync`.

## Example `skip_folders.txt`:
```
user3
lost+found
```


## Prerequisites

- **SpamAssassin** must be installed and configured on the system.
- Mail folders should be in the default `Maildir` format under each user's home directory.

## Usage

1. Clone the repository or download the script.
2. Ensure the `skip_folders.txt` file is in the same directory as the script.
3. Make the script executable:
   ```bash
   chmod +x script_name.sh
    ```
4. Run the script as a superuser (root) to process all home directories:
`sudo ./script_name.sh`

## Output
- The script prints progress as it processes each folder, including spam/ham learning status.
- At the end of the run, it lists any folders that were skipped based on the skip_folders.txt file.
- The script also outputs when the SpamAssassin database is synchronized.

## Example Output  
```
Entering /home/user1
Processing /home/user1/Maildir/.Junk
Learning messages as spam
Processing /home/user1/Maildir/cur
Learning messages as ham (non-spam)


Entering /home/user2
Processing /home/user2/Maildir/.Junk
Learning messages as spam
Processing /home/user2/Maildir/cur
Learning messages as ham (non-spam)


The following folders were skipped due to exclusion in /path/to/skip_folders.txt:
user3
lost+found

Synchronizing the database and the journal
Done :)
```
