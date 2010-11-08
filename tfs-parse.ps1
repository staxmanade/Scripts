
function startsWithIgnoreCase([string] $value, [string] $startsWith)
{
	$value.StartsWith($startsWith, [System.StringComparison]::OrdinalIgnoreCase)
}

function chomp($items)
{
	if(!$items)
	{
		echo "`$items is null"
		return;
	}
	if($items.length -eq 0)
	{
		echo "`$items is empty)"
		return;
	}
	
	$length = $items.length-1
	if($length -eq 2)
	{
		$mid = 1;
	}
	else
	{
		$mid = [int]($length / 2)
	}

	echo "items:$items"
	echo "mid item:$($items[$mid])"
	echo "mid:$mid"
	echo "length:$length"
	
	$itemMessage = "$($items[$mid])"
	$doesThisHaveBug = read-host -prompt "Does [$itemMessage] have the bug?(Y/N/Q(quit))"

	if( $doesThisHaveBug -and (startsWithIgnoreCase $doesThisHaveBug 'q'))
	{
		write-host "done...(TODO: reset to TFS get-latest...)"
		return;
	}
	
	
	if( $doesThisHaveBug -and (startsWithIgnoreCase $doesThisHaveBug 'n'))
	{
		$newItems = $items | select -last $mid
		chomp($newItems)
	}
	elseif($doesThisHaveBug -and (startsWithIgnoreCase $doesThisHaveBug 'y'))
	{
		$newItems = $items | select -first $mid
		chomp($newItems)
	}
	
}

function Assert-Arrays-Equal($actual, $expected)
{
	if(!$actual)
	{
		throw "Assert-Arrays-Equal - actual is null"
	}
	if(!$expected)
	{
		throw "Assert-Arrays-Equal - expected is null"
	}
	$r = Compare-Object $actual $expected
	if($r)
	{
		"actual  : $actual"
		"expected: $expected"
		$r
		throw "Arrays not equal"
	}
}

function Assert
{
	[CmdletBinding(
		SupportsShouldProcess=$False,
		SupportsTransactions=$False,
		ConfirmImpact="None",
		DefaultParameterSetName="")]
  param(
    [Parameter(Position=0,Mandatory=1)]$conditionToCheck,
    [Parameter(Position=1,Mandatory=1)]$failureMessage
  )
  if (!$conditionToCheck) { throw $failureMessage }
}

function chompX($items, $wichHalf)
{
	$length = $items.length
	$mid = [int]($length / 2)
	
	if(($length / 2) -gt $mid)
	{
		$mid = ($mid + 1)
	}

	if($wichHalf -eq 'first')
	{
		$items | select -first $mid
	}
	else
	{
		$items | select -last $mid
	}
}

$result = chompX @(1,2,3,4,5,6,7,8,9,10,11,12,13) 'first'; Assert-Arrays-Equal $result @(1,2,3,4,5,6,7)
$result = chompX @(1,2,3,4,5,6,7,8,9,10,11,12,13) 'last';  Assert-Arrays-Equal $result @(7,8,9,10,11,12,13)
$result = chompX @(1,2) 'first'; Assert-Arrays-Equal $result @(1)
$result = chompX @(1,2) 'last'; Assert-Arrays-Equal $result @(2)
$result = chompX @(1,2,3) 'first'; Assert-Arrays-Equal $result @(1,2)
$result = chompX @(1,2,3) 'last'; Assert-Arrays-Equal $result @(2,3)

$result = chompX @(1,2,3,4) 'first'; Assert-Arrays-Equal $result @(1,2)
$result = chompX @(1,2,3,4) 'last'; Assert-Arrays-Equal $result @(3,4)
