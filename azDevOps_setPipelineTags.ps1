# Get a list of all projects

# Set your personal access token and organization
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"
$project = "XXX-XXX-XXX-XXX"
$definitionID = "XXX-XXX-XXX-XXX"


# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Lets call someone
#$projectsUrl = "https://dev.azure.com/$organization/_apis/projects?api-version=6.0"
$projectsUrl = "https://dev.azure.com/$organization/$project/_apis/build/definitions/$definitionID/tags?api-version=6.0-preview.2"
$projectsResponse = Invoke-RestMethod -Uri $projectsUrl -Headers $headers -Method Post -Body (ConvertTo-Json $requestBody)
#$projectsResponse.value | ForEach-Object { Write-Output ("Project: {0}" -f $_.name) }

# Insert tag values
$requestBody = @{
    tags = @("TAG1")
}

# Print it out baby
$projectsResponse




Invoke-RestMethod : {"$id":"1","innerException":null,"message":"The request indicated a Content-Type of \"application/x-www-form-urlencoded\" for 
method type \"POST\" which is not supported. Valid content types for this method are: application/json, 
application/json-patch+json.","typeName":"Microsoft.VisualStudio.Services.WebApi.VssRequestContentTypeNotSupportedException, 
Microsoft.VisualStudio.Services.WebApi","typeKey":"VssRequestContentTypeNotSupportedException","errorCode":0,"eventId":3000}
