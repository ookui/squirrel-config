#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source_dir="${RIME_DIR:-$HOME/Library/Rime}"
rsync_args=(-ac --delete --itemize-changes)
if [[ $# -gt 0 ]]; then
  if [[ $# -eq 1 && "$1" == "--dry-run" ]]; then
    rsync_args+=(--dry-run)
  else
    echo "Usage: bash scripts/sync-from-rime.sh [--dry-run]" >&2
    exit 2
  fi
fi

source_dir="$(cd "$source_dir" && pwd -P)"
if [[ "$repo_dir/" == "$source_dir/"* || "$source_dir/" == "$repo_dir/"* ]]; then
  echo "Rime source and Git working copy must be separate directories." >&2
  exit 1
fi
if [[ ! -f "$source_dir/default.yaml" || ! -f "$source_dir/squirrel.custom.yaml" ]]; then
  echo "Missing default.yaml or squirrel.custom.yaml in $source_dir" >&2
  exit 1
fi
if [[ "$(git -C "$repo_dir" rev-parse --show-toplevel)" != "$repo_dir" ]]; then
  echo "The script must be inside the squirrel-config Git working copy." >&2
  exit 1
fi

# Excluded paths are protected from deletion. Only this separate working copy
# is changed; the live Rime source is read-only. Managed documentation and scripts
# stay in the working copy even when absent from the live configuration.
rsync "${rsync_args[@]}" \
  --exclude='.git/' \
  --exclude='.DS_Store' \
  --exclude='/build/' \
  --exclude='*.userdb/' \
  --exclude='*.userdb.txt' \
  --exclude='/sync/' \
  --exclude='/installation.yaml' \
  --exclude='/user.yaml' \
  --exclude='/appearance-backup-*/' \
  --exclude='*.gram' \
  --exclude='/README.md' \
  --exclude='/README.rime-ice.md' \
  --exclude='/.gitignore' \
  --exclude='/.gitattributes' \
  --exclude='/AGENTS.md' \
  --exclude='/scripts/' \
  --exclude='/docs/' \
  "$source_dir/" "$repo_dir/"

git -C "$repo_dir" status --short
