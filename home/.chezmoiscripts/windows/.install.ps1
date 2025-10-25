# bootstrap password manager and package managers before rendering chezmoi templates, which may use them

function sys_app (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
    return (Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq "$name"} | measure).count -gt 0
}

function scoop_app (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
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

function installed (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$name
) {
    return (sys_app $name) -or (scoop_self -and (scoop_app $name -ea 0))
}

function install_1password {
    write-host "installing 1Password GUI"
    $url = "https://downloads.1password.com/win/1PasswordSetup-latest.msi"
    iwr $url -outfile "1pass.msi"
    start-process msiexec -argumentlist '/i 1pass.msi' -wait
    stop-process -name 1password
}

function install_1passwordcli {
    write-host "installing 1Password CLI"
    scoop install 1password-cli
}

function bootstrap {
    if (-not (scoop_self)) {
        iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
        scoop install git innounp dark aria2
        scoop config aria2-warning-enabled false
        scoop update
    }

    if (-not (installed "1password")) {
        install_1password

        if (-not (installed "1password")) {
            write-host "ERROR: 1password is not installed after attempted install"
        } else {
            write-host "SUCCESS: installed 1password"
        }
    }
    if (-not (installed "1password-cli")) {
        install_1passwordcli

        if (-not (installed "1password-cli")) {
            write-host "ERROR: 1password-cli is not installed after attempted install"
        } else {
            write-host "SUCCESS: installed 1password-cli"
        }
    }
}

bootstrap
