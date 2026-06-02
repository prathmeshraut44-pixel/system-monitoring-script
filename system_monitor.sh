#!/bin/bash

DISK_THRESHOLD=80
MEM_THRESHOLD=80
LOGFILE="monitor.log"

echo "=============================="
echo " System Monitoring Report"
echo " Date: $(date)"
echo "=============================="

# Disk Usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

echo "Disk Usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: Disk usage exceeded ${DISK_THRESHOLD}%!"
    echo "$(date) - Disk usage alert: ${DISK_USAGE}%" >> $LOGFILE
fi

echo ""

# Memory Usage
MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

echo "Memory Usage: ${MEM_USAGE}%"

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo "ALERT: Memory usage exceeded ${MEM_THRESHOLD}%!"
    echo "$(date) - Memory usage alert: ${MEM_USAGE}%" >> $LOGFILE
fi

echo ""

echo "Top 5 CPU Consuming Processes"
ps -eo pid,comm,%cpu --sort=-%cpu | head -6

echo ""

echo "Top 5 Memory Consuming Processes"
ps -eo pid,comm,%mem --sort=-%mem | head -6
