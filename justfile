alias s := sync
sync message="sync":
    git commit -a -m "{{ message }}" || true && git pull && git push
    just cm