set-alias cm chezmoi

function ghlogin {
    if (-not (gh auth status *> $null)) {
        echo $(op read "op://homelab/github/credential") | gh auth login -h github.com -p ssh --skip-ssh-key --with-token
    }
}
function glablogin {
    if (-not (glab auth status *> $null)) {
        glab auth login --hostname $GITLAB -g ssh -a $GITLAB -p https --token $(op read "op://homelab/Gitlab/pat")
    }
}
function newrepo {
    git init
    git add --all
    git commit -m "init"
    ghlogin
    gh newrepo
}
function newrepog {
    git init
    git add --all
    git commit -m "init"
    glablogin
    glab newrepo
    git push --set-upstream origin --all
    git push --set-upstream origin --tags
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
if (gcm mise -ea 0) {
    # either activate with mise activate or manually put shims on the path, but not both
    # $env:Path += ";$env:USERPROFILE\AppData\Local\mise\shims"
    iex (mise activate pwsh | out-string)
}
if (gcm starship -ea 0) {
    iex (&starship init powershell)
}
if (gcm zoxide -ea 0) {
    iex (&{zoxide init powershell | out-string})
}
