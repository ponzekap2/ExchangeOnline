
$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"

Connect-ExchangeOnline -DelegatedOrganization $SourceOrg -Prefix SRC
Connect-ExchangeOnline -DelegatedOrganization $DestinationOrg -Prefix DST


$CSV = Import-CSV C:\Kits\EchoGroups.csv


#### Create Mail Contacts in Echo and add them to their respective group


foreach ($group in $csv) {

    try {
        $MailContactAlias = "AbacusGroup-" + $group.abacusemail -replace "@abacusgroupllc.com", ""

        New-MailContact -Name $MailContactAlias -ExternalEmailAddress $group.abacusemail -ErrorAction Stop -OrganizationalUnit "echots.com/EchoTS Mailcontacts"
    }
    catch {
        Write-Host "The object $($MailContactAlias) already exists" -ForegroundColor Green
    }

}


#### Create Backup

foreach ($group in $csv) {
#Create Backup

Write-Host "Creating backup file for $($group.echoemail)"

$GroupMembers = Get-SRCDistributionGroupMember -Identity $group.EchoEmail

##Save Members
$GroupMembers | Export-CliXML -Path C:\Kits\EchoGroupBackups\$($group.echoemail).xml
}

##### Remove Members
foreach ($group in $csv) {

    try {
        $MailContactAlias = "AbacusGroup-" + $group.abacusemail -replace "@abacusgroupllc.com", ""
        Add-SRCDistributionGroupMember -Identity $group.EchoEmail -Member $MailContactAlias -ErrorAction Stop -BypassSecurityGroupManagerCheck
    }
    catch {
        Write-Host "There was an error adding the mailcontact to $($group.EchoEmail)" -ForegroundColor Red
    }


    $GroupMembers = Get-DistributionGroupMember -Identity $group.EchoEmail

    #Ensure the AbacusMailContact has been added before moving on
    if ($GroupMembers | ?{$_.Alias -eq $MailContactAlias}) {

        #Strip out non Abacus mail contact
        $EchoGroupMembers = $GroupMembers | ?{$_.Alias -ne $MailContactAlias}
    foreach ($member in $EchoGroupMembers) {

            Remove-DistributionGroupMember -Identity $Group.echoemail -Member $member.identity -BypassSecurityGroupManagerCheck -Confirm:$false
            Write-host "Removing "$member.DisplayName" from $($group.echoemail)"

    }
}

    }