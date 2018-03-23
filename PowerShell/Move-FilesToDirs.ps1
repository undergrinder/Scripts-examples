<#
	Description : With this function you can move files into serial number named directory based on the threshold value in megabyte.
	Example     : Move-FilesToDirs 10 -> lets say we have 50mb txt files in a directory, this command split the files into 1, 2, 3... named directory
	              and every directory's size will be approximately 10mb.	              
				  
    undergrinder 2018				  
#>

Function Move-FilesToDirs([int]$threshold){

	if (($threshold -eq $null) -or ($threshold -eq 0)) {
		Write-Host "The threshold parameter is empty or zero"  -foregroundcolor "red"
		Write-Host "Execution aborted"                         -foregroundcolor "red"
		EXIT}
	
	$i            = 1
	$sum_mb       = 0
	$location     = (get-location).tostring()
	
	$files = get-childitem $location| select-object name, @{Name="size_mb"; Expression={$_.Length / 1mb}}
	
	foreach ($file in $files)
	{
		if ( -not (Test-path $location"\"$i)) {New-item $i -type directory}
		
		Move-item $file.name $location"\"$i
		
		$sum_mb = $sum_mb + $file.size_mb
			
		if ($sum_mb -gt $threshold) {
			$i = $i + 1
			$sum_mb = 0}       
	}
}