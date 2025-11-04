# dotfiles

### basic usage

note: These dotfile templates read from my 1password vault to render my ssh keys. You'll need to adapt them
note: Macos not supported

```bash
# linux: install, init, pull, and apply
sh -c "$(curl -fsLS get.chezmoi.io)" -- init chrishenn --apply

# windows: install, init, pull, and apply
iex "&{$(irm 'https://get.chezmoi.io/ps1')}"; & ~\bin\chezmoi init chrishenn --apply

# windows: bootstrap from pixi
irm -useb https://pixi.sh/install.ps1 | iex
refreshenv
pixi use -g mise

# pull new changes from github, apply, overwrite any local dotfile changes
chezmoi update --apply --force

# clear chezmoi dotfiles, cache
chezmoi purge
```

### dev

since this is a public repo, pre-commit checks are mostly to avoid committing secrets

```bash
# lint fix
hk fix
hk fix --from-ref main
hk fix --all

# check/lint
hk check
hk check --from-ref main
hk check --all

# install hooks defined in hk.pkl into .git/hooks
hk install
hk uninstall

# run the pre-commit hook
hk run pre-commit
```

### ref

https://github.com/twpayne/dotfiles/

### notes

- you will need to shell into the target machine and manually apply these dotfiles, at least on linux, because the
  apt install commands require interactive sudo elevation - not ideal
  - would ansible be better suited to installing the packages step?
  - chezmoi depends on apt packages (1password); so after installing them, ansible could invoke chezmoi
  - if pkg managers are booted with ansible, we can use chezmoi from mise package
- todo: switch on desktop vs server in chezmoi.toml
  - server
    - install only 1password-cli
    - embed OP_SERVICE_ACCOUNT_TOKEN
