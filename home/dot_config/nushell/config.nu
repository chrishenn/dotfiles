$env.EDITOR = "nano"
$env.config.show_banner = false

# replacement for bash "watch"
def watch [cmd: string, interval: duration = 1sec] {
    loop {
        clear
        nu -c $cmd
        sleep $interval
    }
}

# k8s
alias k = kubectl
alias apply = kubectl apply -f
alias delete = kubectl delete -f
alias ka = kubeadm
alias pcat = python3 -m json.tool
alias ksys = kubectl -n kube-system
alias watch_svc = watch 'kubectl get svc --all-namespaces -o wide'
alias watch_pod = watch 'kubectl get pods --all-namespaces -o wide'

# use rust cli tools
alias ls = lsd -al
alias lse = eza -la
alias fd = fdfind
alias cat = batcat

source ~/.zoxide.nu
alias cd = z

# rustup cargo
source $"($nu.home-path)/.cargo/env.nu"

# github cli newrepo
def newrepo [] {
    ^git init
    ^git add --all
    ^git commit -m "init"
    try {gh auth status} catch {
        gh auth refresh
    }
    ^gh newrepo
}
