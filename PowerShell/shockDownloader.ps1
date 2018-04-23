<# SHOCKdownloader
   Download all CD review link-bandName-albumName from shockmagazin.hu 
   
   Example usage of Powershell's Invoke-Webrequest command and processing it's output
   
   undergrinder 2018#>
   
$urlCategory = @('0-9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
$link = 'http://www.shockmagazin.hu/component/abc/?view=alphabetical&task='

$cdItemArray = @()
foreach($urlParam in $urlCategory){
    $url = $link+$urlParam
    write-output 'url:'$url';start:'(get-date -f 'yyyy-MM-dd HH:mm:ss.fff')';'
	
	$webrequest = invoke-webrequest $url
	$urlList    = $webrequest.ParsedHtml.body.getElementsByTagName('li')|foreach{$_.innerhtml}
	$urlList    = $urlList|where-object{$_ -like '*/cd-kritika/*' -and $_ -notlike '*/cd-kritika/blog*' -and $_-notlike '*#comment*'}

	foreach($Item in $urlList){
	    $cdItem = new-object psobject 
		
	    $itemDict = $Item -replace '.*(href=")',''
		$itemDict = $itemDict.replace('</A>','')
		$itemDict = $itemDict.split('>')
		$cdItem|Add-Member -NotePropertyName url   -NotePropertyValue $itemDict[0]
		$cdItem|Add-Member -NotePropertyName band  -NotePropertyValue ($itemDict[1]).split(':')[0]
		$cdItem|Add-Member -NotePropertyName album -NotePropertyValue ($itemDict[1]).split(':')[1]	
		$cdItemArray = $cdItemArray + $cdItem
	}
};

$cdItemArray|export-csv shockmagazin.csv -delimiter ';'

write-output 'End of Process:'(get-date -f 'yyyy-MM-dd HH:mm:ss.fff')';'