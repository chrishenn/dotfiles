alias s := sync

cm:
    chezmoi init chrishenn -a --force \
    ; chezmoi update -a --force

sync message="sync":
    git commit -a -m "{{ message }}" || true && git pull && git push
    just cm
