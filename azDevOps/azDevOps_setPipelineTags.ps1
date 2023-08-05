# Set repo tags

# Set your personal access token and organization
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"
$project = "XXX-XXX-XXX-XXX"
$definitionId = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{
    Authorization = "Basic $base64AuthInfo"
    "Content-Type" = "application/json"
}

# Set URL
$projectsUrl = "https://dev.azure.com/$organization/$project/_apis/build/definitions/$definitionId/tags?api-version=6.1-preview.3"

# Define the tags to add and/or remove
$body = @{
    tagsToAdd = @("tag1", "tag2") # replace with the tags you want to add
    tagsToRemove = @("tag3", "tag4") # replace with the tags you want to remove
} | ConvertTo-Json

# Call the API
$projectsResponse = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Patch -Body $body

# Print the response
$projectsResponse
