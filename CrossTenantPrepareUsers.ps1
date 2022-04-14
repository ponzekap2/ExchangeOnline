####



$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"

Connect-ExchangeOnline -DelegatedOrganization $SourceOrg -Prefix SRC
Connect-ExchangeOnline -DelegatedOrganization $DestinationOrg -Prefix DST


$SourceUsers = Get-SRCDistributionGroupMember -Identity AbacusMailMigrationMailboxes | ? {$_.RecipientType -eq "UserMailbox"}


foreach ($SourceUser in $SourceUsers) {


$TargetUser = "" | select DisplayName,ExternalEmailAddress,UserPrincipalName,ExchangeGUID,ArchiveGUID,X500,ExtraSMTPAliases1,ExtraSMTPAliases2,FirstName,LastName,alias,Phone,Office,StateOrProvince,Title,Department,City,Country,PrimarySMTPAddress



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
$TargetUser.PrimarySMTPAddress = $TargetUser.ExtraSMTPAliases2 -Replace "smtp:",""



#### Create Target MailUser

$ExistingMailUser = Get-DSTMailUser -Identity $TargetUser.UserPrincipalName -ErrorAction SilentlyContinue

if (!$ExistingMailUser) {New-DSTMailUser -Name $TargetUser.DisplayName  -ExternalEmailAddress $TargetUser.ExternalEmailAddress -MicrosoftOnlineServicesID $TargetUser.UserPrincipalName -Password (ConvertTo-SecureString -String 'Y!3sMegxh@dCi%t3d6J' -AsPlainText -Force) -FirstName $TargetUser.FirstName -lastname $Targetuser.LastName -Alias $TargetUser.Alias}

###Configure Extra Properties

Set-DSTMailUser -Identity $TargetUser.UserprincipalName -ExchangeGuid $TargetUser.ExchangeGuid -ArchiveGuid $TargetUser.ArchiveGUID 
Set-DSTMailUser -Identity $TargetUser.UserprincipalName -EmailAddress @{Add=$TargetUser.X500}
Set-DSTMailUser -Identity $TargetUser.UserprincipalName -EmailAddress @{Add=$TargetUser.ExtraSMTPAliases1}
Set-DSTMailUser -Identity $TargetUser.UserprincipalName -EmailAddress @{Add=$TargetUser.ExtraSMTPAliases2}

#Set Primary Address


Set-DSTMailUser -Identity $TargetUser.USerprincipalName -PrimarySmtpAddress $TargetUser.PrimarySMTPAddress

###Sync X500 Addresses

$X500 = ""
$X500 = ($SourceMailbox).EmailAddresses | ?{$_ -match "X500"} 

if (!$X500 -eq "false") {
foreach ($address in $X500) {


    Set-DSTMailUser -Identity $TargetUser.UserprincipalName -EmailAddress @{Add=$address}
}


Set-MSolUser -UserPrincipalName $TargetUser.UserPrincipalName -Title $TargetUser.Title -Office $TargetUser.Office -PhoneNumber $TargetUser.Phone -Department $TargetUser.Department -City $TargetUser.City -Country $TargetUser.Country



}
}