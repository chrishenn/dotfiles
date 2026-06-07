set fallback

alias s := sync
alias f := fix
alias c := check

cm:
    chezmoi init chrishenn -a --force \
    ; chezmoi update -a --force

sync message="sync":
    git commit -a -m "{{ message }}" || true && git pull && git push
    just cm

ssync:
    fnox sync --provider age --config fnox.local.toml -f

check:
    hk check --all

fix:
    hk fix --all
