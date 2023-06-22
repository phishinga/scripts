# Troubleshooting azDevOps scripts

## Display raw content of file in Azure DevOps
Taken from here: https://stackoverflow.com/questions/54137998/is-it-possible-to-have-a-link-to-raw-content-of-file-in-azure-devops

```
https://dev.azure.com/{ORG}/{PROJECT}/_apis/sourceProviders/TfsGit/filecontents?repository={REPONAME}&path=/{FOLDER/SUBFOLDER/build.yaml}&commitOrBranch={BRANCH}&api-version=5.0-preview.1
```

## Get a list of all projects
Run this command to get a list of all projects in your organization:

```
# Get a list of all projects

# Set your personal access token and organization
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"
$project = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Lets call someone
$projectsUrl = "https://dev.azure.com/$organization/_apis/projects?api-version=6.0"
$projectsResponse = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Get
$projectsResponse.value | ForEach-Object { Write-Output ("Project: {0}" -f $_.name) }
```

## Get a list of teams for a specific project
Replace "YOUR_PROJECT" with the name or ID of your project:

```
# Get a list of teams for a specific project

# Set your personal access token and organization
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"
$project = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Lets call someone
#$teamsUrl = "https://dev.azure.com/$organization/$project/_apis/teams?api-version=6.0"
#$teamsUrl = "https://dev.azure.com/HQY01/APIPlatform/_settings/teams?"
$teamsUrl = "https://dev.azure.com/$organization/_apis/teams?api-version=6.0-preview"
$teamsResponse = Invoke-RestMethod -Uri $teamsUrl -Headers $headers -Method Get
$teamsResponse.value | ForEach-Object { Write-Output ("Team: {0}" -f $_.name) }
```

## Get a list of team members for a specific team
Replace "YOUR_TEAM" with the name or ID of your team:

```
# Get a list of team members for a specific team

# Set your personal access token and organization
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"
$project = "XXX-XXX-XXX-XXX"
$team = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Lets call someone
$membersUrl = "https://dev.azure.com/$organization/_apis/projects/$project/teams/$team/members?api-version=6.0"
$membersResponse = Invoke-RestMethod -Uri $membersUrl -Headers $headers -Method Get
$membersResponse.value | ForEach-Object { Write-Output ("Member: {0}" -f $_.identity.displayName) }
```

## Get build pipelines for a project

```
$project = "YourProjectName"
$pipelinesUrl = "https://dev.azure.com/$organization/$project/_apis/build/definitions?api-version=6.0"
$pipelinesResponse = Invoke-RestMethod -Uri $pipelinesUrl -Headers $headers -Method Get
$pipelinesResponse.value | ForEach-Object { Write-Output $_.name }
```

## Get repositories per project

```
$project = "YourProjectName"
$reposUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories?api-version=6.0"
$reposResponse = Invoke-RestMethod -Uri $reposUrl -Headers $headers -Method Get
$reposResponse.value | ForEach-Object { Write-Output $_.name }
```

## Find all templates and references within yaml pipeline
PowerShell script that reads a YAML file from an Azure DevOps repository, traces the template references, and prints out the dependencies. This script uses the powershell-yaml module to parse YAML and a Personal Access Token (PAT) to authenticate with Azure DevOps

```
# Import the required module
Import-Module powershell-yaml

# Your Personal Access Token (PAT)
$personalAccessToken = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

function Get-Yaml($Url) {
    # Get the YAML content from the URL
    $response = Invoke-RestMethod -Uri $Url -Headers $headers

    # Parse the YAML content
    $yaml = ConvertFrom-Yaml $response

    return $yaml
}

function Trace-Pipeline($Url) {
    $pipeline = Get-Yaml $Url

    if ($pipeline.stages) {
        foreach ($stage in $pipeline.stages) {
            if ($stage.template) {
                $templateUrl = "https://dev.azure.com/{organization}/{project}/_git/{repo}?path=$($stage.template)&version=GB{branch}"
                Write-Output "$Url >> $templateUrl"
                Trace-Pipeline $templateUrl
            }
        }
    }
}

# Start tracing from your main pipeline file
$mainPipelineUrl = "https://dev.azure.com/{organization}/{project}/_git/{repo}?path={path_to_main_pipeline}&version=GB{branch}"
Trace-Pipeline $mainPipelineUrl

```
