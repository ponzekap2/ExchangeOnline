Connect-AzureAD

$ADDomain = "abacus.corp"

$AllAzureADUsers = Get-AzureADUser -All $true
$AllAzureADUsers = $AllAzureADUsers | ?{$_.immutableid -ne $null}

#Debug

$AllAzureADUsers = $AllAzureADUsers[60..80]

## End Debug
foreach ($AzureUser in $AllAzureADUsers) {
$LocalADUser = ""

Write-Host "Converting ImmutableId of user $($Azureuser.Displayname)" -ForegroundColor Green
$ConvertedImmutableID = [Guid]([Convert]::FromBase64String($AzureUser.ImmutableID))

Write-Host "Converted ImmutableID to $ConvertedImmutableID" -ForegroundColor Green

#Get local AD Object
Write-Host "Searching for local AD version of user $($Azureuser.Displayname)" -ForegroundColor Green



try {
    $LocalADUser = Get-ADUser -server $ADDomain -identity $ConvertedImmutableID -ErrorAction Stop
}
catch {
    Write-Host "Local AD version of user $($Azureuser.Displayname) not found" -ForegroundColor Red
}

if (!$LocalADUser -eq $False) {Write-Host "Found local AD User $($LocalADUser.name)" -ForegroundColor Green;

#Add Each Proxy Address

foreach ($Address in $AzureUser.ProxyAddresses) {

Write-Host "Attempting to add proxy email address of $address to $($LocalADUser.name)" -ForegroundColor Green    
$LocalADUser | Set-AdUser -add @{ProxyAddresses=$Address}

}
}


}