$MailUsers = get-msoluser | ?{$_.userprincipalname -match "onmicrosoft" -and $_.ImmutableID -ne $null -and $_.islicensed -eq "True"}

foreach ($user in $MailUsers) {

    $AdjustedAccount = "" | select UserPrincipalName,ImmutableID

    $AdjustedAccount.UserPrincipalName = $User.UserPrincipalName -Replace "@abacusgroupllcclient.onmicrosoft.com","@abacusgroupllc.com"
    $AdjustedAccount.ImmutableID = $User.ImmutableID

    Set-MsolUserPrincipalName -UserPrincipalName $User.UserPrincipalName -NewUserPrincipalName $AdjustedAccount.UserPrincipalName -ImmutableID $AdjustedAccount.ImmutableID
}

foreach ($user in $MailUsers) {

    $AdjustedAccount = "" | select UserPrincipalName,ImmutableID

    $AdjustedAccount.UserPrincipalName = $User.UserPrincipalName -Replace "@abacusgroupllcclient.onmicrosoft.com","@abacusgroupllc.com"
    $AdjustedAccount.ImmutableID = $User.ImmutableID
Get-MsolUser -UserPrincipalName $AdjustedAccount.UserPrincipalName | Select UserPrincipalName,ImmutableID

}
