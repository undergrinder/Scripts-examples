#Powershell profile template

<#
 This template offer you:
	o  Session object, with your predefined values
	o  Custom module loading, and listing it with $tg.loaded_modules, listing the commands in it: $tg.commands
	o  Log the session 
	o  Feel free to customize, $tg is my monogram, change the object name to yours.

 Steps:
	o  Create the following file file C:\Users\undergrinder\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
	o  Set the ExecutionPolicy at least ByPass -> Set-ExecutionPolicy bypass ,the administrator privilege may be required. you can add the scope with -Scope switch etc.
	o  You can customize this snippet and insert into your profile, or
	o  Save the file and the profile script just dot source it:
			e:\undergrinder\powershell\profile.ps1
    o  When you need start powershell without the profile run the program with the -noprofile switch
			powershell.exe -noprofile
	o  When you don't have the privilege to change the execution policy try this:
			powershell  -noexit -executionpolicy ByPass -file profile-template.ps1
			REM add -noprofile parameter if you like to disable the adjusted profile script
	o  Save the above snippet as batch file for example pshell.bat, and add it's location to your PATH environment variable 
#>
Write-Host 'Hey undergrinder!' `n -foregroundcolor darkgreen

### My Object ####
# Feel free to expand it, or rename the object
$tg = new-object psobject -property  @{home          = "e:\undergrinder\home";
                                      desktop        = "c:\Users\undergrinder\Desktop";					  
									  fav1           = "e:\myFavouriteDirectory1\";
									  fav2           = "e:\myFavouriteDirectory2\";
                                      modules        = "e:\undergrinder\powershell\modules\";									  
									  scripts        = "e:\myFrequentlyUsedScripts\";
		                              bmode          = if([environment]::Is64BitProcess){64} else {32};
                                      startloc       = (Get-Location);
                                      transcripts    = "e:\undergrinder\powershell\transcripts\";}

#The sessionlog variable hold the transcript file's location+name + Add to the 
$sessionlog = $($tg.transcript+$env:userdomain+'-'+$env:username+'-'+(get-date -f 'yyyyMMddHHmmss')+'.log')
$tg|Add-Member -NotePropertyName current_transcript -NotePropertyValue $sessionlog
				
				
Write-host -foregroundcolor 'gray' 'o Session object''s ($tg) elements':
$tg|format-list

### Load modules ###
<#If you want modules load every time, but don't want to install the module, this block is your friend.
   
   o Create a module directory, and assign the path to the $tg.modules
   o Edit the modules .psm1 file, add the next line to the top of the code:
   
		param([parameter(Position=0,Mandatory=$true)]$ScriptRoot)
		
   o The -ArgumentList switch set the $scriptroot variable inside the module#>

# $tg|Add-Member -NotePropertyName loaded_modules -NotePropertyValue @()

# import-module (join-path $tg.modules module-subdir1\module1.psm1) -ArgumentList (join-path $tg.modules module-subdir1) 
# $tg.loaded_modules += 'module1'

# import-module (join-path $tg.modules module-subdir2\module2.psm1) -ArgumentList (join-path $tg.modules module-subdir2) 
# $tg.loaded_modules += 'module2'

# Write-host -foregroundcolor 'gray' 'o Loaded modules':
# $tg.loaded_modules|format-list

## My Object + Functions ###
# $commands = get-command|where-object{$_.source -in $tg.loaded_modules}
# $tg|Add-Member -NotePropertyName commands -NotePropertyValue $commands

Write-host `n'Good Work!' -foregroundcolor darkgreen	

### My Aliases ###
#new-alias [alias name] [command name]
new-alias gep get-executionpolicy

#LOG
Start-Transcript $sessionlog|out-null