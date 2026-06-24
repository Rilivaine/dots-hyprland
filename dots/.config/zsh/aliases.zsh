: ${EDITOR:=nvim}
alias e=$EDITOR
alias se="sudoedit"
alias yolkrc="e ~/.config/yolk/"
alias nvimrc="e ~/.config/nvim/"
alias zrc="e ~/.config/zsh/ ; exec zsh"
alias up="paru -Syu"
alias rns="paru -Rns"
alias dmg="sudo dmesg --color=always | less +G -R"
alias c="clear"
alias myip='echo "$(curl -s ifconfig.me)"'
alias cdconf='cd ~/.config/'
alias serve='pnpm dlx serve'
alias "?"="whence -f"
alias "??"="type -a"

# eza
alias ls='eza --icons --group-directories-first -F --hyperlink'
alias la='ls -a'              # show hidden
alias ll='ls -al'             # long + hidden
alias lt='ls --tree'          # tree view
alias lg='ls -l --git'        # git info

# fd
alias fd='fd --color=always'
alias fdf='fd --type f'         # files only
alias fdd='fd --type d'        # dirs only

alias mkdir='mkdir -p'
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

runbg() {
  if [ $# -eq 0 ]; then
    echo "Usage: runbg <command> [args...]"
    return 1
  fi
  "$@" > /dev/null 2>&1 & disown
}

# interactive fuzzy search; Enter puts command on the line for editing
hs() {
  local line cmd
  line=$(fc -ln 1 | fzf --tac --no-sort --height=80% --border --query="${1:-}") || return 1
  cmd=$(print -r -- "$line" | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//')
  print -z "$cmd"
}

# grep through history (non-interactive)
hg() {
  if (( $# == 0 )); then
    echo "Usage: hg <pattern>"
    return 1
  fi
  fc -l 1 | rg -i -- "$@"
}

# clear session + on-disk history
hc() {
  read -q "REPLY?Clear all shell history? [y/N] "
  echo
  [[ $REPLY != [yY] ]] && return 0
  history -c
  : >| "${HISTFILE:-$HOME/.histfile}"
  fc -W
  echo "History cleared."
}

###########
#   Git   #
###########

# General
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gap='git apply'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbrn='git branch -m' # rename branch

# interactive branch delete (gum)
gbx() { ~/.dotscripts/gbx.sh "$@"; }
alias gbl='git blame -b -w'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# Commit
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcam='git commit -a -m'
alias gcm='git commit -m'
alias gcs='git commit -S'

# Checkout & Switch
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'

# Diff
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'
alias gdtc='git difftool --cached'

# Log
alias gl='git log --oneline --decorate'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glp='git log --pretty=oneline --abbrev-commit'

# Stash
alias gst='git status'
alias gss='git status -s'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstc='git stash clear'
alias gsts='git stash show --text'

# Remote
alias gcl='git clone'
alias gcld='git clone --depth=1'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dfx'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gps='git push'
alias gpsf='git push --force-with-lease'
alias gpsu='git push -u origin HEAD'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gra='git remote add'
alias grd='git remote remove'
alias grls='git remote -v'
alias grrn='git remote rename'
alias grsu='git remote set-url'
alias grsh='git remote show'

# Merge & Rebase
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmt='git mergetool'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbs='git rebase --skip'

# Reset
alias gr='git reset'
alias grh='git reset HEAD'
alias grhh='git reset --hard'
alias grs='git reset --soft'
alias gpristine='git reset --hard && git clean -dfx'

# Tag
alias gts='git tag -s'
alias gtv='git tag | sort -V'

# Worktree
alias gwt='git worktree'
alias gwtl='git worktree list'
alias gwtp='git worktree prune'
alias gwtc='git worktree checkout'

# Submodules
alias gsu='git submodule update'
alias gsur='git submodule update --remote'
alias gsi='git submodule init'
alias gsa='git submodule add'

# Grep & Search
alias ggrep='git grep -n'
alias gfg='git ls-files | grep'

# Misc / Shortcuts
alias gcount='git shortlog -sn'
alias gundo='git reset HEAD~1 --mixed'
alias gunstage='git reset HEAD --'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias ghead='git rev-parse HEAD'
alias gbr='git branch --remote'
alias gtags='git tag -l'
alias gshow='git show'
alias gwhatchanged='git log -p --abbrev-commit --pretty=medium --raw --no-merges'

GBRA() {
  gbr --show-current 2>/dev/null
}

GREM() {
  g config --get branch.$(GIT_BRANCH).remote 2>/dev/null
}
