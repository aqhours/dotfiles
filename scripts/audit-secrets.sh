#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_dir"

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep (rg) is required for this audit" >&2
  exit 2
fi

high_confidence='(BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{30,}|xox[baprs]-[A-Za-z0-9-]+|npm_[A-Za-z0-9]{20,})'
quoted_assignment='(api[_-]?key|access[_-]?token|auth[_-]?token|password|secret)[^[:alnum:]_:-]{0,8}[:=][[:space:]]*["'\''][^"'\'']{12,}["'\'']?'

found=false

if rg -n --hidden \
  --glob '!scripts/audit-secrets.sh' \
  --glob '!docs/**' \
  --glob '!README.md' \
  "$high_confidence" .; then
  found=true
fi

if rg -n -i --hidden \
  --glob '!scripts/audit-secrets.sh' \
  --glob '!docs/**' \
  --glob '!README.md' \
  "$quoted_assignment" .; then
  found=true
fi

if [ "$found" = true ]; then
  echo "Potential secret found. Review before committing." >&2
  exit 1
fi

echo "No obvious secrets matched."
