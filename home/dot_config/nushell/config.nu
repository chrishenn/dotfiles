# aliases
alias j='just'
alias p='pixi'
alias m='mise'
alias k='kubectl'
alias cm='chezmoi'

alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'

alias ls='eza -aalo'
alias l='eza -aalo'
alias ll='eza -aalFo'
alias la='eza -Aao'

alias ka='kubeadm'
alias ksys='kubectl -n kube-system'
alias kcal='kubectl -n calico-system'

alias kf='kubectl apply -f'
alias kd='kubectl delete -f'

alias pcat='python3 -m json.tool'

alias get_svc='kubectl get svc -A -o wide'
alias get_pod='kubectl get pods -A -o wide'
alias get_node='kubectl get nodes -A -o wide'

alias watch_svc='watch -n 1 kubectl get svc -A -o wide'
alias watch_pod='watch -n 1 kubectl get pods -A -o wide'
alias watch_node='watch -n 1 kubectl get nodes -o wide'

alias dc='docker compose'
alias dlogs='docker compose logs'

alias t='talosctl'
alias pup='pulumi up -y'

# settings
$env.EDITOR = 'nano'
$env.config.buffer_editor = 'nano'
$env.config.show_banner = false

# functions
def watch [cmd: string, interval: duration = 1sec] {
    loop {
        clear
        nu -c $cmd
        sleep $interval
    }
}

def newrepo [] {
    ^git init
    ^git add --all
    ^git commit -m "init"
    try {gh auth status} catch {
        gh auth refresh
    }
    ^gh newrepo
}

# tool init
use std/util "path add"

if ('~/.zoxide.nu' | path exists) { source '~/.zoxide.nu' }
if ('~/.cargo/bin' | path exists) { path add '~/.cargo/bin' }

if (which starship | is-not-empty) { starship init nushell }
