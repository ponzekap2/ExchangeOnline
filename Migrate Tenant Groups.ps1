#Connect with source tenant
Connect-AzureAD

#Connect with destination tenant
Connect-ExchangeOnline

$DL = "distrobutionlist1","distrobutionlist2"

$SourceDomain = "echots.com"
$DestinationDomain = "abacusgroupllc.com"

foreach($D in $DL){
    
   $List = @()
   $List = Get-AzureADGroup -SearchString "$D"

   $ListMembers = @()
   $ListMembers = Get-AzureADGroupMember -ObjectId $List.ObjectId

   $ListMembersUPN = @()
   $ListMembersUPN = $ListMembers.UserPrincipalName

   New-DistributionGroup -Name $List.DisplayName -Description $List.Description -PrimarySmtpAddress $($List.MailNickName+"@$DestinationDomain")
    
   foreach($ListMemberUPN in $ListMembersUPN){
   
               
        Add-DistributionGroupMember -Identity $List.DisplayName -Member $ListMemberUPN.replace("$SourceDomain","$DestinationDomain")
        
        }
    }
   
   
   