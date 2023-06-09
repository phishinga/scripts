# Troubleshooting azDevOps scripts

## Get a list of all projects
Run this command to get a list of all projects in your organization:

```
$projectsUrl = "https://dev.azure.com/$organization/_apis/projects?api-version=6.0"
$projectsResponse = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Get
$projectsResponse.value | ForEach-Object { Write-Output ("Project: {0}" -f $_.name) }
```

## Get a list of teams for a specific project
Replace "YOUR_PROJECT" with the name or ID of your project:

```
$project = "YOUR_PROJECT"
$teamsUrl = "https://dev.azure.com/$organization/$project/_apis/teams?api-version=6.0"
$teamsResponse = Invoke-RestMethod -Uri $teamsUrl -Headers $headers -Method Get
$teamsResponse.value | ForEach-Object { Write-Output ("Team: {0}" -f $_.name) }
```

## Get a list of team members for a specific team
Replace "YOUR_TEAM" with the name or ID of your team:

```
$team = "YOUR_TEAM"
$membersUrl = "https://dev.azure.com/$organization/_apis/projects/$project/teams/$team/members?api-version=6.0"
$membersResponse = Invoke-RestMethod -Uri $membersUrl -Headers $headers -Method Get
$membersResponse.value | ForEach-Object { Write-Output ("Member: {0}" -f $_.displayName) }
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

