#!/bin/bash

# === CONFIGURATION & LOGGING ===
LOG_DIR="/var/log/firstboot"
LOG_FILE="$LOG_DIR/install.log"
mkdir -p "$LOG_DIR"

# Redirect all output to the log file and console
exec > >(tee -a "$LOG_FILE") 2>&1

# Error handling function
set -e
trap 'echo "ERROR: Installation failed at line $LINENO. Check $LOG_FILE for details.";' ERR

echo "=== Starting Deployment: $(date) ==="

# === PREVENT INTERACTIVE PROMPTS ===
export DEBIAN_FRONTEND=noninteractive

# === STEP 1: INSTALL ESSENTIALS ===
echo "Step 1: Updating system and installing base tools..."
apt-get update
apt-get install -y curl wget git ansible firefox || echo "Warning: Some packages failed."

# === STEP 2: DOCKER INSTALL (RETRY LOGIC) ===
echo "Step 2: Installing Docker..."
MAX_RETRIES=3
COUNT=0
until [ $COUNT -ge $MAX_RETRIES ]; do
    curl -fsSL https://get.docker.com -o get-docker.sh && break
    COUNT=$((COUNT+1))
    echo "Curl failed, retrying ($COUNT/$MAX_RETRIES)..."
    sleep 5
done

if [ -f get-docker.sh ]; then
    sh get-docker.sh
else
    echo "Critical: Docker script could not be downloaded."
    exit 1
fi

# === STEP 3: ANSIBLE PULL ===
echo "Step 3: Triggering Ansible configuration..."
ansible-pull -U https://github.com/yourusername/ansible-repo.git \
             -i localhost, \
             playbook.yml

echo "=== Deployment Finished Successfully: $(date) ==="
