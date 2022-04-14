###Migration Endpoint

$AppId = "APPID"

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppId, (ConvertTo-SecureString -String "SECURESTRING" -AsPlainText -Force)

New-MigrationEndpoint -RemoteServer outlook.office.com -RemoteTenant "echots.onmicrosoft.com" -Credentials $Credential -ExchangeRemoteMove:$true -Name "AbacusEchoMigration" -ApplicationId $AppId

### Test Endpoint

Test-MigrationServerAvailability -Endpoint AbacusEchoMigration -TestMailbox jecho@echots.com

###Target

$sourceTenantId="[tenant id of your trusted partner, where the source mailboxes are]"
$orgrels=Get-OrganizationRelationship
$existingOrgRel = $orgrels | ?{$_.DomainNames -like $sourceTenantId}
If ($null -ne $existingOrgRel)
{
    Set-OrganizationRelationship $existingOrgRel.Name -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability Inbound
}
If ($null -eq $existingOrgRel)
{
    New-OrganizationRelationship "echots.com" -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability Inbound -DomainNames echots.com,echots.mail.onmicrosoft.com,echots.onmicrosoft.com
}

#### Source Tenant

$targetTenantId="TENANTID"
$appId="APPID"
$scope="AbacusMailMigrationMailboxes"
$orgrels=Get-OrganizationRelationship
$existingOrgRel = $orgrels | ?{$_.DomainNames -like $targetTenantId}
If ($null -ne $existingOrgRel)
{
    Set-OrganizationRelationship $existingOrgRel.Name -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability RemoteOutbound -OAuthApplicationId $appId -MailboxMovePublishedScopes $scope
}
If ($null -eq $existingOrgRel)
{
    New-OrganizationRelationship "abacusgroupllc.com" -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability RemoteOutbound -DomainNames abacusgroupllc.com,abacusgroupllcclient.onmicrosoft.com,abacusgroupllcclient.mail.onmicrosoft.com -OAuthApplicationId $appId -MailboxMovePublishedScopes $scope
}

####



$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"

Connect-ExchangeOnline -Organization $SourceOrg -Prefix SRC
Connect-ExchangeOnline -Organization $DestinationOrg -Prefix DST

$SourceUser = "techo@echots.com"
$TargetUser = "techo@abacusgroupllcclient.onmicrosoft.com"

$SourceMailbox = Get-SRCMailbox -Identity $SourceUser


$SourceMailbox.ExchangeGUID
$SourceMailbox.ArchiveGUID
$SourceMailbox.LegacyExchangeDN
$SourceMailbox.userprincipalname
$SourceMailbox.PrimarySMTPAddress

#Create Mail User on Target
#Ensure user is synced to 365 as AD only



$TargetMailUser = Get-DSTMailUser -Identity $TargetUser

$TargetMailUser | Set-DSTMailUser -ExchangeGuid $SourceMailbox.ExchangeGuid -ArchiveGuid $SourceMailbox.ArchiveGUID