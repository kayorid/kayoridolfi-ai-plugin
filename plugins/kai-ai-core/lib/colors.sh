#!/usr/bin/env bash
# kai-ai-core / lib / colors.sh
# Paleta Kayoridolfi AI oficial — laranja  #E8550C como cor primária.
# Resolve tema dinamicamente a partir de .kai/config.yaml ou KAI_THEME.

# shellcheck disable=SC2034

kai_theme() {
  local theme="${KAI_THEME:-}"
  if [[ -z "$theme" && -f .kai/config.yaml ]]; then
    theme=$(grep -E '^theme:' .kai/config.yaml 2>/dev/null | sed 's/theme:[[:space:]]*//' | tr -d '"' | tr -d "'" | head -1)
  fi
  echo "${theme:-default}"
}

kai_load_palette() {
  local theme="$(kai_theme)"
  case "$theme" in
    festive)
      C_PRIMARY='\033[38;2;232;85;12m'      #  orange #E8550C
      C_ACCENT='\033[38;5;201m'             # magenta vibrante (festivo)
      C_SUCCESS='\033[38;5;82m'
      C_WARN='\033[38;5;220m'
      C_DANGER='\033[38;5;196m'
      C_INFO='\033[38;5;87m'
      C_DIM='\033[2m'
      C_BOLD='\033[1m'
      C_RESET='\033[0m'
      ;;
    compact)
      C_PRIMARY='\033[33m'
      C_ACCENT='\033[31m'
      C_SUCCESS='\033[32m'
      C_WARN='\033[33m'
      C_DANGER='\033[31m'
      C_INFO='\033[36m'
      C_DIM='\033[2m'
      C_BOLD='\033[1m'
      C_RESET='\033[0m'
      ;;
    accessible)
      C_PRIMARY='\033[1;31m'
      C_ACCENT='\033[1;33m'
      C_SUCCESS='\033[1;32m'
      C_WARN='\033[1;33m'
      C_DANGER='\033[1;31m'
      C_INFO='\033[1;36m'
      C_DIM=''
      C_BOLD='\033[1m'
      C_RESET='\033[0m'
      ;;
    none|plain|nocolor)
      C_PRIMARY=''
      C_ACCENT=''
      C_SUCCESS=''
      C_WARN=''
      C_DANGER=''
      C_INFO=''
      C_DIM=''
      C_BOLD=''
      C_RESET=''
      ;;
    *)
      # default — paleta Kayoridolfi AI oficial
      C_PRIMARY='\033[38;2;232;85;12m'      #  orange #E8550C (primária da marca)
      C_ACCENT='\033[38;5;208m'             # laranja secundário (gradiente)
      C_SUCCESS='\033[38;5;82m'             # verde
      C_WARN='\033[38;5;220m'               # amarelo
      C_DANGER='\033[38;5;196m'             # vermelho
      C_INFO='\033[38;5;87m'                # cyan
      C_DIM='\033[2m'
      C_BOLD='\033[1m'
      C_RESET='\033[0m'
      ;;
  esac
  export C_PRIMARY C_ACCENT C_SUCCESS C_WARN C_DANGER C_INFO C_DIM C_BOLD C_RESET
}

# Símbolos por tema
kai_load_glyphs() {
  local theme="$(kai_theme)"
  case "$theme" in
    compact|accessible)
      G_OK="[OK]"
      G_WARN="[!]"
      G_FAIL="[X]"
      G_BULLET="*"
      G_DIAMOND=""
      G_HEXAGON=""
      G_SHIELD="(s)"
      ;;
    *)
      G_OK="✓"
      G_WARN="⚠"
      G_FAIL="✗"
      G_BULLET="•"
      G_DIAMOND=""
      G_HEXAGON=""
      G_SHIELD="🛡"
      ;;
  esac
  export G_OK G_WARN G_FAIL G_BULLET G_DIAMOND G_HEXAGON G_SHIELD
}

# Helpers de impressão
kai_say()    { kai_load_palette; kai_load_glyphs; echo -e "${C_PRIMARY}Kayoridolfi AI${C_RESET} ${C_DIM}·${C_RESET} $*"; }
kai_ok()     { kai_load_palette; kai_load_glyphs; echo -e "${C_SUCCESS}${G_OK}${C_RESET} $*"; }
kai_warn()   { kai_load_palette; kai_load_glyphs; echo -e "${C_WARN}${G_WARN}${C_RESET} $*"; }
kai_fail()   { kai_load_palette; kai_load_glyphs; echo -e "${C_DANGER}${G_FAIL}${C_RESET} $*"; }
kai_info()   { kai_load_palette; echo -e "${C_INFO}${C_RESET} $*"; }
kai_rule()   { kai_load_palette; echo -e "${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"; }
