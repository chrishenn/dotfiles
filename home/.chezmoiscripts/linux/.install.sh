#!/bin/bash

# bootstrap password manager and package managers before rendering chezmoi templates, which may use them

# todo: switch on server vs desktop here to select 1password gui+cli or just cli
# todo: install package managers only if missing
# todo: reboot required after flatpak install, before we can use flatpak?

function bootstrap {
    # 1password gui + cli (desktop only)
    echo "1password: installing"
    [[ ! $(dpkg -s 1password-cli) ]] &&
        curl -L https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb -o 1pass.deb &&
        sudo apt install -y ./1pass.deb &&
        sudo apt update &&
        sudo apt install -y 1password-cli &&
        rm 1pass.deb
    echo "1password: installed"

    # package managers
    echo "package managers: installing"
    #/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    #curl https://mise.run | sh
    #sudo apt install -y flatpak
    echo "package managers: installed"
}
bootstrap || exit 0
