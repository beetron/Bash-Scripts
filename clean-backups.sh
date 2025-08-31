#!/bin/bash

# clean-backups.sh
# Script to keep only the 3 most recent pairs of backup files
# Each pair consists of btcMongo.tgz and planka.tgz files with the same date prefix

# Set the backup directory (change this to your actual backup directory)
BACKUP_DIR="/home/btro/autoBackups"

# Change to the backup directory
cd "$BACKUP_DIR" || {
    echo "Error: Cannot access backup directory $BACKUP_DIR"
    exit 1
}

echo "Cleaning old backup files in: $BACKUP_DIR"
echo "Keeping only the 3 most recent pairs..."

# Get unique date prefixes from btcMongo files, sorted in reverse chronological order
# This ensures we get the dates in newest-first order
DATES=$(ls *-btcMongo.tgz 2>/dev/null | sed 's/-btcMongo\.tgz$//' | sort -r)

if [ -z "$DATES" ]; then
    echo "No btcMongo backup files found."
    exit 0
fi

# Convert dates to array and count them
DATES_ARRAY=($DATES)
TOTAL_PAIRS=${#DATES_ARRAY[@]}

echo "Found $TOTAL_PAIRS backup pairs"

# If we have 3 or fewer pairs, nothing to delete
if [ $TOTAL_PAIRS -le 3 ]; then
    echo "Only $TOTAL_PAIRS pairs found. Nothing to delete."
    exit 0
fi

# Calculate how many pairs to delete
PAIRS_TO_DELETE=$((TOTAL_PAIRS - 3))
echo "Will delete $PAIRS_TO_DELETE oldest pairs"

# Delete older pairs (starting from index 3, which is the 4th newest)
for ((i=3; i<TOTAL_PAIRS; i++)); do
    DATE_PREFIX=${DATES_ARRAY[$i]}
    
    # Define the pair of files to delete
    BTCMONGO_FILE="${DATE_PREFIX}-btcMongo.tgz"
    PLANKA_FILE="${DATE_PREFIX}-planka.tgz"
    
    echo "Deleting pair for date: $DATE_PREFIX"
    
    # Delete btcMongo file if it exists
    if [ -f "$BTCMONGO_FILE" ]; then
        echo "  Removing: $BTCMONGO_FILE"
        rm "$BTCMONGO_FILE"
    else
        echo "  Warning: $BTCMONGO_FILE not found"
    fi
    
    # Delete planka file if it exists
    if [ -f "$PLANKA_FILE" ]; then
        echo "  Removing: $PLANKA_FILE"
        rm "$PLANKA_FILE"
    else
        echo "  Warning: $PLANKA_FILE not found"
    fi
done

echo "Cleanup completed!"
echo ""
echo "Remaining files:"
ls -la *-btcMongo.tgz *-planka.tgz 2>/dev/null | sort
