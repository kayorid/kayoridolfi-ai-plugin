---
description: Lista plugins Kayoridolfi AI ativados em ~/.claude/settings.json
---

# /kai-list-plugins

```bash
SETTINGS="${HOME}/.claude/settings.json"
if [[ ! -f "$SETTINGS" ]]; then
  echo "✗ ~/.claude/settings.json não existe. Rode /kai-init primeiro."
  exit 1
fi

if command -v jq >/dev/null 2>&1; then
  echo "Plugins Kayoridolfi AI ativados em $SETTINGS:"
  echo ""
  jq -r '.enabledPlugins // {} | to_entries | map(select(.key | startswith("kai-")))[] | "  \(.value | if . == true then "✓" else "✗" end) \(.key)"' "$SETTINGS"
else
  echo "jq não instalado — não é possível listar."
  exit 1
fi
```

Use para confirmar quais plugins Kayoridolfi AI estão habilitados antes de rodar comandos. Plugin desabilitado não responde a `/kai-*` correspondente.
