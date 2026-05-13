#!/usr/bin/env bash
# kai-sdd / spec-from-ticket.sh
# Gera docs/specs/_active/<YYYY-MM-DD>-<ticket>/requirements.md a partir de um ticket Jira.
# Uso: spec-from-ticket.sh <TICKET-KEY>

set -uo pipefail

KEY="${1:-}"
if [[ -z "$KEY" ]]; then
  echo "uso: spec-from-ticket.sh <TICKET-KEY>" >&2
  exit 1
fi

# Resolve adapter path: prefer KAI_SDK_ROOT env, fallback ao próprio kai repo via plugin
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${KAI_SDK_ROOT:-}" && -x "$KAI_SDK_ROOT/integrations/jira/adapter.sh" ]]; then
  ADAPTER="$KAI_SDK_ROOT/integrations/jira/adapter.sh"
elif [[ -x "$SCRIPT_DIR/../../../integrations/jira/adapter.sh" ]]; then
  ADAPTER="$SCRIPT_DIR/../../../integrations/jira/adapter.sh"
else
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  ADAPTER="$REPO_ROOT/integrations/jira/adapter.sh"
fi
if [[ ! -x "$ADAPTER" ]]; then
  echo "[kai-sdd] adapter Jira ausente em $ADAPTER" >&2
  exit 1
fi

TICKET_JSON=$(bash "$ADAPTER" "$KEY")
if [[ -z "$TICKET_JSON" ]]; then
  echo "[kai-sdd] adapter retornou vazio para $KEY" >&2
  exit 1
fi

TITLE=$(echo "$TICKET_JSON" | jq -r '.title')
DESC=$(echo "$TICKET_JSON" | jq -r '.description')
TYPE=$(echo "$TICKET_JSON" | jq -r '.type')
REPORTER=$(echo "$TICKET_JSON" | jq -r '.reporter')
URL=$(echo "$TICKET_JSON" | jq -r '.url')

DATE=$(date +%F)
SLUG_KEY=$(echo "$KEY" | tr '[:upper:]' '[:lower:]')
SLUG_DIR="docs/specs/_active/${DATE}-${SLUG_KEY}"
mkdir -p "$SLUG_DIR"

cat > "$SLUG_DIR/requirements.md" <<EOF
# $TITLE

> Spec gerada a partir de **[$KEY]($URL)** — $TYPE · reportado por $REPORTER
> Gerado por \`/kai-spec-from-ticket\` em $(date -u +%FT%TZ)

## Contexto do ticket

$DESC

## User stories

- **US-1** _(preencher a partir do contexto acima — exemplo:)_ Como usuário X, quero Y para Z.

## Critérios de aceitação (EARS)

- **CA-1** Quando _(condição)_, o sistema **deve** _(resposta esperada)_.

## Fora de escopo

- _(itens explicitamente fora — preencher na fase clarify)_

## Clarifications

- **Q:** _(pergunta levantada pelo agente)_
  - **R:** _(resposta após discussão com stakeholder)_

---

**Próximos passos:**

1. \`/kai-sdd-clarify\` — refinar ambiguidades
2. \`/kai-sdd-design\` — gerar design.md
3. \`/kai-sdd-tasks\` — gerar tasks.md
EOF

echo "✓ Spec criada em $SLUG_DIR/requirements.md"
echo "  Ticket origem: $KEY"
echo "  Próximo passo: /kai-sdd-clarify $SLUG_DIR"
