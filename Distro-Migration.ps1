$group = ""
$CSVExport = ".\ExportedGroups"




#Grabs Old Distro Info
$oldDistro = get-distributiongroup $group
$oldDistroName = $oldDistro.name
$oldDistroDisplay = [string]$oldDistro.displayname
$oldDistroAlias = [string]$oldDistro.Alias
$oldDistroSMTP = [string]$oldDistro.primarysmtpaddress
$oldDistroMember = (Get-DistributionGroupMember $oldDistroName).name

#creating new Distro Group
Write-Host "Creating New group for $oldDistroName"
New-distributiongroup `
	-Name "Online-$oldDistroName" `
	-Alias "Online-$oldDistroAlias" `
	-DisplayName "Online-$oldDistroDisplay" `
	-Members $oldDistroMember `
	-PrimarySMTPAddress "Online-$oldDistroSMTP" 

#creating Path for groups
        If(!(Test-Path -Path $CSVExport )){
            Write-Host "Creating Directory: $CSVExport"
            New-Item -ItemType directory -Path $CSVExport
        }
 Write-Host "Creating Directory: $CSVExport"
 

#writing groups to .csv
"EmailAddress" > "$CSVExport\$group.csv"
$oldDistro.EmailAddresses >> "$CSVExport\$group.csv"
"x500:"+$oldDistro.LegacyExchangeDN >> "$CSVExport\$group.csv"


#setting parameter for New Online Distro

Set-DistributionGroup `
            -Identity "Online-$oldDistroName" `
            -AcceptMessagesOnlyFromSendersOrMembers $oldDistro.AcceptMessagesOnlyFromSendersOrMembers `
            -RejectMessagesFromSendersOrMembers $oldDistro.RejectMessagesFromSendersOrMembers `

Set-DistributionGroup `
    -Identity "Online-$oldDistroName" `
    -AcceptMessagesOnlyFrom $oldDistro.AcceptMessagesOnlyFrom `
    -AcceptMessagesOnlyFromDLMembers $oldDistro.AcceptMessagesOnlyFromDLMembers `
    -BypassModerationFromSendersOrMembers $oldDistro.BypassModerationFromSendersOrMembers `
    -BypassNestedModerationEnabled $oldDistro.BypassNestedModerationEnabled `
    -CustomAttribute1 $oldDistro.CustomAttribute1 `
    -CustomAttribute2 $oldDistro.CustomAttribute2 `
    -CustomAttribute3 $oldDistro.CustomAttribute3 `
    -CustomAttribute4 $oldDistro.CustomAttribute4 `
    -CustomAttribute5 $oldDistro.CustomAttribute5 `
    -CustomAttribute6 $oldDistro.CustomAttribute6 `
    -CustomAttribute7 $oldDistro.CustomAttribute7 `
    -CustomAttribute8 $oldDistro.CustomAttribute8 `
    -CustomAttribute9 $oldDistro.CustomAttribute9 `
    -CustomAttribute10 $oldDistro.CustomAttribute10 `
    -CustomAttribute11 $oldDistro.CustomAttribute11 `
    -CustomAttribute12 $oldDistro.CustomAttribute12 `
    -CustomAttribute13 $oldDistro.CustomAttribute13 `
    -CustomAttribute14 $oldDistro.CustomAttribute14 `
    -CustomAttribute15 $oldDistro.CustomAttribute15 `
    -ExtensionCustomAttribute1 $oldDistro.ExtensionCustomAttribute1 `
    -ExtensionCustomAttribute2 $oldDistro.ExtensionCustomAttribute2 `
    -ExtensionCustomAttribute3 $oldDistro.ExtensionCustomAttribute3 `
    -ExtensionCustomAttribute4 $oldDistro.ExtensionCustomAttribute4 `
    -ExtensionCustomAttribute5 $oldDistro.ExtensionCustomAttribute5 `
    -GrantSendOnBehalfTo $oldDistro.GrantSendOnBehalfTo `
    -HiddenFromAddressListsEnabled $True `
    -MailTip $oldDistro.MailTip `
    -MailTipTranslations $oldDistro.MailTipTranslations `
    -MemberDepartRestriction $oldDistro.MemberDepartRestriction `
    -MemberJoinRestriction $oldDistro.MemberJoinRestriction `
    -ModeratedBy $oldDistro.ModeratedBy `
    -ModerationEnabled $oldDistro.ModerationEnabled `
    -RejectMessagesFrom $oldDistro.RejectMessagesFrom `
    -RejectMessagesFromDLMembers $oldDistro.RejectMessagesFromDLMembers `
    -ReportToManagerEnabled $oldDistro.ReportToManagerEnabled `
    -ReportToOriginatorEnabled $oldDistro.ReportToOriginatorEnabled `
    -RequireSenderAuthenticationEnabled $oldDistro.RequireSenderAuthenticationEnabled `
    -SendModerationNotifications $oldDistro.SendModerationNotifications `
    -SendOofMessageToOriginatorEnabled $oldDistro.SendOofMessageToOriginatorEnabled `
    -BypassSecurityGroupManagerCheck
