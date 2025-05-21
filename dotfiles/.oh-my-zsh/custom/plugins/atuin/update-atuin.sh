#!/usr/bin/env bash

echo "Updating atuin plugin ..."

cd "$(dirname "$0")"
(
  set -x
  curl -sLO https://raw.githubusercontent.com/atuinsh/atuin/refs/heads/main/atuin.plugin.zsh
)

atuin gen-completions --shell zsh --out-dir .
