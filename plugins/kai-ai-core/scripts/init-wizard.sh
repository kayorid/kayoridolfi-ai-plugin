#!/usr/bin/env bash
# kai-ai-core / scripts / init-wizard.sh
# Setup interativo do Kayoridolfi AI no ~/.claude/settings.json

set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$(dirname "$(realpath "$0")")")}"
# shellcheck disable=SC1091
source "$PLUGIN_ROOT/lib/colors.sh" 2>/dev/null || true
kai_load_palette 2>/dev/null || true

P="${C_PRIMARY:-}"; B="${C_BOLD:-}"; D="${C_DIM:-}"; R="${C_RESET:-}"; S="${C_SUCCESS:-}"; W="${C_WARN:-}"; I="${C_INFO:-}"

bash "$PLUGIN_ROOT/lib/ascii.sh" welcome primary 2>/dev/null || true

printf "\n${P}${B}Setup Kayoridolfi AI no Claude Code${R}\n${D}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}\n\n"

SETTINGS="${HOME}/.claude/settings.json"
mkdir -p "$(dirname "$SETTINGS")"

# Backup
if [[ -f "$SETTINGS" ]]; then
  BACKUP="${SETTINGS}.bak.$(date -u +%Y%m%dT%H%M%SZ)"
  cp "$SETTINGS" "$BACKUP"
  printf "  ${I}▸${R} Backup do settings atual: ${D}%s${R}\n" "$BACKUP"
fi

# Lê ou cria settings
if [[ -f "$SETTINGS" ]] && command -v jq >/dev/null 2>&1; then
  if ! jq empty "$SETTINGS" 2>/dev/null; then
    printf "  ${W}⚠${R} ~/.claude/settings.json existe mas é JSON inválido. Saindo.\n"
    exit 1
  fi
  CONTENT=$(cat "$SETTINGS")
else
  CONTENT='{}'
fi

# Detecta repo Kayoridolfi AI
REPO_DEFAULT="kayorid/kayoridolfi-ai-plugin"
printf "\n${B}1. Repositório do marketplace Kayoridolfi AI${R}\n"
printf "   ${D}(default: %s)${R}\n" "$REPO_DEFAULT"
read -r -p "   Repo: " REPO
REPO="${REPO:-$REPO_DEFAULT}"

# Adiciona marketplace + plugins
printf "\n${B}2. Configurando marketplace e plugins...${R}\n"

UPDATED=$(echo "$CONTENT" | jq --arg repo "$REPO" '
  .extraKnownMarketplaces.kai = {
    "source": {
      "source": "github",
      "repo": $repo
    }
  }
  | .enabledPlugins = ((.enabledPlugins // {}) + {
    "kai-ai-core@kai": true,
    "kai-bootstrap@kai": true,
    "kai-sdd@kai": true,
    "kai-review@kai": true,
    "kai-observability@kai": true,
    "kai-security@kai": true,
    "kai-retro@kai": true,
    "kai-cost@kai": true,
    "kai-evals@kai": true
  })
')

echo "$UPDATED" | jq '.' > "$SETTINGS"

printf "  ${S}✓${R} Marketplace ${B}kai${R} → ${D}%s${R}\n" "$REPO"
printf "  ${S}✓${R} 9 plugins habilitados (kai-ai-core, kai-bootstrap, kai-sdd, kai-review, kai-observability, kai-security, kai-retro, kai-cost, kai-evals)\n"

printf "\n${B}3. Próximos passos${R}\n"
printf "  ${S}▸${R} Reinicie o Claude Code\n"
printf "  ${S}▸${R} Rode ${B}/kai-doctor${R} para validar instalação\n"
printf "  ${S}▸${R} No primeiro repo do squad: ${B}/kai-bootstrap${R}\n\n"

printf "${S}${B}✨ Tudo pronto. Bem-vindo ao Kayoridolfi AI. ⬡${R}\n\n"
