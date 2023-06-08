# Set your personal access token, organization, and project
$personalAccessToken = "YOUR_PERSONAL_ACCESS_TOKEN"
$organization = "YOUR_ORGANIZATION"
$project = "YOUR_PROJECT"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Get a list of build pipelines
$pipelinesUrl = "https://dev.azure.com/$organization/$project/_apis/build/definitions?api-version=6.0"
$pipelinesResponse = Invoke-RestMethod -Uri $pipelinesUrl -Headers $headers -Method Get
$pipelinesResponse.value | ForEach-Object {
    # Get a list of runs for each pipeline
    $runsUrl = "https://dev.azure.com/$organization/$project/_apis/build/builds?definitions=$($_.id)&api-version=6.0"
    $runsResponse = Invoke-RestMethod -Uri $runsUrl -Headers $headers -Method Get

    # Get the most recent run
    $lastRun = $runsResponse.value | Sort-Object startTime -Descending | Select-Object -First 1

    Write-Output ("Pipeline ID: {0}, Name: {1}, Created On: {2}, Revision: {3}, Type: {4}, Last Run: {5}, Last Run By: {6}" -f $_.id, $_.name, $_.createdDate, $_.revision, $_.type, $lastRun.startTime, $lastRun.requestedBy.displayName)
}
