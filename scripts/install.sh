#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
manifest="$repo_dir/tracked-files.txt"
home_dir="${DOTFILES_HOME:-$HOME}"
apply=false

usage() {
  cat <<'USAGE'
Usage:
  scripts/install.sh --dry-run
  scripts/install.sh --apply

Creates symlinks from this repository's home/ tree into $HOME.
Existing files are backed up before replacement when --apply is used.
USAGE
}

case "${1:---dry-run}" in
  --dry-run) apply=false ;;
  --apply) apply=true ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

timestamp=$(date +%Y%m%d-%H%M%S)
backup_dir="$home_dir/.dotfiles-backup/$timestamp"

link_one() {
  rel=$1

  case "$rel" in
    ''|\#*) return 0 ;;
    /*|../*|*/../*|*/..)
      echo "refusing suspicious path: $rel" >&2
      return 1
      ;;
  esac

  src="$repo_dir/home/$rel"
  target="$home_dir/$rel"

  if [ ! -f "$src" ]; then
    echo "skip missing in repo: $rel" >&2
    return 0
  fi

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
    echo "ok: $rel"
    return 0
  fi

  if [ "$apply" = false ]; then
    if [ -e "$target" ] || [ -L "$target" ]; then
      echo "would back up and link: $rel"
    else
      echo "would link: $rel"
    fi
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] || [ -L "$target" ]; then
    mkdir -p "$(dirname "$backup_dir/$rel")"
    mv "$target" "$backup_dir/$rel"
    echo "backed up: $rel"
  fi

  ln -s "$src" "$target"
  echo "linked: $rel"
}

while IFS= read -r rel || [ -n "$rel" ]; do
  link_one "$rel"
done < "$manifest"
