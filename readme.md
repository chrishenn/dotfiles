# dotfiles

### basic usage

note: These dotfile templates read from my 1password vault to render my ssh keys. You'll need to adapt them
note: Macos not supported

```bash
# linux: install, init, pull, and apply
OP_SERVICE_ACCOUNT_TOKEN=<token> \
GH_TOKEN=<token> \
sh -c "$(curl -fsLS get.chezmoi.io)" -- init chrishenn --apply --git-lfs

# pull new changes from github, apply, overwrite any local dotfile changes
chezmoi update --apply --force

# clear chezmoi dotfiles, cache
chezmoi purge
```

The initial aspiration was to install a secrets manager (1password) before rendering further templates, ie running
an installer script on hooks.read-source-state.pre. However, the `op` binary does not propagate onto the path of the
enclosing shell - meaning that chezmoi can't find it to render templates, after installing it.

So, instead I'll just make sure `op` is in the parent shell and on the path:

```powershell
scoop install mise vcredist2022
mise use -g chezmoi op
$env:Path += ";$env:USERPROFILE\AppData\Local\mise\shims"
$env:OP_SERVICE_ACCOUNT_TOKEN = ''
chezmoi init chrishenn --apply --force
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

# gitleaks create baseline
gitleaks git -r ds.json
# gitleaks compare to baseline
gitleaks git -b ds.json
```

### ref

https://github.com/twpayne/dotfiles/

### notes

- you will need to shell into the target machine and manually apply these dotfiles, at least on linux, because the
  apt install commands require interactive sudo elevation - not ideal
    - would ansible be better suited to installing the packages step?
    - chezmoi depends on apt packages (1password); so after installing them, ansible could invoke chezmoi
    - if pkg managers are booted with ansible, we can use chezmoi from mise package
