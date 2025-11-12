# bootstrap password manager and package managers before rendering chezmoi templates, which may use them

function gcm_app (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
    if (gcm $name -ea 0) {
        return $true
    }
    return $false
}

function bootstrap {
    if (-not (gcm_app scoop)) {
        iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
        scoop config aria2-warning-enabled false
        scoop update
    }
    scoop install -s 7zip git aria2 dark innounp
}

bootstrap
