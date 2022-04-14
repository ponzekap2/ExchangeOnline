$CSV = Import-CSV C:\Kits\EchoGroups.csv

$SourceOrg = "echots.onmicrosoft.com"
$DestinationOrg = "abacusgroupllcclient.onmicrosoft.com"

Connect-ExchangeOnline -Organization $SourceOrg -Prefix SRC
Connect-ExchangeOnline -Organization $DestinationOrg -Prefix DST

foreach ($group in $csv) {


 
$SourceGroupObj = Get-SRCDistributionGroup -Identity $group.echoemail
$SourceGroupMembers = Get-SRCDistributionGroupMember -Identity $group.echoemail

##Strip Email Address for name

$NewGroupName = $group.abacusemail -replace "@abacusgroupllc.com",""

#Create New Group in Abacus

$ExistingGroup = Get-DSTDistributionGroup -Identity $NewGroupName

if (!$ExistingGroup) {New-DSTDistributionGroup -Name $NewGroupName -Description "Echo Migrated Group" -PrimarySmtpAddress $group.abacusemail}


###Migrate Users

foreach ($member in $SourceGroupMembers) {

if ($member.RecipientType -match "group") {
    $i = $csv | ?{$_.echoemail -match $member.PrimarySMTPAddress}
    try {
        Add-DSTDistributionGroupmember -Identity $group.abacusemail -member $i.AbacusEmail -ErrorAction Stop
    }
    catch {
        Write-Host "The object $($i.AbacusEmail) is already a member of $($group.abacusemail)" -ForegroundColor Green
    }
    }



if ($member.RecipientType -eq "UserMailbox") { $DestinationMailUser = Get-DSTMailUser -Identity $member.PrimarySMTPAddress

    try {
        Add-DSTDistributionGroupMember -Identity $group.abacusemail -member $DestinationMailUser.PrimarySMTPAddress -ErrorAction Stop
    }
    catch {
        Write-Host "The object $($DestinationMailUser.PrimarySMTPAddress) is already a member of $($group.abacusemail)" -ForegroundColor Green
    }

 }

if ($member.RecipientType -eq "MailUser") { 
    
    $ExternalEmailAddress = $Member.ExternalEmailAddress -Replace "smtp:",""
    
    $DestinationMailBox = Get-DSTMailBox -Identity $ExternalEmailAddress

    try {
        Add-DSTDistributionGroupMember -Identity $group.abacusemail -member $DestinationMailBox.PrimarySMTPAddress -ErrorAction Stop
    }
    catch {
        Write-Host "The object $($DestinationMailBox.PrimarySMTPAddress) is already a member of $($group.abacusemail)" -ForegroundColor Green
    }






}

if ($member.RecipientType -eq "MailContact") {

    $ExternalEmail = $member.ExternalEmailAddress -replace "smtp:",""
    Remove-Variable ExistingMailContact -ErrorAction silentlycontinue
    
    try {
        New-DSTMailContact -Name $member.DisplayName -FirstName $member.FirstName -LastName $member.LastName -ExternalEmailAddress $ExternalEmail -ErrorAction Stop
    }
    catch {
        Write-Host "Contact $externalemail already exists" -ForegroundColor Red
    }


try {
    Add-DSTDistributionGroupMember -Identity $group.abacusemail -member $ExternalEmail -ErrorAction Stop
}
catch {
    Write-Host "The object $ExternalEmail is already a member of $($group.abacusemail)" -ForegroundColor Green
}

}

}
}
