# Set your personal access token and organization
$personalAccessToken = "YOUR_PERSONAL_ACCESS_TOKEN"
$organization = "YOUR_ORGANIZATION"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Get a list of all projects
$projectsUrl = "https://dev.azure.com/$organization/_apis/projects?api-version=6.0"
$projectsResponse = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Get
$projectsResponse.value | ForEach-Object {
    $project = $_.name

    # Get a list of build pipelines for each project
    $pipelinesUrl = "https://dev.azure.com/$organization/$project/_apis/build/definitions?api-version=6.0"
    $pipelinesResponse = Invoke-RestMethod -Uri $pipelinesUrl -Headers $headers -Method Get
    $pipelinesResponse.value | ForEach-Object {
        # Get a list of runs for each pipeline
        $runsUrl = "https://dev.azure.com/$organization/$project/_apis/build/builds?definitions=$($_.id)&api-version=6.0"
        $runsResponse = Invoke-RestMethod -Uri $runsUrl -Headers $headers -Method Get

        # Get the most recent run
        $lastRun = $runsResponse.value | Sort-Object startTime -Descending | Select-Object -First 1

        # Check if the last run was more than 12 months ago
        try {
            $lastRunDate = [DateTime]::Parse($lastRun.startTime)
            $oneYearAgo = (Get-Date).AddMonths(-12)
            if ($lastRunDate -lt $oneYearAgo) {
                Write-Output ("Project: {0}, Pipeline ID: {1}, Name: {2}, Created On: {3}, Revision: {4}, Type: {5}, Last Run: {6}, Last Run By: {7}" -f $project, $_.id, $_.name, $_.createdDate, $_.revision, $_.type, $lastRun.startTime, $lastRun.requestedBy.displayName)
            }
        } catch {
            Write-Output ("Error parsing date for run ID: {0} in pipeline ID: {1}, Name: {2} in project: {3}" -f $lastRun.id, $_.id, $_.name, $project)
        }
    }
}

#OUTPUT TO A SINGLE FILE:
#Create a new output file at the beginning of your script.
#Add these lines at the top of your script, right after the param block:

# Create a new output file
# =============================
#$outputFile = "output.txt"
#New-Item -Path $outputFile -ItemType File -Force
# =============================

#This creates a new file named output.txt in the same directory as your script. If a file with the same name already exists, it will be overwritten.

#Change Write-Output to Add-Content.

#Find the Write-Output line in your script:
# =============================
#Write-Output ("Project: {0}, Pipeline ID: {1}, Name: {2}, Created On: {3}, Revision: {4}, Type: {5}, Last Run: {6}, Last Run By: {7}" -f $project, $_.id, $_.name, $_.createdDate, $_.revision, $_.type, $lastRun.startTime, $lastRun.requestedBy.displayName)
# =============================

#And replace it with Add-Content:
# =============================
#$output = "Project: {0}, Pipeline ID: {1}, Name: {2}, Created On: {3}, Revision: {4}, Type: {5}, Last Run: {6}, Last Run By: {7}" -f $project, $_.id, $_.name, $_.createdDate, $_.revision, $_.type, $lastRun.startTime, $lastRun.requestedBy.displayName
#Add-Content -Path $outputFile -Value $output
# =============================

#This appends the output to the file specified by $outputFile instead of printing it to the console.

