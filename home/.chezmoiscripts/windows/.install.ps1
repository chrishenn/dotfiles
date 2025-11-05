# bootstrap password manager and package managers before rendering chezmoi templates, which may use them

function sys_app (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
    return (Get-ciminstance Win32_Product | Where-Object {$_.Name -match "$name"} | measure).count -gt 0
}

function scoop_self {
    try {
        if (gcm scoop -ea 0) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

function scoop_self_install {
    if (-not (scoop_self)) {
        iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    }
}

function scoop_app (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
    if (-not (scoop_self)) {
        return $false
    }
    return ((scoop export | ConvertFrom-Json).apps | where-object {$_.name -eq "$name"} | measure).count -gt 0
}

function scoop_bucket (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
    # add bucket if not present
    $bs = (scoop export | ConvertFrom-Json).buckets
    $inst = ($bs | where-object {$_.name -eq "$name"} | measure).count -gt 0
    if (-not $inst) {
        try {
            scoop bucket add $name
        } catch {
            write-host "error while adding bucket $name"
        }
    }
}

function installed (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
    # note: scoop_app matches name exactly (case-insensitive); sys_app matches on "real app name contains $name"
    return (sys_app $name) -or (scoop_app $name)
}

function bootstrap {
    if (-not (scoop_self)) {
        iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
        scoop install git innounp dark aria2 refreshenv mise
        scoop config aria2-warning-enabled false
        scoop update
    }
    refreshenv

    # the scoop 1password-cli package is broken
    mise use -g 1password-cli
    refreshenv
}

bootstrap
