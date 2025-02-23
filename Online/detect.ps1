# Set logging dir

param(
    [Parameter(Mandatory)]
    [string]$AppName
)

if ( $(whoami) -like "*system*" ) {

    Write-Host "Running as System"
	Write-Host "Using direct path to choco"
	$choco = "$env:ProgramData\CAW\choco\choco.exe"

} else {
	
	Write-Host "Running as User"
	$choco = choco

}

if ($AppName.length -lt 1){
    Write-host "AppName is not set"
    exit 1
}

$CheckInstalled = $(&$choco list $AppName)
if ($CheckInstalled -like "*$AppName*")
    { 
        Write-host "Found $AppName"
} else {
    whoami
    Write-host "$AppName not found"
    exit 1
}