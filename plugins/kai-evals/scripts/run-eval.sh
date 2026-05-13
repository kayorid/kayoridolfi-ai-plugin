#!/usr/bin/env bash
# kai-evals / scripts / run-eval.sh

set -euo pipefail

FEATURE="${1:-}"
[[ -z "$FEATURE" ]] && { echo "Uso: run-eval.sh <feature-slug>"; exit 1; }

DIR="evals/$FEATURE"
[[ ! -d "$DIR" ]] && { echo "Eval não existe. Crie com /kai-evals-init $FEATURE"; exit 1; }
[[ ! -x "$DIR/runner.sh" ]] && { echo "$DIR/runner.sh não executável"; exit 1; }

bash "$DIR/runner.sh"
