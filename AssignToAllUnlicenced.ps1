
# prehled pridelenych a volnych licenci
#Get-MsolAccountSku

$license="esocl:STANDARDWOFFPACK_STUDENT","esocl:OFFICESUBSCRIPTION_STUDENT"

# Get-MsolUser -UserPrincipalName kerslager@eso-cl.cz
#povolene aplikace
# (Get-MsolUser -UserPrincipalName kerslager@eso-cl.cz).Licenses.ServiceStatus

# stejny cysledek: Get-MsolUser -All | where {$_.isLicensed -eq $true}
$collection=Get-MsolUser -All -UnlicensedUsersOnly | Where-Object UserPrincipalName -like '*@eso-cl.cz'

$batchSize = 2
$batchCount = 0
$pause = 130

$countdown = $collection.Count
foreach ($item in $collection) {
  if ($batchCount -eq $batchSize){
       Start-Sleep -Seconds $pause
       $batchCount = 0
  }
  $upn=$item.UserPrincipalName
  Write-Host ${countdown}: $upn
  Set-MsolUser -UserPrincipalName $upn -UsageLocation CZ
  Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $license
  $countdown--
  $batchCount++
}