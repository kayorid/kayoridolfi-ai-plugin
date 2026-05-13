---
description: Snapshot reversível de .kai/ e specs ativas (create / list / restore)
argument-hint: <create|list|restore> [tag-ou-nome]
---

# /kai-snapshot

Backup reversível antes de operações de risco (re-bootstrap, migração major, refator de contexto).

## Subcomandos

- `/kai-snapshot create [tag]` — cria snapshot atual.
- `/kai-snapshot list` — lista snapshots existentes.
- `/kai-snapshot restore <nome>` — restaura snapshot (faz backup do estado atual antes).

Execute via:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/snapshot.sh" $ARGUMENTS
```

Snapshots ficam em `.kai/_snapshots/`. Recomende adicionar `.kai/_snapshots/` ao `.gitignore` se squad não quiser versioná-los.
