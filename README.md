# Banch of scripts

Various scripts to check: root containers, dynamic users, writable path variables, cronn access, url status and others. 

### [check_cron_access.sh](https://github.com/phishinga/scripts/blob/main/check_cron_access.sh)
- Script that checks write permissions for all cron-related files and directories for the current user.
- ```curl https://raw.githubusercontent.com/phishinga/scripts/main/check_cron_access.sh | bash```

### [check_path_variables.sh](https://github.com/phishinga/scripts/blob/main/check_path_variables.sh)
- Script that checks if Linux Privilege Escalation using PATH Variable manipulation is possible. 
- ```curl https://raw.githubusercontent.com/phishinga/scripts/main/check_path_variables.sh | bash```

### [check_root_containers.sh](https://github.com/phishinga/scripts/blob/main/check_root_containers.sh)
- Script that checks if K8S containers are running under root privileges. Uses kubectl.
- ```curl https://raw.githubusercontent.com/phishinga/scripts/main/check_root_containers.sh | bash```
