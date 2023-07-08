param (
	[string]$function
)

switch ($function) {
	"test" {
		Write-Host "test"
		Pause
		exit
	}
	"" {
		Write-Host "No function specified. Exiting..."
		Pause
		exit
	} else {
		Write-Host "Invalid function specified. Exiting..."
		Pause
		exit
	}
}
		