#!/usr/bin/env bash
# kai-ai-core / telemetry.sh — telemetria opt-in 100% local

set -eo pipefail

TEL_DIR=".kai/telemetry"
OPTIN="$TEL_DIR/opt-in"
COUNTERS="$TEL_DIR/usage.json"

ensure_dir() { mkdir -p "$TEL_DIR"; }

is_enabled() { [[ -f "$OPTIN" ]]; }

cmd_status() {
  if is_enabled; then
    echo "telemetria: ENABLED (local-only, sem rede)"
    [[ -f "$COUNTERS" ]] && echo "contadores: $(jq -r '.events | length' "$COUNTERS" 2>/dev/null || echo 0) tipos rastreados"
  else
    echo "telemetria: DISABLED (opt-out por padrão)"
  fi
}

cmd_enable() {
  ensure_dir
  touch "$OPTIN"
  [[ -f "$COUNTERS" ]] || echo '{"events":{},"started":"'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}' > "$COUNTERS"
  echo "telemetria habilitada. Dados ficam em $TEL_DIR/ — nada sai da máquina."
}

cmd_disable() {
  rm -rf "$TEL_DIR"
  echo "telemetria desabilitada. $TEL_DIR/ removido."
}

cmd_show() {
  if ! is_enabled; then
    echo "telemetria desabilitada. Rode '/kai-telemetry enable' para começar."
    return
  fi
  if [[ ! -f "$COUNTERS" ]]; then
    echo "sem dados ainda."
    return
  fi
  echo "Uso agregado (desde $(jq -r '.started' "$COUNTERS")):"
  echo
  jq -r '.events | to_entries | sort_by(-.value.count) | .[] | "  \(.value.count | tostring | (. + "      ")[0:6])  \(.key)  (último: \(.value.last))"' "$COUNTERS"
}

cmd_reset() {
  if ! is_enabled; then
    echo "telemetria desabilitada — nada a resetar." >&2
    exit 0
  fi
  echo '{"events":{},"started":"'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}' > "$COUNTERS"
  echo "contadores resetados (opt-in preservado)."
}

# Modo "record" — chamado por hooks/comandos internamente
cmd_record() {
  is_enabled || exit 0
  local event="${1:-unknown}"
  ensure_dir
  [[ -f "$COUNTERS" ]] || echo '{"events":{},"started":"'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}' > "$COUNTERS"
  local now tmp
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  tmp=$(mktemp)
  jq --arg e "$event" --arg ts "$now" \
    '.events[$e] = {count: ((.events[$e].count // 0) + 1), last: $ts}' \
    "$COUNTERS" > "$tmp" && mv "$tmp" "$COUNTERS"
}

main() {
  local sub="${1:-status}"
  case "$sub" in
    status) cmd_status ;;
    enable) cmd_enable ;;
    disable) cmd_disable ;;
    show) cmd_show ;;
    reset) cmd_reset ;;
    record) shift; cmd_record "$@" ;;
    *) echo "uso: kai-telemetry <status|enable|disable|show|reset>" >&2; exit 2 ;;
  esac
}

main "$@"
