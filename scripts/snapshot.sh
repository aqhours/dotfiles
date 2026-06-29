#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
manifest="$repo_dir/tracked-files.txt"
home_dir="${DOTFILES_HOME:-$HOME}"

copy_one() {
  rel=$1

  case "$rel" in
    ''|\#*) return 0 ;;
    /*|../*|*/../*|*/..)
      echo "refusing suspicious path: $rel" >&2
      return 1
      ;;
  esac

  src="$home_dir/$rel"
  dst="$repo_dir/home/$rel"

  if [ ! -f "$src" ]; then
    echo "missing: $rel" >&2
    return 0
  fi

  mkdir -p "$(dirname "$dst")"
  cp -p "$src" "$dst"
  echo "copied: $rel"
}

while IFS= read -r rel || [ -n "$rel" ]; do
  copy_one "$rel"
done < "$manifest"
