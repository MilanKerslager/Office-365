# AD synchronizace: https://docs.microsoft.com/en-us/microsoft-365/enterprise/prepare-a-non-routable-domain-for-directory-synchronization
$LocalUsers = Get-ADUser -Filter "UserPrincipalName -like '*eurocl.local'" -Properties userPrincipalName -ResultSetSize $null
$LocalUsers | foreach {$newUpn = $_.UserPrincipalName.Replace("@eurocl.local","@eso-cl.cz"); $_ | Set-ADUser -UserPrincipalName $newUpn}

