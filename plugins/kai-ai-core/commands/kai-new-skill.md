---
description: Cria scaffolding de skill custom do squad em .kai/skills/
argument-hint: <slug-em-kebab-case>
---

# /kai-new-skill

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/new-skill.sh" $ARGUMENTS
```

Cria estrutura padrão `.kai/skills/kai-<slug>/` com `SKILL.md`, `references/`, `scripts/`, `assets/templates/` e atualiza índice.

Use quando perceber padrão repetido no squad (ex: "checklist de migração de DB", "review específico de smart contract") que mereça skill formal local.

Para promover skill local à constitution: `/kai-retro-promote`.
