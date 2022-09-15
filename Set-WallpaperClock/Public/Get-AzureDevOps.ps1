function Get-AzureDevOps {
    [CmdletBinding()]
    param (
        [string]$patToken,
        [string]$organizationName,
        [string]$projectName,
        [string]$userFullName,
        [string]$userPrincipalName
    )
    
    begin {
        
        $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($patToken)"))
        $header = @{authorization = "Basic $token" }
        
        $UriOrga = "https://dev.azure.com/$($OrganizationName)/$($projectName)/"
        $uriAccount = $UriOrga + "_apis/wit/wiql?api-version=5.1"

        $wiql = "SELECT
        [System.Id],
        [System.WorkItemType],
        [System.Title],
        [System.AssignedTo],
        [System.State],
        [System.Tags]
FROM workitems
WHERE
        [System.TeamProject] = @project
        AND [System.State] <> 'Closed'
        AND [System.AssignedTo] = '$($userFullName) <$($userPrincipalName)>'
        AND [system.IterationPath] = @CurrentIteration"
        $body = @{ query = $wiql }
        $bodyJson = @($body) | ConvertTo-Json

               
    }
    
    process {
        
        $Results = Invoke-RestMethod -Uri $uriAccount -Method Post -ContentType "application/json" -Headers $header -Body $bodyJson

    }
    
    end {
        Write-Output $results.workItems.id
    }
}