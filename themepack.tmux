#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get-tmux-option() {
  local option value default
  option="$1"
  default="$2"
  value="$(tmux show-option -gqv "$option")"

  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$default"
  fi
}

main() {
  local theme
  theme="$(get-tmux-option "@themepack" "basic")"

  if [[ "$theme" == *wal ]]; then
    make_wal
  else
    make -C $CURRENT_DIR
  fi

  if [ -f "$CURRENT_DIR/${theme}.tmuxtheme" ]; then
    tmux source-file "$CURRENT_DIR/${theme}.tmuxtheme"
  else
    tmux source-file "$CURRENT_DIR/powerline/${theme}.tmuxtheme"
  fi
}

make_wal() {
  if [ ! -f $HOME/.config/wal/templates/wal.tmuxsh ]; then
    echo "Copy $CURRENT_DIR/templates/wal.tmuxsh to $HOME/.config/wal/templates/wal.tmuxsh and re-run wal"
    exit 1
  elif [ ! -f $HOME/.cache/wal/wal.tmuxsh ]; then
    echo "Must run wal at least once"
    exit 1
  fi

  src=$HOME/.cache/wal/wal.tmuxsh
  dest=$HOME/.tmux/plugins/tmux-themepack/src/powerline/_colors/wal.tmuxsh

  cp $src $dest

  make -C $CURRENT_DIR powerline/block/wal.tmuxtheme \
       powerline/default/wal.tmuxtheme \
       powerline/double/wal.tmuxtheme
}

main "$@"
