#!/usr/bin/env bash
# kai-intel / drift-check.sh — compara spec/plan ↔ código real
# Exit codes: 0 = sem drift HIGH; 1 = drift HIGH detectado (com --ci)

set -uo pipefail

FEATURE_SLUG=""
CI_MODE=0
JSON_MODE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ci) CI_MODE=1; shift ;;
    --json) JSON_MODE=1; shift ;;
    -*) echo "flag desconhecida: $1" >&2; exit 2 ;;
    *) FEATURE_SLUG="$1"; shift ;;
  esac
done

# Localiza feature ativa
if [[ -z "$FEATURE_SLUG" ]]; then
  LATEST=$(find docs/specs/_active -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort | tail -1)
  if [[ -z "$LATEST" ]]; then
    echo "Nenhuma spec ativa encontrada em docs/specs/_active/." >&2
    exit 2
  fi
  FEATURE_DIR="$LATEST"
else
  FEATURE_DIR=$(find docs/specs/_active -maxdepth 1 -mindepth 1 -type d -name "*$FEATURE_SLUG*" 2>/dev/null | head -1)
  if [[ -z "$FEATURE_DIR" ]]; then
    echo "spec não encontrada para slug: $FEATURE_SLUG" >&2
    exit 2
  fi
fi

FEATURE_NAME=$(basename "$FEATURE_DIR")
TS=$(date -u +%Y%m%dT%H%M%SZ)
REPORT_DIR=".kai/intel/drift"
mkdir -p "$REPORT_DIR"
REPORT="$REPORT_DIR/${FEATURE_NAME}-${TS}.md"

HIGH=0
MEDIUM=0
LOW=0
FINDINGS_JSON='[]'

add_finding() {
  local sev="$1" desc="$2" detail="${3:-}"
  case "$sev" in
    HIGH) HIGH=$((HIGH+1)) ;;
    MEDIUM) MEDIUM=$((MEDIUM+1)) ;;
    LOW) LOW=$((LOW+1)) ;;
  esac
  FINDINGS_JSON=$(echo "$FINDINGS_JSON" | jq \
    --arg sev "$sev" --arg desc "$desc" --arg detail "$detail" \
    '. + [{severity:$sev, description:$desc, detail:$detail}]')
}

# 1. Arquivos prometidos no plan.md ausentes
PLAN="$FEATURE_DIR/plan.md"
if [[ -f "$PLAN" ]]; then
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    if [[ ! -e "$path" ]]; then
      add_finding HIGH "arquivo prometido ausente" "$path"
    fi
  done < <(grep -oE '\b([a-zA-Z0-9_./-]+/[a-zA-Z0-9_./-]+\.(ts|js|py|go|rb|java|kt|rs|sh|md|yml|yaml|json))\b' "$PLAN" 2>/dev/null | sort -u)
fi

# 2. Símbolos em design.md ausentes do código
DESIGN="$FEATURE_DIR/design.md"
if [[ -f "$DESIGN" ]]; then
  while IFS= read -r sym; do
    [[ -z "$sym" || ${#sym} -lt 4 ]] && continue
    if ! git grep -q -w "$sym" -- ':!docs' ':!.kai' 2>/dev/null; then
      add_finding MEDIUM "símbolo de design ausente do código" "$sym"
    fi
  done < <(grep -oE '`[A-Za-z_][A-Za-z0-9_]{3,40}`' "$DESIGN" 2>/dev/null | tr -d '`' | sort -u | head -30)
fi

# 3. Decisões em decisions.md heurística: "não usar X" mas código tem X
DECISIONS="$FEATURE_DIR/decisions.md"
if [[ -f "$DECISIONS" ]]; then
  while IFS= read -r forbidden; do
    [[ -z "$forbidden" || ${#forbidden} -lt 4 ]] && continue
    if git grep -q -w "$forbidden" -- ':!docs' ':!.kai' 2>/dev/null; then
      add_finding LOW "decisão potencialmente contraditada" "menciona não-usar '$forbidden' mas código referencia"
    fi
  done < <(grep -iE 'não usar|nao usar|evitar|proibido|forbidden|do not use' "$DECISIONS" 2>/dev/null | grep -oE '`[A-Za-z_][A-Za-z0-9_]{3,30}`' | tr -d '`' | sort -u)
fi

TOTAL=$((HIGH+MEDIUM+LOW))

if [[ "$JSON_MODE" -eq 1 ]]; then
  jq -n \
    --arg feature "$FEATURE_NAME" \
    --arg ts "$TS" \
    --argjson high "$HIGH" \
    --argjson medium "$MEDIUM" \
    --argjson low "$LOW" \
    --argjson findings "$FINDINGS_JSON" \
    '{feature: $feature, ts: $ts, summary: {high: $high, medium: $medium, low: $low}, findings: $findings}'
else
  {
    echo "# Drift report — $FEATURE_NAME"
    echo
    echo "**Gerado:** $TS"
    echo "**Achados:** HIGH=$HIGH · MEDIUM=$MEDIUM · LOW=$LOW · total=$TOTAL"
    echo
    if [[ "$TOTAL" -eq 0 ]]; then
      echo "✅ Nenhum drift detectado."
    else
      echo "## Achados"
      echo
      echo "$FINDINGS_JSON" | jq -r '.[] | "- **[\(.severity)]** \(.description): `\(.detail)`"'
    fi
  } | tee "$REPORT"
fi

if [[ "$CI_MODE" -eq 1 && "$HIGH" -gt 0 ]]; then
  exit 1
fi
exit 0
