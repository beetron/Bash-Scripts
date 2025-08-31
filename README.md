# Bash-Scripts

This repository contains a collection of Bash scripts for personal use.

## Available Scripts

- [scp-backup.sh](#scp-backupsh)
- [docker-mongo-backup.sh](#docker-mongo-backupsh)

---

## 💻 **scp-backup.sh**

**Purpose:**
Automates the backup of specified files to a remote server using SCP. Logs all actions and errors to a local log file.

**Features:**

- User-configurable source files and remote destination
- Pattern matching for source files
- Uses a specified SSH key for secure SCP connection
- Logs all operations to `scp-backup.log`
- Reports success or failure for each file

**Configuration:**

- SSH key pairing required between local and remote environment.
- Set the `SSH_KEY` variable to the path of your private SSH key
- Edit the `SRC_FILES` array to specify files or patterns to back up
- Set `DEST_USER`, `DEST_HOST`, and `DEST_PATH` for your remote server

**Log Output:**
All actions are logged to `scp-backup.log` in the script directory. The script also prints the SSH key path and user information for each backup session.

---

## 🐳 **docker-mongo-backup.sh**

**Purpose:**
Creates a backup of a MongoDB database running in a Docker container. The backup is archived and stored in a specified directory on the host.

**Features:**

- Automatically detects the running MongoDB container
- Retrieves credentials from Docker secrets
- Uses `mongodump` inside the container
- Copies the dump to the host and archives it
- Cleans up temporary files

**Configuration:**

- This script relies on Docker Swarm mode's secrets for sensitive information
- Set `SCRIPT_DIRECTORY` to the desired backup location
- Ensure Docker secrets for MongoDB credentials are available in the container

**Log Output:**
Backup files are stored in the specified script directory. Errors and status messages are printed to the console.

---

_Add new script descriptions below using the same format._
