$CSV = Import-CSV C:\Kits\EchoGroups.csv

$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"

Connect-ExchangeOnline -Organization $SourceOrg -Prefix SRC
Connect-ExchangeOnline -Organization $DestinationOrg -Prefix DST

foreach ($group in $csv) {

   Set-DSTDistributionGroup -Identity $Group.abacusemail -RequireSenderAuthenticationEnabled:$False
}