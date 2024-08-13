--

# PC Performance Analyzer

This project contains a shell script that analyzes the performance of your PC by collecting key system statistics such as CPU usage, memory usage, disk usage, network usage, and system uptime. The results are saved to a file and can be automatically pushed to a GitHub repository using a CI/CD pipeline.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [GitHub Actions Workflow](#github-actions-workflow)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- Unix-like operating system (Linux, macOS, or Windows with WSL)
- Git installed on your system
- GitHub account
- GitHub repository to push the results

## Installation

1. **Clone the repository** (or create a new one):

   ```bash
   git clone https://github.com/<your-username>/performance_script.git
   cd performance_script
   ```

2. **Save the script**:

   Save the following shell script as `performance_script.sh` in the root of your project directory.

   ```bash
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

   # Push to GitHub
   git add $output_file
   git commit -m "Performance stats update"
   git push -u origin master
   ```

3. **Make the script executable**:

   ```bash
   chmod +x performance_script.sh
   ```

## Usage

Run the script manually by executing the following command in the terminal:

```bash
./performance_script.sh
```

The script will display the following stats and save them to `performance_stats.txt`:

- CPU Usage
- Memory Usage (Total, Used, Free)
- Disk Usage
- Network Usage (Received, Transmitted)
- System Uptime

The file `performance_stats.txt` will then be committed and pushed to your GitHub repository.

## GitHub Actions Workflow

This project includes a GitHub Actions workflow that automatically runs the performance analysis script every hour and pushes the results to the repository.

Create a `.github/workflows/ci.yml` file in your repository and add the following content:

```yaml
name: Analyze PC Performance

on:
  schedule:
    - cron: '0 * * * *'  # Runs every hour
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Run performance script
      run: ./performance_script.sh
```

### How to Set Up GitHub Authentication

1. **Personal Access Token (PAT)**: GitHub requires a PAT for HTTPS authentication. Generate a PAT in your GitHub settings and use it instead of your password when pushing code.

2. **SSH Keys**: Alternatively, set up SSH keys for GitHub and update your repository's remote URL to use SSH instead of HTTPS.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

