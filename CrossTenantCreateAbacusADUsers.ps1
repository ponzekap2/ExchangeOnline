
$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"
$SecureString = "ENTERSTRING"

Connect-ExchangeOnline -Organization $SourceOrg -Prefix SRC
Connect-ExchangeOnline -Organization $DestinationOrg -Prefix DST


$SourceUsers = Get-SRCDistributionGroupMember -Identity AbacusMailMigrationMailboxes | ? {$_.RecipientType -eq "UserMailbox"}


foreach ($SourceUser in $SourceUsers) {



$TargetUser = "" | select Alias,City,PostalCode,Department,DisplayName,FirstName,LastName,Office,PrimarySMTPAddress,StateorProvince,Title
$OU = "OU=EchoUsers,OU=Users,OU=Abacus,DC=abacus,DC=corp"
$SourceMailbox = Get-SRCMailbox -Identity $SourceUser.PrimarySMTPAddress

#Create Object

$Targetuser.Alias = $SourceUser.alias
$TargetUser.City = $SourceUser.City
$TargetUser.Department = $SourceUser.Department
$TargetUser.Displayname = $SourceUser.DisplayName
$TargetUser.FirstName = $SourceUser.FirstName
$TargetUser.LastName = $SourceUser.Lastname
$TargetUser.Office = $SourceUser.Office
$TargetUser.StateOrProvince = $SourceUser.StateorProvince
$TargetUser.Title = $SourceUser.Title
$TargetUser.PrimarySMTPAddress = $SourceUser.PrimarySMTPAddress -replace "@echots.com", "@abacusgroupllc.com"



New-AdUser -DisplayName $TargetUser.DisplayName -GivenName $TargetUser.FirstName -Surname $TargetUser.LastName -name $TargetUser.DisplayName -Office $TargetUser.Office -State $TargetUser.StateorProvince -EmailAddress $TargetUser.PrimarySMTPAddress -UserprincipalName $TargetUser.PrimarySMTPAddress -samaccountname $TargetUser.Alias -Title $TargetUser.Title -city $TargetUser.City -AccountPassword (ConvertTo-SecureString -String $SecureString -AsPlainText -Force) -Path $ou -Department $TargetUser.Department -Company "Echo IT" -Enabled:$true



}