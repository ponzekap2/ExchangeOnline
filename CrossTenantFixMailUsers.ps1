$Mailusers = Get-DSTMailUser | ?{$_.externalemailaddress -match "echo"}

foreach ($User in $Mailusers) {

$MicrosoftAddress = $User.externalemailaddress -replace "SMTP:",""
$MicrosoftAddress = $MicrosoftAddress -replace "@echots.com","@echots.onmicrosoft.com"


Set-DSTMailuser -Identity $User.Identity -ExternalEmailAddress $MicrosoftAddress

}


###

$echousers = Get-DSTMailUser | ?{$_.ExternalEmailAddress -match "echots"}



foreach ($user in $echousers) {

$user.primarySMTPAddress
$user.legacyexchangedn

}