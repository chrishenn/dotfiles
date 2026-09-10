set fallback

alias f := fix
alias c := check
alias s := sync

check:
    hk check --all

fix:
    hk fix --all

sync message="sync":
    git commit -a -m "{{ message }}" || true && git pull && git push
