set-alias cm chezmoi

function newrepo {
    gh alias set newrepo 'repo create --private --push --source .' --clobber

	git init
	git add --all
	git commit -m "init"
    if (-not (gh auth status)) {
        $(op read "op://homelab/github/credential") | gh auth login -h github.com --git-protocol=ssh --skip-ssh-key --with-token
    }
	gh newrepo
}

function customLS {
    [alias('ls')]
    param(
        [parameter(Mandatory = $false)][string] $path = "."
    )
    eza -aal $path
}
function customDC {
    [alias('dc')]
    param(
        [parameter(Mandatory = $false)][string] $cmd = ""
    )
    docker compose $cmd
}

iex (&starship init powershell)
iex (&{zoxide init powershell | out-string})

# either activate with mise activate or manually put shims on the path, but not both
# $env:Path += ";$env:USERPROFILE\AppData\Local\mise\shims"
if (gcm mise) {
    iex (mise activate pwsh | out-string)
}

$env:Path += ";$env:USERPROFILE\bin"
