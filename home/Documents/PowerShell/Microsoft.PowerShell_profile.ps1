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

if (gcm starship) {
    iex (&starship init powershell)
}
if (gcm zoxide) {
    iex (&{zoxide init powershell | out-string})
}
if (gcm mise) {
    # either activate with mise activate or manually put shims on the path, but not both
    # $env:Path += ";$env:USERPROFILE\AppData\Local\mise\shims"
    iex (mise activate pwsh | out-string)
}
