set-alias notepad 'C:\Program Files\Notepad++\notepad++.exe'

function loadCurrentFolderIntoExplorer
{
	Invoke-Item .
}
set-alias e loadCurrentFolderIntoExplorer

function Load-Assembly($assembly)
{
echo $assembly
	if(test-path $assembly)
	{
		$assemblyPath = get-item $assembly
		[System.Reflection.Assembly]::LoadFrom($assemblyPath)
	}
	else
	{
		[System.Reflection.Assembly]::LoadWithPartialName("$assembly")
	}
}



function invoke-psake-locally
{
	# Helper script for those who want to run psake without importing the module.
	# Example:
	# .\psake.ps1 "default.ps1" "BuildHelloWord" "4.0" 

	# Must match parameter definitions for psake.psm1/invoke-psake 
	# otherwise named parameter binding fails
	param(
	  [Parameter(Position=0,Mandatory=0)]
	  [string]$buildFile = 'default.ps1',
	  [Parameter(Position=1,Mandatory=0)]
	  [string[]]$taskList = @(),
	  [Parameter(Position=2,Mandatory=0)]
	  [string]$framework = '3.5',
	  [Parameter(Position=3,Mandatory=0)]
	  [switch]$docs = $false,
	  [Parameter(Position=4,Mandatory=0)]
	  [System.Collections.Hashtable]$parameters = @{},
	  [Parameter(Position=5, Mandatory=0)]
	  [System.Collections.Hashtable]$properties = @{}
	)

	try {
	  $psakeModulePath = (join-path ($pwd).Path psake.psm1)
	  
	  if(!(test-path $psakeModulePath))
	  {
		throw "Cannot find $psakeModulePath"
	  }
	  import-module $psakeModulePath
	  invoke-psake $buildFile $taskList $framework $docs $parameters $properties
	} finally {
	  remove-module psake -ea 'SilentlyContinue'
	}
}
set-alias ip invoke-psake-locally

function sha1()
{
	<#
		Thank you Brad Wilson
		http://bradwilson.typepad.com/blog/2010/03/calculating-sha1-in-powershell.html
	#>

	[Reflection.Assembly]::LoadWithPartialName("System.Security") | out-null
	$sha1 = new-Object System.Security.Cryptography.SHA1Managed

	$args | %{
		resolve-path $_ | %{
			write-host ([System.IO.Path]::GetFilename($_.Path))

			$file = [System.IO.File]::Open($_.Path, "open", "read")
			$sha1.ComputeHash($file) | %{
				write-host -nonewline $_.ToString("x2")
			}
			$file.Dispose()

			write-host
			write-host
		}
	}
}



function invoke-psake-locally
{
	# Helper script for those who want to run psake without importing the module.
	# Example:
	# .\psake.ps1 "default.ps1" "BuildHelloWord" "4.0" 

	# Must match parameter definitions for psake.psm1/invoke-psake 
	# otherwise named parameter binding fails
	param(
	  [Parameter(Position=0,Mandatory=0)]
	  [string]$buildFile = 'default.ps1',
	  [Parameter(Position=1,Mandatory=0)]
	  [string[]]$taskList = @(),
	  [Parameter(Position=2,Mandatory=0)]
	  [string]$framework = '4.0',
	  [Parameter(Position=3,Mandatory=0)]
	  [switch]$docs = $false,
	  [Parameter(Position=4,Mandatory=0)]
	  [System.Collections.Hashtable]$parameters = @{},
	  [Parameter(Position=5, Mandatory=0)]
	  [System.Collections.Hashtable]$properties = @{}
	)

	try {
	  $psakeModulePath = (join-path ($pwd).Path psake.psm1)
	  
	  if(!(test-path $psakeModulePath))
	  {
		throw "Cannot find $psakeModulePath"
	  }
	  import-module $psakeModulePath
	  invoke-psake $buildFile $taskList $framework $docs $parameters $properties
	} finally {
	  remove-module psake -ea 'SilentlyContinue'
	}
}
set-alias ip invoke-psake-locally





##
## Author   : Roman Kuzmin
## Synopsis : Resize console window/buffer using arrow keys
##
function Size($w, $h){ New-Object System.Management.Automation.Host.Size($w, $h) }
function resize() {
Write-Host '[Arrows] resize  [Esc] exit ...'
$ErrorActionPreference = 'SilentlyContinue'
for($ui = $Host.UI.RawUI;;) {
    $b = $ui.BufferSize
    $w = $ui.WindowSize
    switch($ui.ReadKey(6).VirtualKeyCode) {
        37 {
            $w = Size ($w.width - 1) $w.height
            $ui.WindowSize = $w
            $ui.BufferSize = Size $w.width $b.height
            break
        }
        39 {
            $w = Size ($w.width + 1) $w.height
            $ui.BufferSize = Size $w.width $b.height
            $ui.WindowSize = $w
            break
        }
        38 {
            $ui.WindowSize = Size $w.width ($w.height - 1)
            break
        }
        40 {
            $w = Size $w.width ($w.height + 1)
            if ($w.height -gt $b.height) {
                $ui.BufferSize = Size $b.width $w.height
            }
            $ui.WindowSize = $w
            break
        }
        27 {
            return
        }
    }
  }
}

function midnight() { (get-date).Subtract((get-date).TimeOfDay) }

<#
	// example usage of auto-updating powershell environment
	$dotSourcedCommonFileLocalPath = "$(Split-Path $PROFILE)\Microsoft.PowerShell_profile.common.ps1"
	. $dotSourcedCommonFileLocalPath
	if([Environment]::GetEnvironmentVariable("LastDownloadOfCommonProfile", "User") -lt ((get-date).Subtract((get-date).TimeOfDay)))
	{
		downloadCommonProfile
	}
#>
function downloadCommonProfile()
{
	$srcScriptHttpPath = 'http://github.com/staxmanade/Scripts/raw/master/Profile.common.ps1'
	$dotSourcedCommonFileLocalPath = "$(Split-Path $PROFILE)\Microsoft.PowerShell_profile.common.ps1"
	$clnt = new-object System.Net.WebClient
	echo "Downloading common profile script from - $srcScriptHttpPath"
	$clnt.DownloadFile($srcScriptHttpPath, "$dotSourcedCommonFileLocalPath")
	echo "Adding it to the local session (dot sourcing file - $dotSourcedCommonFileLocalPath)"
	. $dotSourcedCommonFileLocalPath

	[Environment]::SetEnvironmentVariable("LastDownloadOfCommonProfile", (midnight), "User")
}