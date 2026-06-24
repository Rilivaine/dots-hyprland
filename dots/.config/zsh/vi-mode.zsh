bindkey -v

# Backspace handling
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-kill-word
bindkey -M vicmd '^?' backward-delete-char
bindkey -M vicmd '^H' backward-kill-word

# Delete key
bindkey -M viins '^[[3~' delete-char
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3~' delete-char
bindkey -M vicmd '^[[3;5~' kill-word

export KEYTIMEOUT=1

WORDCHARS=''

# Cursor shapes
function zle-keymap-select {
  case $KEYMAP in
    vicmd)      echo -ne '\e[2 q' ;; # block
    viins|main) echo -ne '\e[6 q' ;; # beam
    *)          echo -ne '\e[2 q' ;; # fallback block
  esac
}

# Also set correct cursor on startup
function zle-line-init {
  zle -K viins
  echo -ne '\e[6 q'
}

zle -N zle-keymap-select
zle -N zle-line-init

# in vi insert mode, bind Enter (CR) to insert a newline + indent
bindkey -M viins $'\e\r' self-insert-unmeta

