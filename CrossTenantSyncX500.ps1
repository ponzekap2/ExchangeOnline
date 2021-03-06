####



$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"

Connect-ExchangeOnline -Organization $SourceOrg -Prefix SRC
Connect-ExchangeOnline -Organization $DestinationOrg -Prefix DST


$SourceUsers = Get-SRCDistributionGroupMember -Identity AbacusMailMigrationMailboxes | ? {$_.RecipientType -eq "UserMailbox"}

foreach ($SourceUser in $SourceUsers) {
    $TargetUser = "" | select DisplayName,ExternalEmailAddress,UserPrincipalName,ExchangeGUID,ArchiveGUID,X500,ExtraSMTPAliases1,ExtraSMTPAliases2,FirstName,LastName,alias,Phone,Office,StateOrProvince,Title,Department,City,Country



    $SourceMailbox = Get-SRCMailbox -Identity $SourceUser.PrimarySMTPAddress
    
    
    ## Create Target User
    $TargetUser.DisplayName = $SourceMailbox.DisplayName
    $TargetUser.ExternalEmailAddress = $SourceMailbox.PrimarySMTPAddress
    $TargetUser.UserPrincipalName = $SourceMailbox.Alias + "@abacusgroupllcclient.onmicrosoft.com"
    $TargetUser.ExchangeGUID = $SourceMailbox.ExchangeGUID
    $TargetUser.ArchiveGUID = $SourceMailbox.ArchiveGUID
    $TargetUser.X500 = "X500:"+$SourceMailbox.LegacyExchangeDN
    $TargetUser.ExtraSMTPAliases1 = "smtp:"+$SourceMailbox.Alias + "@abacusgroupllcclient.mail.onmicrosoft.com"
    $TargetUser.ExtraSMTPAliases2 = "smtp:"+$SourceMailbox.Alias + "@abacusgroupllc.com"
    $TargetUser.FirstName = $SourceUser.FirstName
    $TargetUser.LastName = $SourceUser.LastName
    $TargetUser.Alias = $SourceUser.Alias
    $TargetUser.Phone = $SourceUser.Phone
    $TargetUser.Office = $SourceUser.Office
    $TargetUser.StateOrProvince = $SourceUser.StateorProvince
    $TargetUser.Title = $SourceUser.Title
    $TargetUser.City = $SourceUser.City
    $TargetUser.Department = $SourceUser.Department
    $TargetUser.Country = $SourceUser.CountryOrRegion

$X500 = ""
$X500 = (Get-SRCMailBox -Identity $SourceUser.PrimarySMTPAddress).EmailAddresses | ?{$_ -match "X500"} 

if ($null -ne $x500) {
foreach ($address in $X500) {

    Write-Host "Setting X500"
    Set-DSTMailUser -Identity $TargetUser.UserprincipalName -EmailAddress @{Add=$address}
}

}
}