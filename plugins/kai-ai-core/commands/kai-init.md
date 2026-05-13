---
description: Setup interativo do Kayoridolfi AI no ~/.claude/settings.json — primeira instalação para devs novos
---

# /kai-init

Configura `~/.claude/settings.json` com o marketplace Kayoridolfi AI e todos os 9 plugins habilitados. Faz backup automático do settings anterior.

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/init-wizard.sh"
```

Use **uma vez** ao instalar o Kayoridolfi AI no seu ambiente. Para novos squads dentro do , isto deve ser executado pelo Tech Lead ou pelo AI Champion.

Pós-execução:
1. Reinicie o Claude Code.
2. Rode `/kai-doctor` para validar.
3. No repo do squad, rode `/kai-bootstrap`.
