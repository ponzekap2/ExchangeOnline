
$FailedMailboxes = Get-DSTMigrationUser | ?{$_.status -match "failed"}

foreach ($Mailbox in $FailedMailboxes) {

if ($Mailbox.ErrorSummary -match "already has a primary mailbox") {

    Write-Host "Repairing Broken Mailbox"
    Remove-DSTMailbox -Identity $Mailbox.Identity -Confirm:$false

}


}