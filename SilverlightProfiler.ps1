param([string]$urlPath)

<#

 Read the following blog for furthur information
 http://blogs.msdn.com/profiler/archive/2010/04/26/vs2010-silverlight-4-profiling.aspx

 This script was written to make profiling silverlight applications a little easier.
 1. Run a powershell console as admin
 2. Execute the script specifing the $urlPath parameter
 4. When done profiling press enter to stop the session and create the profiling report.
 5. The script will print the path to the profiling session report. (You can then view it in Visual Studio)
#>

#detect that we're running as adminsitrator (required for performance tooling)
# http://www.leastprivilege.com/AdminTitleBarForPowerShell.aspx
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$p = New-Object System.Security.Principal.WindowsPrincipal($id)
if(!($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)))
{
	write-host -ForegroundColor Red "You have to run this as administrator"
	return
}


$env:Path = $env:Path + ";C:\Program Files\Microsoft Visual Studio 8\Team Tools\Performance Tools"
$env:SAMPLE_GUID='{F1216318-0905-4fe8-B2E8-105CEB7CD689}'
$env:SAMPLING=1
$env:COR_ENABLE_PROFILING=1
$env:COR_PROFILER=$env:SAMPLE_GUID
$env:COR_LINE_PROFILING=1
$env:COR_INTERACTION_PROFILING=0
$env:COR_GC_PROFILING=0
$env:CORECLR_ENABLE_PROFILING=$env:COR_ENABLE_PROFILING
$env:CORECLR_PROFILER=$env:COR_PROFILER

$vsPerfCLREnv = "c:\Program Files\Microsoft Visual Studio 10.0\Team Tools\Performance Tools\VSPerfCLREnv.cmd"
$VSPerfCmd = "c:\Program Files\Microsoft Visual Studio 10.0\Team Tools\Performance Tools\VSPerfCmd.exe"

$outFilePath = [System.IO.Path]::GetRandomFileName()

& $VSPerfCmd /start:sample /output:$outFilePath /launch:"c:\Program Files\Internet Explorer\iexplore.exe" /args:$urlPath

Read-Host -Prompt "Press any key to stop the profiler..."

& $VSPerfCmd /detach
& $VSPerfCmd /shutdown
& $VSPerfClrEnv /off

$f = get-item "$outFilePath*"
write-host -ForegroundColor Green "Wrote performance report to:"
write-host -ForegroundColor Green "  $f"
