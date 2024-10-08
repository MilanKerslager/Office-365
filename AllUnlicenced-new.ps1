# https://github.com/MicrosoftDocs/microsoft-365-docs/blob/public/microsoft-365/enterprise/assign-licenses-to-user-accounts-with-microsoft-365-powershell.md
# run this before running this script: Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All"
# verify: Get-MgUserLicenseDetail -UserId "kerslager@eso-cl.cz"

$collection=Get-MgUser -Select Id,DisplayName,Mail,UserPrincipalName,UsageLocation,UserType -All | where { $_.UsageLocation -eq $null -and $_.UserType -eq 'Member' }

#$batchSize = 200
#$batchCount = 0
#$pause = 130

$countdown = $collection.Count
Write-Host "Number of accounts without UsageLocation: "$countdown
foreach ($item in $collection) {
  #if ($batchCount -eq $batchSize){
  #     Start-Sleep -Seconds $pause
  #     $batchCount = 0
  #}
  $upn=$item.UserPrincipalName
  Write-Host ${countdown}: $upn
  Update-MgUser -UserId $upn -UsageLocation "CZ"
  $countdown--
  #$batchCount++
}

$stuA1 = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'STANDARDWOFFPACK_STUDENT'
$stu365 = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'OFFICESUBSCRIPTION_STUDENT'
$addLicenses = @(
    @{SkuId = $stuA1.SkuId},
    @{SkuId = $stu365.SkuId}
)

$collection=Get-MgUser -Filter 'assignedLicenses/$count eq 0 and OnPremisesSyncEnabled eq true' -ConsistencyLevel eventual -CountVariable unlicensedUserCount -All -Select UserPrincipalName
$countdown = $collection.Count
Write-Host "Number of unlicenced accounts: "$countdown
foreach ($item in $collection) {
  $upn=$item.UserPrincipalName
  Write-Host ${countdown}: $upn
  Set-MgUserLicense -UserId $upn -AddLicenses $addLicenses -RemoveLicenses @() | Out-Null
  $countdown--
}
