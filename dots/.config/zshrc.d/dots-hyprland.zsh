# Use the generated color scheme (when terminal theming is enabled)
_sequences="$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt"
_config="$HOME/.config/illogical-impulse/config.json"
_apply=1

if [[ -f "$_config" ]]; then
  _apply=$(jq -r '.appearance.wallpaperTheming.enableTerminal // false' "$_config" 2>/dev/null)
fi

if [[ "$_apply" == "true" && -f "$_sequences" ]]; then
  cat "$_sequences"
fi

unset _sequences _config _apply
