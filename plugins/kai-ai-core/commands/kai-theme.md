---
description: Configura tema visual do Kayoridolfi AI (default | festive | compact | accessible | none)
argument-hint: [show | set <tema>]
---

# /kai-theme

Gerencia o tema visual via `.kai/config.yaml`.

```bash
SUB="${1:-show}"
case "$SUB" in
  show)
    THEME=$(grep -E '^theme:' .kai/config.yaml 2>/dev/null | sed 's/theme:[[:space:]]*//' | tr -d '"' | tr -d "'" || echo "default")
    echo "Tema atual: ${THEME:-default}"
    echo ""
    echo "Disponíveis:"
    echo "  default     — paleta  oficial (laranja #E8550C truecolor)"
    echo "  festive     — paleta vibrante (releases, marcos)"
    echo "  compact     — cores básicas ANSI 16 (CI, terminais limitados)"
    echo "  accessible  — alto contraste + bold (acessibilidade)"
    echo "  none        — sem cores (logs, scripts)"
    ;;
  set)
    THEME="${2:-}"
    [[ -z "$THEME" ]] && { echo "Uso: /kai-theme set <tema>"; exit 1; }
    case "$THEME" in
      default|festive|compact|accessible|none) ;;
      *) echo "Tema inválido: $THEME"; exit 1 ;;
    esac
    mkdir -p .kai
    if grep -q '^theme:' .kai/config.yaml 2>/dev/null; then
      TMP=$(mktemp)
      sed "s/^theme:.*/theme: $THEME/" .kai/config.yaml > "$TMP" && mv "$TMP" .kai/config.yaml
    else
      echo "theme: $THEME" >> .kai/config.yaml
    fi
    echo "✓ Tema definido: $THEME"
    echo "Próximas mensagens Kayoridolfi AI usarão a paleta nova."
    ;;
  *)
    echo "Uso: /kai-theme [show | set <tema>]"
    ;;
esac
```
