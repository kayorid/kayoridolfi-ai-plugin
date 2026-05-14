#!/usr/bin/env bash
# install.sh — Instalador do Kayoridolfi AI Plugin.
#
# O Claude Code valida `extraKnownMarketplaces` no settings.json e só aceita
# marketplaces remotos lá (github, etc). Para marketplace local, a única
# forma canônica é via `/plugin marketplace add <path>` rodado dentro do
# próprio Claude Code — que escreve em ~/.claude/plugins/known_marketplaces.json
# e registra a instalação corretamente.
#
# Este script:
#   • Modo `local` (default): valida dependências, ajusta permissões,
#                              e instrui o usuário a registrar via Claude Code
#                              (porque tentar escrever em settings.json local
#                              quebra a validação do schema).
#   • Modo `github`:           escreve marketplace em settings.json + habilita
#                              os 9 plugins. Funciona porque github é shape
#                              aceito pelo schema.
#
# Uso:
#   bash scripts/install.sh                    # modo local — instrui setup manual
#   bash scripts/install.sh github             # marketplace GitHub (kayorid/kayoridolfi-ai-plugin)
#   bash scripts/install.sh github user/fork   # marketplace GitHub custom

set -euo pipefail

MODE="${1:-local}"
REPO="${2:-kayorid/kayoridolfi-ai-plugin}"
SETTINGS="$HOME/.claude/settings.json"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

C_OK=$'\033[38;5;82m'
C_WARN=$'\033[38;5;220m'
C_ERR=$'\033[38;5;196m'
C_BOLD=$'\033[1m'
C_DIM=$'\033[2m'
C_RESET=$'\033[0m'

ok()   { printf "  ${C_OK}✓${C_RESET} %s\n" "$1"; }
warn() { printf "  ${C_WARN}⚠${C_RESET} %s\n" "$1"; }
err()  { printf "  ${C_ERR}✗${C_RESET} %s\n" "$1" >&2; }
hint() { printf "  ${C_DIM}▸${C_RESET} %s\n" "$1"; }

printf "\n${C_BOLD}Kayoridolfi AI Plugin — instalador${C_RESET}\n"
printf "${C_DIM}─────────────────────────────────${C_RESET}\n\n"

# 1. dependências
command -v jq  >/dev/null 2>&1 || { err "jq não encontrado. Instale: brew install jq | apt-get install jq"; exit 1; }
command -v git >/dev/null 2>&1 || { err "git não encontrado."; exit 1; }
ok "dependências: jq, git"

# 2. permissões dos scripts
find "$REPO_ROOT" -name "*.sh" -exec chmod +x {} \; 2>/dev/null
ok "scripts +x"

# 3. fluxo por modo
case "$MODE" in
  local)
    printf "\n${C_BOLD}Marketplace local detectado.${C_RESET}\n\n"
    printf "Para marketplace local, o Claude Code exige registro via comando interno\n"
    printf "${C_DIM}(o schema de settings.json não aceita source=local em extraKnownMarketplaces).${C_RESET}\n\n"
    printf "${C_BOLD}Próximos passos — execute dentro do Claude Code:${C_RESET}\n\n"
    hint "1. Registrar o marketplace:"
    printf "       ${C_BOLD}/plugin marketplace add %s${C_RESET}\n\n" "$REPO_ROOT"
    hint "2. Instalar os 10 plugins:"
    printf "       ${C_BOLD}/plugin install kai-ai-core@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-bootstrap@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-sdd@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-review@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-observability@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-security@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-retro@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-cost@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-evals@kai${C_RESET}\n"
    printf "       ${C_BOLD}/plugin install kai-intel@kai${C_RESET}\n\n"
    hint "3. Validar:"
    printf "       ${C_BOLD}/kai-doctor${C_RESET}\n\n"
    hint "Alternativa: usar marketplace publicado no GitHub (sem clonar):"
    printf "       ${C_BOLD}bash scripts/install.sh github${C_RESET}\n\n"
    printf "${C_OK}${C_BOLD}Pronto para registrar.${C_RESET}\n\n"
    ;;
  github)
    if [[ -f "$SETTINGS" ]]; then
      if ! jq empty "$SETTINGS" 2>/dev/null; then
        err "$SETTINGS existe mas é JSON inválido."
        exit 1
      fi
      BACKUP="$SETTINGS.bak.$(date +%Y%m%d-%H%M%S)"
      cp "$SETTINGS" "$BACKUP"
      ok "backup: $BACKUP"
      CONTENT=$(cat "$SETTINGS")
    else
      mkdir -p "$(dirname "$SETTINGS")"
      CONTENT='{}'
      ok "criando $SETTINGS"
    fi

    UPDATED=$(echo "$CONTENT" | jq --arg repo "$REPO" '
      .extraKnownMarketplaces.kai = {
        source: { source: "github", repo: $repo }
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
          "kai-evals@kai": true,
          "kai-intel@kai": true
        })
    ')

    echo "$UPDATED" | jq '.' > "$SETTINGS"
    ok "marketplace 'kai' configurado (github: $REPO)"
    ok "9 plugins habilitados"

    printf "\n${C_BOLD}Próximos passos:${C_RESET}\n"
    hint "1. Reinicie o Claude Code."
    hint "2. /kai-doctor para validar."
    hint "3. /kai-bootstrap no repo do seu squad."
    hint "4. Primeira spec: /kai-spec."
    printf "\n${C_OK}${C_BOLD}✨ Instalado via GitHub.${C_RESET}\n\n"
    ;;
  *)
    err "modo desconhecido: $MODE (use 'local' ou 'github')"
    exit 1
    ;;
esac
