$env:Path += ";$env:USERPROFILE\bin"
$env:Path += ";$env:USERPROFILE\AppData\Local\mise\shims"

iex (&starship init powershell)
iex (&{zoxide init powershell | out-string})
import-module "~\scoop\modules\Terminal-Icons"

function newrepo {
	git init
	git add --all
	git commit -m "init"
	gh auth login
	gh newrepo
}

function customLS {
    [alias('ls')]
    param(
        [parameter(Mandatory = $false)][string] $path = "."
    )
    eza -al $path
}
