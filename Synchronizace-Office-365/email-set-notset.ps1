# AD synchronizace: https://docs.microsoft.com/en-us/microsoft-365/enterprise/prepare-a-non-routable-domain-for-directory-synchronization
#$LocalUsers = Get-ADUser -Filter "UserPrincipalName -like '*eurocl.local'" -Properties userPrincipalName -ResultSetSize $null
#$LocalUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("@eurocl.local","@eso-cl.cz"); $_ | Set-ADUser -UserPrincipalName $newUpn}

$LocalUsers = Get-ADUser -Filter {(UserPrincipalName -like "*") -and (mail -notlike "*") } -Properties mail -ResultSetSize $null

foreach ($User in $LocalUsers)
{
    $distname    = $User.DISTINGUISHEDNAME
    Write-Host $User.UserPrincipalName
    Set-ADUser "$distname" -EmailAddress $User.UserPrincipalName
}