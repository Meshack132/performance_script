#!/bin/bash

# Collecting CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Collecting Memory usage
mem_total=$(free -m | awk 'NR==2{printf "%sMB\n", $2}')
mem_used=$(free -m | awk 'NR==2{printf "%sMB\n", $3}')
mem_free=$(free -m | awk 'NR==2{printf "%sMB\n", $4}')

# Collecting Disk usage
disk_usage=$(df -h | grep 'Filesystem\|/dev/sda*' | awk '{print $5}')

# Collecting Network usage
network_rx=$(cat /sys/class/net/eth0/statistics/rx_bytes)
network_tx=$(cat /sys/class/net/eth0/statistics/tx_bytes)

# System Uptime
uptime=$(uptime -p)

# Display stats
echo "CPU Usage: $cpu_usage%"
echo "Memory: Total: $mem_total, Used: $mem_used, Free: $mem_free"
echo "Disk Usage: $disk_usage"
echo "Network: Received: $network_rx bytes, Transmitted: $network_tx bytes"
echo "System Uptime: $uptime"

# Save stats to a file
output_file="performance_stats.txt"
echo "CPU Usage: $cpu_usage%" > $output_file
echo "Memory: Total: $mem_total, Used: $mem_used, Free: $mem_free" >> $output_file
echo "Disk Usage: $disk_usage" >> $output_file
echo "Network: Received: $network_rx bytes, Transmitted: $network_tx bytes" >> $output_file
echo "System Uptime: $uptime" >> $output_file
