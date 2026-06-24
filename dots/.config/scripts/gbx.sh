#!/usr/bin/env zsh
# interactive branch delete (gum)

force=0
typeset base exclude mode selected branch count line repo rc checkout header
typeset -a branches merged_list display merged_branches unmerged_branches to_delete skipped

while [[ $1 == -f || $1 == -D || $1 == --force ]]; do
  force=1
  shift
done

git rev-parse --is-inside-work-tree &>/dev/null || {
  gum style --foreground 1 "Not a git repository"
  exit 1
}

checkout=$(git branch --show-current)
base=${1:-$checkout}

if [[ -n $1 ]]; then
  git rev-parse --verify "$base^{commit}" &>/dev/null || {
    gum style --foreground 1 "Unknown ref: $base"
    exit 1
  }
elif [[ -z $base ]]; then
  gum style --foreground 1 "Detached HEAD — pass a branch or remote ref (e.g. origin/main)"
  exit 1
fi

exclude=$base
[[ $base == */* ]] && exclude=${base#*/}

repo=$(git rev-parse --show-toplevel)

print
gum style --border double --border-foreground 212 --padding "0 1" --bold "Delete branches"
if [[ -n $checkout && $checkout != "$exclude" ]]; then
  gum style --foreground 240 "in ${repo}  •  against: ${base}  •  checked out: ${checkout}"
else
  gum style --foreground 240 "in ${repo}  •  against: ${base}"
fi
print

if (( ! force )); then
  mode=$(gum choose --height 4 --header "Delete mode" \
    "safe — merged into ${base} (-d)" \
    "force — include unmerged (-D)") || exit 0
  [[ $mode == force* ]] && force=1
fi

merged_list=("${(@f)$(git branch --merged "$base" | command sed 's/^[* ] //')}")
merged_list=(${merged_list:#})

branches=("${(@f)$(git for-each-ref refs/heads/ --sort=-committerdate \
  --format='%(refname:short)')}")
branches=(${branches:#})
branches=(${branches:#$exclude})

if (( ${#branches} == 0 )); then
  gum style --foreground 3 "No other local branches to delete"
  exit 0
fi

for branch in $branches; do
  [[ -z $branch ]] && continue
  if (( ${merged_list[(Ie)$branch]} )); then
    merged_branches+=("$branch")
  else
    unmerged_branches+=("$branch")
  fi
done

if (( force )); then
  for branch in $branches; do
    [[ -z $branch ]] && continue
    if (( ${merged_list[(Ie)$branch]} )); then
      display+=("$branch  ✓")
    else
      display+=("$branch  ○")
    fi
  done
else
  for branch in $merged_branches; do
    display+=("$branch  ✓")
  done
  for branch in $unmerged_branches; do
    display+=("$(print -Pn "%F{240}${branch}  ○%f")")
  done
fi

if (( ${#display} == 0 )); then
  gum style --foreground 3 "No other local branches to delete"
  exit 0
fi

header="✓ merged • ○ unmerged"
(( ! force && ${#unmerged_branches} > 0 )) && header+=" • (grey = not deletable with -d)"

selected=$(print -rl -- $display | gum filter --no-limit --no-strip-ansi --fuzzy --height=20 \
  --placeholder "Type to filter…" \
  --header "$header" \
  --selected-indicator.foreground=10) || exit 0

[[ -z $selected ]] && exit 0

for line in ${(f)selected}; do
  branch=$(print -r -- "$line" | command sed $'s/\x1b\\[[0-9;]*m//g')
  branch="${branch%  ✓}"
  branch="${branch%  ○}"
  if (( force )) || (( ${merged_list[(Ie)$branch]} )); then
    to_delete+=("$branch")
  else
    skipped+=("$branch")
  fi
done

(( ${#skipped} > 0 )) && gum style --foreground 240 \
  "Skipping ${#skipped} unmerged branch(es) — use -D to delete"

if (( ${#to_delete} == 0 )); then
  gum style --foreground 3 "No branches to delete"
  exit 0
fi

count=${#to_delete}
gum confirm --affirmative "Delete" --negative "Cancel" \
  "Delete ${count} branch(es)?" || exit 0

rc=0
for branch in $to_delete; do
  if (( force )); then
    git branch -D "$branch" || rc=1
  else
    git branch -d "$branch" || rc=1
  fi
done

if (( rc == 0 )); then
  gum style --foreground 10 "Deleted ${count} branch(es)"
else
  gum style --foreground 3 "Some branches could not be deleted"
fi

exit $rc
