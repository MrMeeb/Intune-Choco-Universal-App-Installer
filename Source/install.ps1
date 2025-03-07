param(
    [Parameter(Mandatory)]
    [string]$Action,
    [Parameter(Mandatory)]
    [string]$AppName,
    [Parameter()]
    [string]$Params
 )
 
$LOGROOT="${env:ProgramFiles}\CAW\IntuneLogs\$AppName"

New-Item -ItemType Directory -Path "${env:ProgramFiles}\CAW\IntuneLogs" -Name $AppName -Force
Start-Transcript -path $LOGROOT\install.ps1.log -append

Write-Host "Action is $Action"
Write-Host "App is $AppName"

$NewAcl = Get-Acl -Path $LOGROOT
# Set properties
$identity = "BUILTIN\Users"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$newParams = @{
  TypeName     = 'System.Security.AccessControl.FileSystemAccessRule'
    ArgumentList = $fileSystemAccessRuleArgumentList
}
$fileSystemAccessRule = New-Object @newParams
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)

Set-Acl -Path $LOGROOT -AclObject $NewAcl

Invoke-Webrequest -uri https://raw.githubusercontent.com/MrMeeb/Intune-Choco-Universal-App-Installer/refs/heads/develop/Online/install.ps1 -outfile "$env:TMP\install-$AppName.ps1"

if ($Params.Length -gt 0) { 

  Powershell.exe -ExecutionPolicy ByPass -WindowStyle hidden -file "$env:TMP\install-$AppName.ps1" -Action install -AppName $AppName -Params "$Params"

} else {

  Powershell.exe -ExecutionPolicy ByPass -WindowStyle hidden -file "$env:TMP\install-$AppName.ps1" -Action install -AppName $AppName

}


Stop-Transcript