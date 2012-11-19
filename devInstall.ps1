# install this script by executing
#  iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/Scripts/master/devInstall.ps1'))
# 


# Install Chocolatey from chocolatey.org
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))

# add chocolatey to the path since v0.9.8.16 doesn't do it.
if(!(where.exe chocolatey)){ $env:Path += ';C:\Chocolatey\bin;' }

# get the pre version because it has some features not yet released.
chocolatey install chocolatey -pre

#Install all my favorite packages.
#cinst all -source 'http://www.myget.org/F/6a72e3c34526424eacb4a37e8c21f809/'

$chocolateyIds = '7zip
notepadplusplus
poshgit
fiddler
treesizefree
P4Merge
wincommandpaste
linqpad4
putty
SkyDrive
paint.net
git-credential-winstore
dotpeek
googlechrome
WindowsLiveWriter
boxstarter.helpers'

$chocolateyIds > ChocolateyInstallIds.txt
$path = get-item 'ChocolateyInstallIds.txt'
$notepad = [System.Diagnostics.Process]::Start( "notepad.exe", $path )
$notepad.WaitForExit()
cat $path | where { $_ } | %{ cinstm $_ }



if(!(where.exe git)){

	$gitPath = 'C:\Program Files\git\bin\git.exe'
	if(!(test-path $gitPath)){
		$gitPath = 'C:\Program Files (x86)\Git\bin\git.exe'
	}

	function git(){
		& $gitPath $args
	}
}

# setup local powershell profile.
function initProfile()
{
    $profileDir = (split-path $profile)
    if(! (test-path $profileDir))
    {
        mkdir $profileDir
    }

    pushd $profileDir

        if(test-path PsProfile)
        {
            pushd PsProfile
                try{
					git pull
                }
                catch{
                    $error
                }
            popd
        }
        else
        {
            git clone git://github.com/staxmanade/PsProfile.git
        }

        if(!(cat $profile | select-string 'PsProfile\\initProfile.ps1'))
        {
            "Adding initProfile to $Profile"
            ". `"$(split-path $profile)\PsProfile\initProfile.ps1`"" | Out-File $profile -append -encoding ASCII
        }
        . $profile
    popd
}

initProfile



Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

Install-ChocolateyPinnedTaskBarItem (Find-Program "Google\Chrome\Application\chrome.exe")

Install-ChocolateyFileAssociation ".txt" "$editorOfChoice"
Install-ChocolateyFileAssociation ".dll" "$env:ChocolateyInstall\bin\dotPeek.bat"
