# Set your organization
$organization = "MYORG"

# Get a list of all projects
$projects = az devops project list --organization https://dev.azure.com/$organization --output tsv --query [].name

# Loop through each project
foreach ($project in $projects) {
    Write-Host "Project: $project"

    # Get a list of all repos for the project
    $repos = az repos list --organization https://dev.azure.com/$organization --project $project --output tsv --query [].name

    # Loop through each repo
    foreach ($repo in $repos) {
        Write-Host "Repo: $repo"

        # List all pipelines for the repo
        az pipelines list --organization https://dev.azure.com/$organization --project $project --repository $repo --output table
    }
}
