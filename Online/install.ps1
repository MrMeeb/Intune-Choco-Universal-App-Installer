param(
    [Parameter(Mandatory)]
    [string]$Action,
    [Parameter(Mandatory)]
	[string]$AppName,
	[Parameter()]
	[string]$Params
 )

# Set logging dir
$LOGROOT="${env:ProgramFiles}\CAW\IntuneLogs\$AppName"

Start-Transcript -path $LOGROOT\install.ps1.log -append

if ( $(whoami) -like "*system*" ) {

    Write-Host "Running as System"

} else {
	
	Write-Host "Running as User"
	
}

if ($Params.Length -gt 0) {
	Write-Host "Installation params declared"
}

switch ($Action){
	"install" {
		try {
			choco install --yes $AppName --params $Params
		}
		catch {
			Write-Error -Message "Error happened during installation." -Category OperationStopped
		}
	}
	"uninstall" {
		try {
			choco uninstall --yes $AppName
		}
		catch {
			Write-Error -Message "Error happened during uninstallation." -Category OperationStopped
		}
	}
}

Stop-Transcript