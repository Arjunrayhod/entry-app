#!/bin/bash

# Created by: Arjun Rathod
# Code to copy database data automatically
# Note: This script will run automatically every night at exactly 12:00 AM.

# To automate this, this line has been added to the crontab:
# 0 0 * * * /home/ubuntu/Backup_mongodb/backups.sh >> /home/ubuntu/Backup_mongodb/backup.log 2>&1

# Step 1: Set names and path details (Variables)
MY_BACKUP_FOLDER="$HOME/Backup_mongodb/backups_data"
MY_DB_NAME="mr_doe_prod"
CURRENT_DATE=$(date +%F)
FILE_NAME="my_database_backup_${CURRENT_DATE}"

# Step 2: Make folder if it is not there
if [ ! -d "$MY_BACKUP_FOLDER" ]; then
    mkdir -p "$MY_BACKUP_FOLDER"
fi

echo "Starting data copy for database..."

# Step 3: Extract/Copy data from MongoDB
mongodump --db=$MY_DB_NAME --out=$MY_BACKUP_FOLDER/$FILE_NAME

# Step 4: Convert folder to a single Zip file and goto backup folder
cd $MY_BACKUP_FOLDER
tar -czf "${FILE_NAME}.tar.gz" "$FILE_NAME"

# Step 4.5: Upload the Zip file to AWS S3 Bucket (NEW STEP)
# IMPORTANT: Put your exact S3 bucket name here
aws s3 cp "${FILE_NAME}.tar.gz" s3://mr-john-doe-backups-arjun/

# Step 5: Clean and delete the extra unzipped folder
rm -rf "$FILE_NAME"

# Step 6: Print final message on screen
echo "Done! Backup process is finished successfully."
echo "Your safe zip file is here: ${MY_BACKUP_FOLDER}/${FILE_NAME}.tar.gz"
