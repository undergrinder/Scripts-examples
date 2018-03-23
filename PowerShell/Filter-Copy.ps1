<#
	Description:  This script searchs in files content based on the given pattern, if matched then copy or moved in the given directory
	
	Instructions: o Run the script with dot sourcing 
					  . .\filtercopy.ps1
				  o Then call the function with type in filter-copy, then Enter
				  o The script prompts for parameters
						* File pattern : filter for files                      e.g.: *.txt                                           (without quotes)
						* Pattern      : filter for content (regex expression) e.g.: ^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$ (without quotes)
						* Copy/Move    : 1 - the files, that are matched with the pattern will be copied to the output directory
						                 2 - the files, that are matched with the pattern will be moved  to the output directory
									     If the parameter is leaved blank, the default value is 1 (Copy)
						* Destination
						  directory    : The name of the directory, where the files that are found should be copied/moved.
										 If the parameter is leaved blank, the default value is FilterCopyResults.                  									   				  
										 
	Examples:  1. File pattern    : *.txt
	              Pattern         : (http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?
				  Copy/Move       : 2
				  Destination dir : 
				  
				  Results      : All txt file in a specific directory, that contains a valid URL, will be moved to FilterCopyResults directory
				  
			   2. File pattern    : *.txt
	              Pattern         : ^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$
				  Copy/Move       : 1
				  Destination dir : emails
				  
				  Results      : All txt file in a specific directory, that contains a valid email address per row, will be copiedd to emails directory		
    
	undergrinder 2018
#>
Function Filter-Copy(){
	$file_pattern    = read-host -prompt 'File pattern'
	
	$files = get-childitem $file_pattern
	write-host $files.count, ' matched [',$file_pattern,']',`n
	
	if($files.count -eq 0){exit}
	
	$pattern         = read-host -prompt 'Pattern' #regex
	$copy_move       = read-host -prompt 'Copy - 1; Move - 2'
	$destination_dir = read-host -prompt 'Destination directory'
	
	if($copy_move -notin (1,2)){$copy_move = 1}
	if(!$destination_dir){$destination_dir = 'FilterCopyResults'}
	
	$h_files_content = @{}
	
	
	foreach($file in $files) {
		$h_files_content.add($file.name,(get-content $file.name))
	}
	
	$out_files = $h_files_content.getenumerator()|where-object{$_.value -match $pattern} #If you like you can change the match operator to -like operator, so the regex search will be replaced by wildcard search
	
	if(-not(test-path .\$($destination_dir))){
		new-item $destination_dir -type directory|out-null
	}
	
	switch($copy_move){
		1 {		
			foreach($file in $out_files.name){copy-item $file .\$($destination_dir)}
			write-host  `n, $out_files.count,' files have been copied to ', $destination_dir,' directory' -foregroundcolor 'darkgreen' 
		  }	
		2 {
			foreach($file in $out_files.name){move-item $file .\$($destination_dir)}
			write-host  $out_files.count,' files have been moved to ', $destination_dir,' directory' -foregroundcolor 'darkgreen' 
		  }	
	}
	
	if($out_files.count -eq 0){remove-item -path .\$($destination_dir)}
};