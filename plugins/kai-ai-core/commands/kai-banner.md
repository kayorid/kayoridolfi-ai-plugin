---
description: Mostra o banner ASCII do Kayoridolfi AI Plugin com frase do manifesto
---

# /kai-banner

Execute o script de banner para mostrar a identidade visual do SDK.

```bash
bash "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/session-start-banner.sh" 2>&1 | jq -r '.hookSpecificOutput.additionalContext // .'
```

Use também ao apresentar o SDK em demos, no início de workshops ou para quebrar gelo no canal `#kai-ai-plugin`.
