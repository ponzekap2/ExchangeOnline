$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"


Connect-ExchangeOnline -Organization $DestinationOrg -Prefix DST
Connect-MsolService


### Functions

function guidtobase64
{
    param($str);
    $g = new-object -TypeName System.Guid -ArgumentList $str;
    $b64 = [System.Convert]::ToBase64String($g.ToByteArray());
    return $b64;
}

### Variable
$RemoteDomain = "Abacus.corp"
$SourceAttribute = "ObjectGUID"
$RemoteDC = "NYDC-ABADC01.abacus.corp"


##Get Users

$AllEchoUsers = Get-DSTMailUser | ?{$_.externalemailaddress -match "echo"}

foreach ($echouser in $AllEchoUsers) {

$OnPremUPN = $echouser.UserPrincipalName -replace "@abacusgroupllcclient.onmicrosoft.com","@abacusgroupllc.com"


$RemoteUser = Get-AdUser -Server $RemoteDC -Properties * -filter {UserPrincipalName -eq $OnPremUPN}
$RemoteAttributetoSet = $RemoteUser.$SourceAttribute
if ($SourceAttribute -eq "ObjectGUID") {$RemoteAttributetoSet = guidtobase64 -str $RemoteAttributetoSet}

### Stamp Office 365

Get-MsolUser -UserPrincipalName $echouser.UserPrincipalName |Set-MSOLUser -ImmutableID $RemoteAttributetoSet

}


##List Immutable

##Get Users

$AllEchoUsers = Get-DSTMailUser | ?{$_.externalemailaddress -match "echo"}

foreach ($echouser in $AllEchoUsers) {

$OnPremUPN = $echouser.UserPrincipalName -replace "@abacusgroupllcclient.onmicrosoft.com","@abacusgroupllc.com"


$RemoteUser = Get-AdUser -Server $RemoteDC -Properties * -filter {UserPrincipalName -eq $OnPremUPN}
$RemoteAttributetoSet = $RemoteUser.$SourceAttribute
if ($SourceAttribute -eq "ObjectGUID") {$RemoteAttributetoSet = guidtobase64 -str $RemoteAttributetoSet}

### Stamp Office 365

Get-MsolUser -UserPrincipalName $echouser.UserPrincipalName |Select ImmutableID

}