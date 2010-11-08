. .\AssertHelpers.ps1

function startsWithIgnoreCase([string] $value, [string] $startsWith)
{
	$value.StartsWith($startsWith, [System.StringComparison]::OrdinalIgnoreCase)
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
<# TESTS

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
#>

function chomp($items)
{
	if(!($items))
	{
		'DONE'
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
			chomp($result.Right)
		}
		elseif(startsWithIgnoreCase $doesThisHaveBug 'y')
		{
			chomp($result.Left)
		}
		else
		{
			write-host "Unknown input [$doesThisHaveBug]";
		}
	}
}

chomp @('a','b','c','d','e','f','g','h','i')