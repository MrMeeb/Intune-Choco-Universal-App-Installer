# Set logging dir

param(
    [Parameter(Mandatory)]
    [string]$AppName
)

if ( $(whoami) -like "*system*" ) {

    Write-Host "Running as System"

} else {

    Write-Host "Running as User"

}

if ($AppName.length -lt 1){
    Write-host "AppName is not set"
    exit 1
}

$CheckInstalled = $(choco list $AppName)
if ($CheckInstalled -like "*$AppName*")
    { 
        Write-host "Found $AppName"
} else {
    whoami
    Write-host "$AppName not found"
    exit 1
}