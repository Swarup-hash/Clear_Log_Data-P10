#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Log directories (adjust based on your system)
LOG_DIRS=(
    "/var/log"
)

# Backup logs (optional)
BACKUP_DIR="/root/log_backup"
mkdir -p "$BACKUP_DIR"
echo "Backing up logs to $BACKUP_DIR..."
for dir in "${LOG_DIRS[@]}"; do
    tar -czf "$BACKUP_DIR/$(basename "$dir")_backup_$(date +%Y%m%d%H%M%S).tar.gz" "$dir"
done
echo "Backup completed."

# Clear log files
echo "Clearing log files..."
for dir in "${LOG_DIRS[@]}"; do
    find "$dir" -type f -exec truncate -s 0 {} \;
done
echo "Logs cleared."

# Optional: Remove rotated/compressed logs
echo "Removing rotated/compressed logs..."
for dir in "${LOG_DIRS[@]}"; do
    find "$dir" -type f \( -name "*.gz" -o -name "*.old" -o -name "*.1" \) -exec rm -f {} \;
done
echo "Rotated logs removed."

echo "Log cleanup completed successfully."
