# ~/.config/zsh/.zshrc

fpath=(~/.config/zsh/completions $fpath)

for config_file in ~/.config/zsh/*.zsh; do
  [[ $config_file != *".zshrc" ]] && source "$config_file"
done

autoload -Uz compinit
compinit
