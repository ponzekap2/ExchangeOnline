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


UserPrincipalName               ImmutableID
-----------------               -----------
amikev@abacusgroupllc.com       23lZRSPsUUmlskzuHfIL0Q==
jlagore@abacusgroupllc.com      YV8Tsw72gEeIo3rxQBLwGQ==
tanunciacion@abacusgroupllc.com P+N2XtzwK0O7TRDQ6VyDVw==
dtan@abacusgroupllc.com         tJzIJPTvgU6REwgHJEriVQ==
hchristensen@abacusgroupllc.com i7j9okqMtkOiqPzN6N4LXg==
sgeorgiev@abacusgroupllc.com    nENSxscD80yhMH176Re8cw==
rparrish@abacusgroupllc.com     tH/xjISx5kaLPlQCJGi5wQ==
dgammill@abacusgroupllc.com     19XG0ZzgVEKlqs5Knopw8g==
nasc@abacusgroupllc.com         HEU1EzbPgEmnIHn7lAlXQQ==
hyordanov@abacusgroupllc.com    X/wb4UtbgkGPl68udQOiFg==
canunciacion@abacusgroupllc.com /38y8JzdBkmbpZ1lfOO79w==
rfranada@abacusgroupllc.com     KT96LLN2c0+Dpk/Nfh3T4w==
itsanev@abacusgroupllc.com      3qadpQ2ErUuJ0UUQFrENyg==
jsantos@abacusgroupllc.com      /6RwELGzYkCJU8ue3nEsUA==
rhyshiver@abacusgroupllc.com    a93Ty1JsIkG5FBL3hhgpmA==
sgardakov@abacusgroupllc.com    o0D9zKCW6Uug1A6l9STZIQ==
ddimov@abacusgroupllc.com       1mpyjQRZwUuBhRDiHCcBfg==