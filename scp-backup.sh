#!/bin/bash

cd "$(dirname "$0")"
shopt -s nullglob

# ===== USER-CONFIGURABLE VARIABLES =====
SRC_FILES=(
    "/home/user/file1" 
    "/home/user/file2"
)
DEST_USER="username"
DEST_HOST="server.net"
DEST_PATH="/home/user/autoBackups"
SSH_KEY="/home/user/.ssh/sshKey"
# =======================================

# ===== LOGGING CONFIGURATION =====
SCRIPT_DIR="$(pwd)"
LOG_FILE="$SCRIPT_DIR/scp-backup.log"
# =================================

{
    echo "----- $(date '+%Y-%m-%d %H:%M:%S') Starting SCP backup -----"
    echo "User: $(whoami), HOME: $HOME"
    echo "Using SSH key: $SSH_KEY"
    for SRC_PATTERN in "${SRC_FILES[@]}"; do
        match_found=false
        for FILE in $SRC_PATTERN; do
            if [[ -f "$FILE" ]]; then
                echo "Sending $FILE to ${DEST_USER}@${DEST_HOST}:${DEST_PATH}"
                if scp -i "$SSH_KEY" "$FILE" "${DEST_USER}@${DEST_HOST}:${DEST_PATH}"; then
                    echo "SUCCESS: $FILE sent."
                else
                    echo "ERROR: Failed to send $FILE."
                fi
                match_found=true
            fi
        done
        if ! $match_found; then
            echo "No files matching pattern: $SRC_PATTERN"
        fi
    done
    echo "----- $(date '+%Y-%m-%d %H:%M:%S') SCP backup finished -----"
} 2>&1 | tee -a "$LOG_FILE"
