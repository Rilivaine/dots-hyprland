stty susp undef
bindkey '^Z' undo
bindkey '^[z' redo

bindkey '^[[5~' up-line-or-search     # Page Up: search backward in history
bindkey '^[[6~' down-line-or-search   # Page Down: search forward in history
bindkey -M vicmd '?' history-incremental-search-backward
bindkey "^[m" copy-earlier-word
bindkey "^[." insert-last-word

# Move by words with Ctrl+Left / Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left
bindkey '^[[1;5C' forward-word    # Ctrl+Right

# Home / End to start/end of line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

autoload -Uz edit-command-line
zle -N edit-command-line
  bindkey '^e' edit-command-line

bindkey '^ ' magic-space
