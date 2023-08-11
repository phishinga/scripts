#
# Motivation:
# Not all applications need to interact with the Kubernetes API. 
# If an attacker gains access to a Pod, they could potentially misuse 
# this token to carry out privileged operations, 
# especially if the associated ServiceAccount has broad permissions.
#
# Disabling Automatic Service Token Mounting:
# To enhance security, Kubernetes provides an option to disable the 
# automatic mounting of ServiceAccount tokens.
#
# When defining a Pod, you can disable token mounting by setting 
# automountServiceAccountToken to false in the Pod spec.
# If you want to disable token mounting for all Pods that use a 
# specific ServiceAccount, you can set automountServiceAccountToken 
# to false in the ServiceAccount spec.
#

$directoryPath = Join-Path -Path $PSScriptRoot -ChildPath "pods" # Replace 'yourFolderName' with the name of the folder

Get-ChildItem -Path $directoryPath -Recurse -Filter *.yaml | ForEach-Object {
    $currentFile = $_
    $content = Get-Content -Path $currentFile.FullName

    $foundFalse = $false
    $foundTrue = $false

    $content | ForEach-Object {
        if ($_ -match "automountServiceAccountToken:\s*false") {
            Write-Output ("[FALSE FOUND] File: " + $currentFile.Name + " -> Line: " + $_)
            $foundFalse = $true
        }
        elseif ($_ -match "automountServiceAccountToken:\s*true") {
            Write-Output ("[TRUE FOUND] File: " + $currentFile.Name + " -> Line: " + $_)
            $foundTrue = $true
        }
    }

    if (-not $foundFalse -and -not $foundTrue) {
        Write-Output ("[NOT FOUND] File: " + $currentFile.Name + " has no mention of automountServiceAccountToken.")
    }
}

