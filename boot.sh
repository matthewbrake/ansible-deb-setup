#!/bin/bash
# Exit on error
set -e

# 1. Install Docker (using the quick script)
curl -fsSL https://get.docker.com | sh
usermod -aG docker $(logname) # Adds the primary user to docker group
