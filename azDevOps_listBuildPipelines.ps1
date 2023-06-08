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
    Write-Output ("Pipeline ID: {0}, Name: {1}" -f $_.id, $_.name)
}

# Get the details of a specific pipeline
$pipelineId = "YOUR_PIPELINE_ID"
$pipelineUrl = "https://dev.azure.com/$organization/$project/_apis/build/definitions/$pipelineId?api-version=6.0"
$pipelineResponse = Invoke-RestMethod -Uri $pipelineUrl -Headers $headers -Method Get
Write-Output ("Pipeline ID: {0}, Name: {1}" -f $pipelineResponse.id, $pipelineResponse.name)

# Get a list of runs for a pipeline
$runsUrl = "https://dev.azure.com/$organization/$project/_apis/build/builds?definitions=$pipelineId&api-version=6.0"
$runsResponse = Invoke-RestMethod -Uri $runsUrl -Headers $headers -Method Get
$runsResponse.value | ForEach-Object {
    Write-Output ("Run ID: {0}, Status: {1}" -f $_.id, $_.status)
}
