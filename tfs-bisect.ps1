param( $pathToSrc )


function getFullChangeList($path, $knownGoodVersion)
{
	if($knownGoodVersion)
	{
		tf hist $path  /noprompt /recursive /stopafter:$knownGoodVersion
	}
	else
	{
		tf hist $path  /noprompt /recursive
	}
}

#tf get src/* /version:C6721 /force /recursive


function GetChangeSetRange($knownGoodChangeset)
{
	$allChanges = getFullChangeList 
	$i = 0
	do {
		$curr = $allChanges[$i]
		$allChanges[$i]
		$i++
	} while ($curr -ne $knownGoodChangeset)
}


$pathToSrc = get-item $pathToSrc
write-host "Src Path: $pathToSrc"

$changeListOutput = getFullChangeList "$pathToSrc\*"

$historyRows = @()

<#
example tf history command

Changeset User          Date       Comment
--------- ------------- ---------- ------------------------------------------------------------------------------------
5413      UserName      6/11/2010  some comment here
#>
$changeListOutput | select -skip 2 | %{
	$row = @{
		Version = [int]$_.Substring(0, 10)
		User = $_.Substring(10, 13)
		Date = [DateTime]$_.Substring(23, 10)
		Comment = $_.Substring(23)
	}
	$historyRows += new-object PSObject -Property $row
}

$historyRows
