alias s := sync

sync message="sync":
    git commit -a -m "{{ message }}" || true && git pull && git push
    just cm

cm:
    $(op read op://homelab/svc/bash) \
    ; chezmoi init chrishenn -a --force \
    ; chezmoi update -a --force