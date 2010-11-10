<#
	References...
	
	http://stackoverflow.com/questions/924679/c-how-can-i-check-if-a-url-exists-is-valid
	http://huddledmasses.org/using-script-functions-in-the-powershell-pipeline/
#>

 BEGIN {
}
PROCESS {
  ## You have to at least make sure it's got a value 
  ## Really you should check it's TYPE to make sure you can do something useful...
  if($_) {
	
	$url = $_;
	
	$urlIsValid = $false
	try
	{
		$request = [System.Net.WebRequest]::Create($url)
		$request.Method = 'HEAD'
		$response = $request.GetResponse()
		$urlIsValid = ($response.statusCode -eq 'OK')
	}
	catch
	{
		$urlIsValid = $false;
	}

	$x = new-object Object | `
			add-member -membertype NoteProperty -name IsValid -Value $urlIsvalid -PassThru | `
			add-member -membertype NoteProperty -name Url -Value $_ -PassThru
	$x 
  }
}
END {

}
