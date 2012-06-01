# install this script by executing
#  iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/Scripts/master/devInstall.ps1'))
# 


# Install Chocolatey from chocolatey.org
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))

# add chocolatey to the path since v0.9.8.16 doesn't do it.
if(!(where.exe chocolatey)){ $env:Path += ';C:\Chocolatey\bin;' }

#Install all my favorite packages.
cinst all -source 'http://www.myget.org/F/6a72e3c34526424eacb4a37e8c21f809/'

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

