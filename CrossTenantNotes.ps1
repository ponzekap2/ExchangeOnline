### Destination

CrossTenantMigration

Application Client ID - 7aa8bc66-abc5-40c6-a1da-2dbbe8317bf8
Object ID - 0e0d6234-260c-4c75-bff9-f6e4798e6f47
Tenant ID Abacus - 9b03cdab-f4c4-4042-8ffa-62a58ac0a998

#Secret

Value = k3g7Q~L~87eAY.bH~8VFAH8XBmCUQVLWuIQAe
Secret ID = 586e2faf-9162-488a-9fbf-bd1c3a96b33f



https://login.microsoftonline.com/echots.onmicrosoft.com/adminconsent?client_id=7aa8bc66-abc5-40c6-a1da-2dbbe8317bf8&redirect_uri=https://office.com


##Target Side
#Migration Endpoint

$AppId = "7aa8bc66-abc5-40c6-a1da-2dbbe8317bf8"

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppId, (ConvertTo-SecureString -String 'k3g7Q~L~87eAY.bH~8VFAH8XBmCUQVLWuIQAe' -AsPlainText -Force)

New-MigrationEndpoint -RemoteServer outlook.office.com -RemoteTenant "echots.onmicrosoft.com" -Credentials $Credential -ExchangeRemoteMove:$true -Name "EchoToAbacus" -ApplicationId $AppId

#Relationship

$sourceTenantId="907edcec-0e15-4f01-8037-660aecdd8492"
$orgrels=Get-OrganizationRelationship
$existingOrgRel = $orgrels | ?{$_.DomainNames -like $sourceTenantId}
If ($null -ne $existingOrgRel)
{
    Set-OrganizationRelationship $existingOrgRel.Name -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability Inbound
}
If ($null -eq $existingOrgRel)
{
    New-OrganizationRelationship "echots.com" -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability Inbound -DomainNames $sourceTenantId
}



### Source

https://login.microsoftonline.com/echots.onmicrosoft.com/adminconsent?client_id=7aa8bc66-abc5-40c6-a1da-2dbbe8317bf8&redirect_uri=https://office.com


$targetTenantId="9b03cdab-f4c4-4042-8ffa-62a58ac0a998"
$appId="7aa8bc66-abc5-40c6-a1da-2dbbe8317bf8"
$scope="AbacusMailMigrationMailboxes"
$orgrels=Get-OrganizationRelationship
$existingOrgRel = $orgrels | ?{$_.DomainNames -like $targetTenantId}
If ($null -ne $existingOrgRel)
{
    Set-OrganizationRelationship $existingOrgRel.Name -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability RemoteOutbound -OAuthApplicationId $appId -MailboxMovePublishedScopes $scope
}
If ($null -eq $existingOrgRel)
{
    New-OrganizationRelationship "abacusgroupllc.com" -Enabled:$true -MailboxMoveEnabled:$true -MailboxMoveCapability RemoteOutbound -DomainNames $targetTenantId -OAuthApplicationId $appId -MailboxMovePublishedScopes $scope
}


###Target

Test-MigrationServerAvailability -Endpoint echotoabacus -TestMailbox jecho@echots.com