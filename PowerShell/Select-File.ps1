<#
	Description: With the function call a filebrowser dialog appears, and
				 you can select one or multiple files. The return value is the file path.
	
	Parameter:	-Folder You can pick folder instead of files.
	
	Use example: $selectedFile   = select-file
	             $selectedFile   = sf
	             $selectedFolder = select-file -Folder
				 $selectedFolder = sf -Folder
				 $selectedFolder = sf -f				 				
	
	undergrinder 2018
#>
Function Select-File([Alias('f')][switch] $folder){		
		
		if(([appdomain]::currentdomain.getassemblies()|Where-Object{$_.FullName -like '*System.Windows.Forms*'}).count -eq 0){
			Add-Type -AssemblyName System.Windows.Forms
		}
		
		if($folder){
			$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
			$FolderBrowser.SelectedPath = (get-location)
			[void]$FolderBrowser.ShowDialog()
			return $FolderBrowser.SelectedPath		
		}else{				
			$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{Multiselect = $true; Filter = 'All Files|*.*'}		
			[void]$FileBrowser.ShowDialog()
			return $FileBrowser.filenames
		}
};

Function Select-Folder(){Select-File -folder};

new-alias sf   select-file;