---
description: Tutorial guiado do Kayoridolfi AI num sandbox local — passa pelo ciclo SDD completo em 45-60 min
argument-hint: [init|roteiro|reset]
---

# /kai-tutorial

Onboarding hands-on para devs novos no Kayoridolfi AI.

**Subcomandos:**

- `/kai-tutorial init` — cria sandbox em `~/.kai/tutorial-sandbox/` com repositório fictício "DemoTrading".
- `/kai-tutorial roteiro` — exibe o roteiro passo-a-passo.
- `/kai-tutorial reset` — remove sandbox para recomeçar.

```bash
case "${1:-init}" in
  init)
    bash "${CLAUDE_PLUGIN_ROOT}/scripts/tutorial-init.sh"
    ;;
  roteiro)
    cat "${CLAUDE_PLUGIN_ROOT}/scripts/tutorial-roteiro.md"
    ;;
  reset)
    rm -rf "${HOME}/.kai/tutorial-sandbox"
    echo "✓ Sandbox removido. Rode /kai-tutorial init para recomeçar."
    ;;
esac
```

Após concluir, compartilhe `tutorial-completed.md` com seu AI Champion para registro.
