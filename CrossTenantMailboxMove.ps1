$AppId = "2a03559e-320f-44e4-bdd0-d8ce41aad8a5"

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppId, (ConvertTo-SecureString -String "NOA7Q~yDnKQsEZGIggBJDWhjAto5bsBdiBe1s" -AsPlainText -Force)

New-MigrationEndpoint -RemoteServer outlook.office.com -RemoteTenant "echots.onmicrosoft.com" -Credentials $Credential -ExchangeRemoteMove:$true -Name "EchoTSMigrationEndpoint" -ApplicationId $AppId


### Org Relationship

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


## Accept Relationship

# Did this from Echo Source Tenant

https://login.microsoftonline.com/echots.onmicrosoft.com/adminconsent?client_id=2a03559e-320f-44e4-bdd0-d8ce41aad8a5&redirect_uri=https://office.com

##Echo Relationship

$targetTenantId="9b03cdab-f4c4-4042-8ffa-62a58ac0a998" #This is Abacus/Destination TenantID
$appId="2a03559e-320f-44e4-bdd0-d8ce41aad8a5"
$scope="AbacusMailMigrationMailboxes" #Name of the AD group in the source client
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

### Stamp users with attributes