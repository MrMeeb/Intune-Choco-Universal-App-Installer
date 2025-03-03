param(
    [Parameter(Mandatory)]
    [string]$Action,
    [Parameter(Mandatory)]
	[string]$AppName,
	[Parameter()]
	[string]$Params
 )

# Set logging dir
#$LOGROOT="${env:ProgramFiles}\CAW\IntuneLogs\$AppName"

#Start-Transcript -path $LOGROOT\install.ps1.log -append

if ( $(whoami) -like "*system*" ) {

    Write-Host "Running as System"
	Write-Host "Using direct path to choco"
	$choco = "$env:ProgramData\CAW\choco\choco.exe"

} else {
	
	Write-Host "Running as User"
	Write-Host "Using direct path to choco"
	$choco = "$env:ProgramData\CAW\choco\choco.exe"

}

switch ($Action){
	"install" {
		try {
			if ($Params.Length -gt 0) {
				Write-Host "Installation params declared"
				&$choco install $AppName --yes -d -v --params `"$Params`"
			}
			else {
				Write-Host "$choco install $AppName --yes"
				&$choco install $AppName --yes -d -v
			}
		}
		catch {
			Write-Error -Message "Error happened during installation." -Category OperationStopped
			Write-Error $_
		}
	}
	"uninstall" {
		try {
			&$choco uninstall $AppName --yes
		}
		catch {
			Write-Error -Message "Error happened during uninstallation." -Category OperationStopped
		}
	}
}

#Stop-Transcript