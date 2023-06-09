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
- Same thing as above but in PowerShell and bit enhanced results. 
- This script checks if any Kubernetes containers are running as the root user by executing the ```id``` and ```busybox id``` commands on each container to retrieve its UID, and then checking if the UID is 0 (which indicates that the container is running as root).
- For each container running as root, the script outputs a report containing the namespace, pod name, container name, and the command outputs.
- ```./check_root_containers.ps1```

### [azDevOps_troubleshooting.md](https://github.com/phishinga/scripts/blob/main/azDevOps_troubleshooting.md)
- Simple scripts for troubleshoting azDevOps scripts.

### [azDevOps_listBuildPipelines.ps1](https://github.com/phishinga/scripts/blob/main/azDevOps_listBuildPipelines.ps1)
- This PowerShell script interacts with the Azure DevOps REST API to retrieve information about your build pipelines. 
- For each pipeline for all of your Azure DevOps Projects, it fetches the ID, name, creation date, revision, and type. 
- It also retrieves the most recent run of each pipeline, including the start time and the name of the person who initiated the run. 
- ```./azDevOps_listBuildPipelines.ps1```

### [azDevOps_listObsoleteBuildPipelines.ps1](https://github.com/phishinga/scripts/blob/main/azDevOps_listOboleteBuildPipelines.ps1)
- Same as above but this time it prints the pipeline details omly if the last run was more than 12 months ago. 
- ```./azDevOps_listObsoleteBuildPipelines.ps1```

### [azDevOps_listBuildPipelines.yaml](https://github.com/phishinga/scripts/blob/main/azDevOps_listBuildPipelines.yaml)
- Example Pipeline for azDevOps pipelines auditing purposes (uses two ps1 files stored in the same repo, Azure PAT and produces txt artifacts)
- References: 
  - https://github.com/phishinga/scripts/blob/main/azDevOps_listBuildPipelines4YAML.ps1
  - https://github.com/phishinga/scripts/blob/main/azDevOps_listObsoleteBuildPipelines4YAML.ps1

### [check_api_endpoints.sh](https://github.com/phishinga/scripts/blob/main/check_api_endpoints.sh)
- Simple script for API enumeration testing based on provided txt file.
- This Bash script reads a list of API endpoints from a file and, for each endpoint, makes HTTP requests using various methods and outputs the responses. The responses are printed to the console with the corresponding HTTP method and URL.
- If you are running this via curl, you will need to make sure that ```api_endpoints.txt``` file is present in the directory where you're running the script.
- ```curl https://raw.githubusercontent.com/phishinga/scripts/main/check_api_endpoints.sh | bash```
