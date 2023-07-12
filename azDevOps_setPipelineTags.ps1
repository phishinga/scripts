# Set repo tags

# Set your personal access token and organization
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"
$project = "XXX-XXX-XXX-XXX"
$definitionId = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{
    #Authorization=("Basic {0}" -f $base64AuthInfo)
    Authorization = "Basic $base64AuthInfo"
    "Content-Type" = "application/json"
}

# Set URL
$projectsUrl = "https://dev.azure.com/$organization/$project/_apis/build/definitions/$definitionId/tags/AppSecEngr?api-version=6.0-preview.2"

# Lets call someone
$projectsResponse = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Put 

# Print it out baby
#$projectsResponse.value | ForEach-Object { Write-Output ("Project: {0}" -f $_.name) }
$projectsResponse
