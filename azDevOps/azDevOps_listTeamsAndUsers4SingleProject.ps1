# Set your personal access token and organization
$personalAccessToken = "XXX-XXX-XXX-XXX"
$organization = "XXX-XXX-XXX-XXX"
$project = "XXX-XXX-XXX-XXX"

# Create the authorization header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Get a list of teams for the project
#$teamsUrl = "https://dev.azure.com/$organization/$project/_apis/teams?api-version=6.0"
$teamsUrl = "https://dev.azure.com/$organization/_apis/teams?api-version=6.0-preview"
$teamsResponse = Invoke-RestMethod -Uri $teamsUrl -Headers $headers -Method Get

$teamsResponse.value | ForEach-Object {
    $team = $_.name

    # Get a list of team members for each team
    $membersUrl = "https://dev.azure.com/$organization/_apis/projects/$project/teams/$team/members?api-version=6.0"
    $membersResponse = Invoke-RestMethod -Uri $membersUrl -Headers $headers -Method Get

    $membersResponse.value | ForEach-Object {
        Write-Output ("Project: {0}, Team: {1}, Member: {2}" -f $project, $team, $_.identity.displayName)
    }
}
