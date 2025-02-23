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

$InstallParams = ""

if ( $(whoami) -like "*system*" ) {

    Write-Host "Running as System"
	Write-Host "Using direct path to choco"
	$choco = "$env:ProgramData\CAW\choco\choco.exe"

} else {
	
	Write-Host "Running as User"
	
}

if ($Params.Length -gt 0) {
	Write-Host "Installation params declared"
	$InstallParams = "--params `"$Params`""
}

switch ($Action){
	"install" {
		try {
			&$choco install --yes $AppName $InstallParams
		}
		catch {
			Write-Error -Message "Error happened during installation." -Category OperationStopped
			Write-Error $_
		}
	}
	"uninstall" {
		try {
			&$choco uninstall --yes $AppName
		}
		catch {
			Write-Error -Message "Error happened during uninstallation." -Category OperationStopped
		}
	}
}

Stop-Transcript