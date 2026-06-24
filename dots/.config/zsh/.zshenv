export EDITOR=nvim
export LESS='-R'

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.cargo/bin
export ZDOTDIR="$HOME/.config/zsh"
export PATH="$PATH:$HOME/.pub-cache/bin"

# export SSH_ASKPASS=/usr/bin/ksshaskpass
# export SSH_ASKPASS_REQUIRE=prefer

# nvm: use system or manual install if available
if [ -f /usr/share/nvm/init-nvm.sh ]; then
    source /usr/share/nvm/init-nvm.sh
elif [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

if [ -f /usr/share/vcpkg ]; then
  export VCPKG_ROOT=/usr/share/vcpkg
fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Android SDK
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
# export ANDROID_HOME=/opt/android-sdk
# export ANDROID_SDK_ROOT=$ANDROID_HOME
# export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"


export PATH=$PATH:/home/deo/.spicetify
