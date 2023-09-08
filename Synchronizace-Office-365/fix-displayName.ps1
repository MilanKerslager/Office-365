# Import active directory module for running AD cmdlets
Import-Module activedirectory
  
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv .\fix-displayName.csv

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
    $distname    = $User.DISTINGUISHEDNAME
    $objectclass = $User.OBJECTCLASS
    $attribute   = $User.ATTRIBUTE
    $update      = $User.UPDATE
    $givenname   = ($update -split ' ')[0]
    $surname     = $update -replace "$givenname\s+"
    if ($objectclass = "user") {
	    #Write-Host "$objectclass $distname $attribute $update"
        #Write-Host "krestni:$givenname prijmeni:$surname"
        Set-ADUser "$distname" -DisplayName "$update" -GivenName "$givenname" -Surname "$surname" #-WhatIf -Verbose
    } else {
        Write-Host "Skipping: $update"
    }
    #break
}

# neco jako: Import-Csv "C:\scripts\ad\update_ad_users.csv" | foreach {Set-ADUser -Identity $_.SamAccountName –Title $_.Title -MobilePhone $_.MobilePhone}