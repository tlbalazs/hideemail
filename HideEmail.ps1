# Author: LATOTH
# Hide or unhide email address in Global Address List
#
#
# Example: .\HideEmail.ps1 -Hide utest
# Switches: 
# -Hide and -Unhide 
#

param
(
    [Parameter(Mandatory=$false)][Switch]$Hide,
    [Parameter(Mandatory=$false)][Switch]$Unhide,
    [Parameter(ValueFromRemainingArguments=$true)] $args
)

$loginName = "";

if([string]::IsNullOrWhitespace($args[0])) 
{
    Write-Host "Missing input parameter!"
    Exit
}
else
{
    $loginName = $args[0];
}

if($Hide)
{
    Try
    {
        Get-ADUser $loginName -Properties MailNickName | Set-ADUser -Replace  @{MailNickName = $loginName}
        Get-ADUser $loginName -Properties MailNickName | Set-ADUser -Replace  @{msExchHideFromAddressLists = "TRUE"}
        Get-ADUser $loginName -Properties SamAccountName, MailNickName, msExchHideFromAddressLists | select SamAccountName, MailNickName, msExchHideFromAddressLists
        Write-Host "The email address has been hided!"
    }
    Catch [exception]
    {
        Write-Host "[Error] An error occured when changing attributes: $($_.Exception.Message)" 
    }
}

if($Unhide)
{
    Try
    {
        Get-ADUser $loginName -Properties MailNickName | Set-ADUser -Replace  @{msExchHideFromAddressLists = "FALSE"}
        Get-ADUser $loginName -Properties SamAccountName, MailNickName, msExchHideFromAddressLists | select SamAccountName, MailNickName, msExchHideFromAddressLists
        Write-Host "The email address has been unhided!"
    }
    Catch [exception]
    {
        Write-Host "[Error] An error occured when changing attributes: $($_.Exception.Message)" 
    }

}