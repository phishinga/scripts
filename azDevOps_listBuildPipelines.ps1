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
    Write-Output ("Pipeline ID: {0}, Name: {1}, Created On: {2}, Revision: {3}, Type: {4}" -f $_.id, $_.name, $_.createdDate, $_.revision, $_.type)

    # Get a list of runs for each pipeline
    $runsUrl = "https://dev.azure.com/$organization/$project/_apis/build/builds?definitions=$($_.id)&api-version=6.0"
    $runsResponse = Invoke-RestMethod -Uri $runsUrl -Headers $headers -Method Get
    $runsResponse.value | ForEach-Object {
        Write-Output ("    Run ID: {0}, Status: {1}, Result: {2}, Start Time: {3}, Finish Time: {4}, Requested By: {5}" -f $_.id, $_.status, $_.result, $_.startTime, $_.finishTime, $_.requestedBy.displayName)
    }
}
