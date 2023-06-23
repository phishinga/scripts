# Set your organization
organization="MYORG"

# Get a list of all projects
projects=$(az devops project list --organization https://dev.azure.com/$organization --output tsv --query [].name)

# Loop through each project
for project in $projects
do
    echo "Project: $project"

    # Get a list of all repos for the project
    repos=$(az repos list --organization https://dev.azure.com/$organization --project $project --output tsv --query [].name)

    # Loop through each repo
    for repo in $repos
    do
        echo "Repo: $repo"

        # List all pipelines for the repo
        az pipelines list --organization https://dev.azure.com/$organization --project $project --repository $repo --output table
    done
done
