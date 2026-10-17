#!/usr/bin/env bash
# TPM executes *.tmux entry points. Keep runtime routing in native tmux bindings.
set -euo pipefail
plugin_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
tmux source-file "$plugin_dir/scripts/navigation.conf"
