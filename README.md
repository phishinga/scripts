# Banch of scripts

Various scripts to check: root containers, dynamic users, writable path variables, cronn access, url status and others. 

### [check_cron_access.sh](https://github.com/phishinga/scripts/blob/main/check_cron_access.sh)
- Script that checks write permissions for all cron-related files and directories for the current user. 
- When a script executed by Cron is editable by unprivileged users, those unprivileged users can escalate their privilege by editing this script, and waiting for it to be executed by Cron under root privileges.
- ```curl https://raw.githubusercontent.com/phishinga/scripts/main/check_cron_access.sh | bash```

### [check_path_variables.sh](https://github.com/phishinga/scripts/blob/main/check_path_variables.sh)
- Script that checks if Linux Privilege Escalation using PATH Variable manipulation is possible. 
- PATH is an environmental variable that defines all bin and sbin directories where executable applications are stored. When a user executes any command, Unix will look in these folders for executables with the same name as the command.
- ```curl https://raw.githubusercontent.com/phishinga/scripts/main/check_path_variables.sh | bash```

### [check_root_containers.sh](https://github.com/phishinga/scripts/blob/main/check_root_containers.sh)
- Script that checks if K8S containers are running under root privileges. Uses kubectl.
- This script retrieves a JSON output of all pods in a Kubernetes cluster and checks if any of the containers are running as root by examining their security context. It then outputs the namespace, pod name, container name, and whether it's running as root or not.
- ```curl https://raw.githubusercontent.com/phishinga/scripts/main/check_root_containers.sh | bash```

### [check_root_containers.ps1](https://github.com/phishinga/scripts/blob/main/check_root_containers.ps1)
- Same thing as above in PowerShell and bit enhanced results. 
- This script checks if any Kubernetes containers are running as the root user by executing the id and busybox id commands on each container to retrieve its UID, and then checking if the UID is 0 (which indicates that the container is running as root).
- For each container running as root, the script outputs a report containing the namespace, pod name, container name, and the command outputs.
- ```./check_root_containers.ps1```
