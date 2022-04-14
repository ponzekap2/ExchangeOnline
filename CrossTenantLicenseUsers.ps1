
### License


$AllMailUsers = Get-DSTMailUser | ?{$_.externalemailaddress -match "echo"}

foreach ($user in $AllMailUsers) {


Set-MsolUser -UserPrincipalName $user.UserprincipalName  -UsageLocation US

if ((Get-MsolUser -UserPrincipalName $user.userprincipalname).IsLicensed -ne "True"){

Set-MsolUserLicense -UserPrincipalName $user.UserprincipalName -AddLicenses "reseller-account:SPB"
}

}


