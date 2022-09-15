$patToken = __patToken__
$organizationName = __organizationName__
$projectName = __projectName__
$userFullName = __userFullName__
$userPrincipalName = __userPrincipalName__

$Output = New-Object psobject
add-member -InputObject $Output -MemberType NoteProperty -Name patToken -Value $patToken -TypeName string
add-member -InputObject $Output -MemberType NoteProperty -Name organizationName -Value $organizationName -TypeName string
add-member -InputObject $Output -MemberType NoteProperty -Name projectName -Value $projectName -TypeName string
add-member -InputObject $Output -MemberType NoteProperty -Name userFullName -Value $userFullName -TypeName string
add-member -InputObject $Output -MemberType NoteProperty -Name userPrincipalName -Value $userPrincipalName -TypeName string

$Output
