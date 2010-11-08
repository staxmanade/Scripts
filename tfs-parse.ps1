
function startsWithIgnoreCase([string] $value, [string] $startsWith)
{
	$value.StartsWith($startsWith, [System.StringComparison]::OrdinalIgnoreCase)
}

function Assert-Arrays-Equal($actual, $expected)
{
	if(!$actual -and $expected)
	{
		"actual  : $actual"
		"expected: $expected"
		throw "Assert-Arrays-Equal - actual is null"
	}
	if(!$expected -and $actual)
	{
		"actual  : $actual"
		"expected: $expected"
		throw "Assert-Arrays-Equal - expected is null"
	}
	if(!$expected -and !$actual)
	{
	}
	else
	{
		$r = Compare-Object $actual $expected
		if($r)
		{
			"actual  : $actual"
			"expected: $expected"
			$r
			throw "Arrays not equal"
		}
	}
}

function Assert-Equal($actual, $expected, $message ='')
{
	if(!($actual -eq $expected))
	{
		"actual  : $actual"
		"expected: $expected"
		if($message)
		{
			throw $message
		}
		else
		{
			throw "expect not equal actual"
		}
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

function midChomp($items)
{
	$length = $items.Length-1
	if($length -eq 1)
	{
		$mid = 0
	}
	else
	{
		$mid = [int]($length / 2)
		if(($length / 2) -gt $mid)
		{
			$mid = ($mid + 1)
		}
	}
	write-host "$items"
	write-host "$length"
	write-host "$mid"
	$result = @{
		Index = $mid
		Left = $items | select -first ($mid)
		Right = $items | select -last ($length - $mid)
	}
	$result
}

$result = midChomp @(1,2)
Assert-Equal $result.Index 0
Assert-Arrays-Equal $result.Left @()
Assert-Arrays-Equal $result.Right @(2)

$result = midChomp @(1,2,3)
Assert-Equal $result.Index 1
Assert-Arrays-Equal $result.Left @(1)
Assert-Arrays-Equal $result.Right @(3)

$result = midChomp @(1,2,3,4,5,6,7,8,9)
Assert-Equal $result.Index 4
Assert-Arrays-Equal $result.Left @(1,2,3,4)
Assert-Arrays-Equal $result.Right @(6,7,8,9)

$result = midChomp @('a','b','c','d','e','f','g','h','i')
Assert-Equal $result.Index 4
Assert-Arrays-Equal $result.Left @('a','b','c','d')
Assert-Arrays-Equal $result.Right @('f','g','h','i')

$result = midChomp @('b')
Assert-Equal $result.Index 0
Assert-Arrays-Equal $result.Left @()
Assert-Arrays-Equal $result.Right @()

function chomp($items)
{
	if(!($items))
	{
		$items
		'DONE?'
		return;
	}
	$result = midChomp $items
	'*********** DEBUG'
	$result
	'*********** DEBUG'

	$itemX = $items[$result.Index]

	$doesThisHaveBug = read-host -prompt "Does [$itemX] have the bug?(Y/N/Q(quit))"

	if($doesThisHaveBug)
	{
		if((startsWithIgnoreCase $doesThisHaveBug 'q'))
		{
			write-host "done...(TODO: reset to TFS get-latest...)"
			return;
		}
		
		if(startsWithIgnoreCase $doesThisHaveBug 'n')
		{
		'right'
			chomp($result.Right)
		}
		elseif(startsWithIgnoreCase $doesThisHaveBug 'y')
		{
		'left'
			chomp($result.Left)
		}
		else
		{
			write-host "Unknown input [$doesThisHaveBug]";
		}
	}
}

chomp @('a','b','c','d','e','f','g','h','i')