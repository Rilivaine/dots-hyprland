setopt AUTO_CD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt CORRECT
setopt INTERACTIVE_COMMENTS

# history tweaks
HISTFILE=$HOME/.local/state/zsh/history
mkdir -p ${HISTFILE:h}
HISTSIZE=10000
SAVEHIST=10000
HISTORY_IGNORE="(ps *|WSL=*|SSH=*|source /usr/share/cursor/*)"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
setopt SHARE_HISTORY
