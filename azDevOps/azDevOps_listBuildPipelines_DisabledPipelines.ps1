# List information about disabled and enabled pipelines, had to combine with az CLI as previous method wasn't working.

# Set your personal access token, organization, and project
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Get a list of all projects
$projectsUrl = "https://dev.azure.com/$organization/_apis/projects?api-version=7.0"
$projectsResponse = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Get
$projectsResponse.value | ForEach-Object {
    $project = $_.name

    # Get a list of all repos for the project
    $reposUrl = "https://dev.azure.com/$organization/$project/_apis/git/repositories?api-version=7.0"
    $reposResponse = Invoke-RestMethod -Uri $reposUrl -Headers $headers -Method Get
    $reposResponse.value | ForEach-Object {
        $repo =$_.name

        Write-Output ("Project: {0}, Repo: {1}" -f $project, $repo)
        az pipelines list --organization https://dev.azure.com/HQY01 --project $project --repository $repo --output table
        # Show only disabled pipelines - DOES NOT WORK AT THE MOMENT
        $disabledPipelines = $pipelines | Where-Object { $_.status -eq 'disabled'}
        $disabledPipelines | ForEach-Object {
            Write-Output ("Project: {0}, Repo: {1}, Pipeline: {2}, Status: {3}" -f $project, $repo, $_.name, $_.status)
        }
    }
}
