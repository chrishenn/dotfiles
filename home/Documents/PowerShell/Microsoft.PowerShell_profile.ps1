$env:Path += ";$env:USERPROFILE\bin"
$env:Path += ";$env:USERPROFILE\AppData\Local\mise\shims"

iex (&starship init powershell)
iex (&{zoxide init powershell | out-string})
import-module "~\scoop\modules\Terminal-Icons"

function newrepo {
    gh alias set newrepo 'repo create --private --push --source .' --clobber

	git init
	git add --all
	git commit -m "init"
    if (-not (gh auth status)) {
        gh auth refresh
    }
	gh newrepo
}

function customLS {
    [alias('ls')]
    param(
        [parameter(Mandatory = $false)][string] $path = "."
    )
    eza -al $path
}
